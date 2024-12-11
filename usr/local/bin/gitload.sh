#!/bin/bash
SCRIPT_PATH="${BASH_SOURCE:-$0}"
# echo "Value of SCRIPT_PATH: ${SCRIPT_PATH}"
ABS_SCRIPT_PATH="$(realpath "${SCRIPT_PATH}")"
# echo "Value of ABS_SCRIPT_PATH: ${ABS_SCRIPT_PATH}"
ABS_DIRECTORY="$(dirname "${ABS_SCRIPT_PATH}")"

BOLD=1
BLINKING=5
RED=31

gitload() {
  if [ $# -eq 2 ]
  then
    local encryptedPass=$1
    local encryptedFile=$2
    set -a
    . "$ABS_DIRECTORY/.envrc"
    set +a
    $ABS_DIRECTORY/enter-this.sh `$ABS_DIRECTORY/Decryption.sh /var/lib/gitload/keys/$USER/$encryptedPass` "$encryptedFile"
    HOST=`hostname -s`
    . ~/.keychain/$HOST-sh
    . ~/.keychain/$HOST-sh-gpg
    return 0
  else
    echo "\e[$BOLD;$RED;${BLINKING}mMissing argument!\e[0m" You need to provide the encrypted pass argument and the encrypted file!
    return 1
  fi
}