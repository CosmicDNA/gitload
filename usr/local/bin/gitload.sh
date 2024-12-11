#!/bin/sh
BOLD=1
BLINKING=5
RED=31

gitload(){
  # Function to display usage information
  usage() {
      echo "Usage: $(basename "$0") [-e data filename] [-d filename] [-h] [encryptedfileA encryptedfileB]\n\
      encryptedfileA encryptedfileB \tLoad ssh and gpg key\n\
      -e data filename\t\t\tEncrypt data to filename\n\
      -d filename\t\t\tDecrypt filename\n\
      -h\t\t\t\tDisplay this help message"
      exit 1
  }

  local user_keys_dir="/var/lib/gitload/keys/$USER"

  # Initialize variables
  local DATA=""
  local FILENAME=""
  local ENCRYPT=false
  local DECRYPT=false

  # Parse command-line options using getopts
  while getopts ":e:d" opt; do
    case ${opt} in
      e)
        ENCRYPT=true
        DATA=$OPTARG
        shift $((OPTIND-1))
        FILENAME=$1
        ;;
      d)
        DECRYPT=true
        FILENAME=$2
        ;;
      h)
        usage
        ;;
      *)
        usage
        ;;
    esac
  done

  . /usr/local/bin/gitload-decryptData.sh
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
      # Call your decryption function here

      decryptData "$user_keys_dir/$FILENAME"
    fi
  else
    # Default action when no options are provided

    if [ $# -eq 2 ]
    then
      local encryptedPass=$1
      local encryptedFile=$2
      # Create user-specific keys directory if it doesn't exist
      if [ ! -d "$user_keys_dir" ]; then
        sudo mkdir -p "$user_keys_dir"
        sudo chmod 700 "$user_keys_dir"
        sudo chown "$USER:$USER" "$user_keys_dir"
      fi

      /usr/local/bin/gitload-enter-this.sh `decryptData "$user_keys_dir/$encryptedPass"` "$encryptedFile"
      . ~/.keychain/$HOST-sh
      . ~/.keychain/$HOST-sh-gpg
      return 0
    else
      echo "\e[$BOLD;$RED;${BLINKING}mMissing argument!\e[0m" You need to provide the encrypted pass argument and the encrypted file!
      return 1
    fi
  fi
}
