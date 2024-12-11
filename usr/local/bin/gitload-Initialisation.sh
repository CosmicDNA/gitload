#!/bin/sh
ENCRYPTED_IDENTITY=$1
. /usr/local/bin/gitload-decryptData.sh
keychain --nogui --agents "ssh,gpg" `decryptData "/var/lib/gitload/keys/$USER/$ENCRYPTED_IDENTITY"`