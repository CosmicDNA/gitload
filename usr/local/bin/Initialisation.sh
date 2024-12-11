#!/bin/sh
HOST=`hostname -s`
SCRIPT_PATH="${BASH_SOURCE:-$0}"
# echo "Value of SCRIPT_PATH: ${SCRIPT_PATH}"
ABS_SCRIPT_PATH="$(realpath "${SCRIPT_PATH}")"
# echo "Value of ABS_SCRIPT_PATH: ${ABS_SCRIPT_PATH}"
ABS_DIRECTORY="$(dirname "${ABS_SCRIPT_PATH}")"
# echo "Value of ABS_DIRECTORY: ${ABS_DIRECTORY}"
ENCRYPTED_IDENTITY=$1
# echo `"$ABS_DIRECTORY/Decryption.sh" "/var/lib/gitload/keys/$USER/$ENCRYPTED_IDENTITY"`
keychain --nogui --agents "ssh,gpg" `"$ABS_DIRECTORY/Decryption.sh" "/var/lib/gitload/keys/$USER/$ENCRYPTED_IDENTITY"`