#!/bin/sh

decryptData () {
  local fileToDecrypt=${1}
  local decripted=`openssl enc \
    -in "$fileToDecrypt" \
    -d -aes256 \
    -pass "pass:$PASSKEY" \
    -pbkdf2`
    echo $decripted
}