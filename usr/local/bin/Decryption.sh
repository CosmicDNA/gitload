#!/bin/sh
SCRIPT_PATH="${BASH_SOURCE:-$0}"
# echo "Value of SCRIPT_PATH: ${SCRIPT_PATH}"
ABS_SCRIPT_PATH="$(realpath "${SCRIPT_PATH}")"
# echo "Value of ABS_SCRIPT_PATH: ${ABS_SCRIPT_PATH}"
ABS_DIRECTORY="$(dirname "${ABS_SCRIPT_PATH}")"
# echo "Value of ABS_DIRECTORY: ${ABS_DIRECTORY}"

ENCRYPTION="${ABS_DIRECTORY}/Encryption.sh"
. $ENCRYPTION

decryptData "$1" "$PASSKEY"