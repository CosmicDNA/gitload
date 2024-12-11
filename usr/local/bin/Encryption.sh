#/bin/bash
fetchDataToEncrypt () {
  echo 'Enter the data to encrypt: '
  read DATATOENCRYPT
}
fetchOutFile () {
  echo 'Enter the output file: '
  read OUTFILE
}
fetchFileToDecrypt () {
  echo 'Enter the file name to decrypt: '
  read ENCRYPTEDFILE
}
fetchPasskey () {
  echo 'Enter your pass key: '
  read PASSKEY
}

# -in PrimaryDataFile \
# -in <(echo "$dataToEncrypt") \
encryptData () {
  dataToEncrypt=${1}
  passkey="${2}"
  outfile="${3}"
  echo -n "$dataToEncrypt" > /tmp/PrimaryDataFile
  openssl enc \
    -in /tmp/PrimaryDataFile \
    -out "$outfile" \
    -e -aes256 \
    -pass "pass:${passkey}" \
    -pbkdf2
  rm /tmp/PrimaryDataFile
}

decryptData () {
  fileToDecrypt=${1}
  passkey="${2}"
  # openssl enc -in EncryptedDataFile -out DecryptedDataFile -d -aes256 -pass "pass:${passkey}" -pbkdf2
  decripted=`openssl enc \
    -in "$fileToDecrypt" \
    -d -aes256 \
    -pass "pass:${passkey}" \
    -pbkdf2`
    echo $decripted
}

listOptions () {
  echo "
What Operation you want to do?
1) Start Encryption
2) Start Decryption
3) Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
      # fetchPasskey PASSKEY
      fetchDataToEncrypt
      fetchOutFile
      echo 'Encrypting ...'
      encryptData "$DATATOENCRYPT" "$PASSKEY" "/var/lib/gitload/keys/$USER/$OUTFILE";;
    2)
      # fetchPasskey PASSKEY
      fetchFileToDecrypt
      echo 'Decrypting ...'
      decryptData "$ENCRYPTEDFILE" "$PASSKEY";;
    3)
      echo 'Exiting'
      exit 0;;
    *)
      echo 'Wrong option'
      exit 0;;
    esac
}