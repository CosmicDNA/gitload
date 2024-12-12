#!/bin/sh

# Main script
getparams() {
  local ENCRYPTED_IDENTITY=$1
  . /usr/local/gitload/gitload-decryptData.sh
  echo "$(decryptData "/var/lib/gitload/keys/$USER/$ENCRYPTED_IDENTITY")"
}

keychain_params=`getparams "$@"`
keychain --nogui --agents "ssh,gpg" $keychain_params