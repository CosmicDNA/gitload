







#!/bin/sh
BOLD=1
BLINKING=5
RED=31

gitload(){
  # Function to display usage information
  local app_name=$(basename "$0")
  usage() {
      echo "Usage: $app_name [-e data filename] [-d filename] [-r filename] [-i shell] [-h] [encrypted_ssh_password_file encrypted_keychain_args_file]\n\
      encrypted_ssh_password_file encrypted_keychain_args_file \tLoad ssh and gpg key\n\
      -e data filename\t\t\t\t\t\tEncrypt data to filename\n\
      -d filename\t\t\t\t\t\tDecrypt filename\n\
      -r filename\t\t\t\t\t\tRemove encrypted file\n\
      -i shell\t\t\t\t\t\t\tInstall source hook to terminal rc file\n\
      -h\t\t\t\t\t\t\tDisplay this help message"
  }

  local user_keys_dir="/var/lib/gitload/keys/$USER"

  # Initialize variables
  local DATA=""
  local FILENAME=""
  local ENCRYPT=false
  local DECRYPT=false
  local SUPPORT=false

  # Parse command-line options using getopts
  while getopts ":e:d:r:i:h" opt; do
    case ${opt} in
      e)
        ENCRYPT=true
        DATA=$OPTARG
        shift $((OPTIND-1))
        FILENAME=$1
        ;;
      d)
        DECRYPT=true
        FILENAME=$OPTARG
        ;;
      r)
        SUPPORT=true
        FILENAME=$OPTARG
        remove_encrypted_file() {
          if [ -f "$1" ]; then
              rm "$1"
              echo "File $1 has been removed."
          else
              echo "File $1 does not exist."
          fi
        }
        remove_encrypted_file "$user_keys_dir/$FILENAME"
        ;;
      i)
        install_source_hook() {
          local shell=$1
          local source_line=$2
          local rc_file=""

          case "$shell" in
            bash)
              rc_file="$HOME/.bashrc"
              ;;
            zsh)
              rc_file="$HOME/.zshrc"
              ;;
            *)
              echo "Unsupported shell."
              return
              ;;
          esac

          local comment="# Added by ${app_name}"
          # Check if the source hook is already present
          if grep -Fxq "$comment" "$rc_file"; then
            echo "Source hook already present in $rc_file"
          else
            echo -e "\n$comment\n. $source_line" >> "$rc_file"
            echo "Source hook added to $rc_file"
          fi

        }
        SUPPORT=true
        SHELL=$OPTARG
        if [ -z "$SHELL" ]; then
          echo "Error: Shell type is required for installation."
          usage
        else
          echo "Installing source hook..."
          install_source_hook "$SHELL" /usr/local/gitload/gitload.sh
        fi
        ;;
      h | *)
        SUPPORT=true
        usage
        ;;
    esac
  done

  . /usr/local/gitload/gitload-decryptData.sh
  # Perform actions based on the options provided
  if $ENCRYPT; then
    if [ -z "$DATA" ] || [ -z "$FILENAME" ]; then
      echo "Error: Data and filename are required for encryption."
      usage
    else
      echo "Data: $DATA"
      echo "Filename: $FILENAME"
      echo "Encrypting $DATA into $FILENAME..."

      encryptData() {
        local dataToEncrypt=${1}
        local outfile="${2}"

        openssl enc -e -aes256 -pbkdf2 -pass "pass:$PASSKEY" -out "$outfile" <<EOF
$dataToEncrypt
EOF
      }

      encryptData "$DATA" "$user_keys_dir/$FILENAME"
    fi
  elif $DECRYPT; then
    if [ -z "$FILENAME" ]; then
      echo "Error: Filename is required for decryption."
      usage
    else
      echo "Decrypting $FILENAME..."
      decryptData "$user_keys_dir/$FILENAME"
    fi
  elif [ $SUPPORT != true ]; then
    if [ $# -eq 2 ]; then
      local encryptedPass=$1
      local encryptedFile=$2
      if [ ! -d "$user_keys_dir" ]; then
        sudo mkdir -p "$user_keys_dir"
        sudo chmod 700 "$user_keys_dir"
        sudo chown "$USER:$USER" "$user_keys_dir"
      fi

      /usr/local/gitload/gitload-enter-this.sh `decryptData "$user_keys_dir/$encryptedPass"` "$encryptedFile"
      . ~/.keychain/$HOST-sh
      . ~/.keychain/$HOST-sh-gpg
      return 0
    else
      echo "\e[$BOLD;$RED;${BLINKING}mMissing argument!\e[0m" You need to provide the encrypted pass argument and the encrypted file!
      return 1
    fi
  fi
}