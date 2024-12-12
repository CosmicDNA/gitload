# Gitload
Gitload is a versatile script designed to streamline the process of loading SSH and GPG keys, making it easier for users to manage their encrypted data and automate key-related tasks. This repository contains the source code and packaging information for the Gitload Debian package.

## Features
Load SSH and GPG Keys: Automatically load SSH and GPG keys from encrypted files.

Encrypt and Decrypt Data: Easily encrypt and decrypt data files using OpenSSL.

Integration with Funtoo Keychain: Seamlessly integrate with Funtoo Keychain to manage SSH and GPG agents.

## Installation
To install the Gitload package, follow these steps:

1. Clone the Repository:

```sh
git clone https://github.com/CosmicDNA/gitload.git
```

2. Build the Debian Package:

```sh
dpkg-deb --build gitload
```

3. Install the Package:

```sh
sudo dpkg -i gitload.deb
```

4. Source the Script in Your Shell Configuration File:

```sh
# either
echo 'source /etc/profile.d/gitload.sh' >> ~/.bashrc
# or
echo 'source /etc/profile.d/gitload.sh' >> ~/.zshrc
```

5. Reload Your Shell Configuration:

```sh
# either
source ~/.bashrc
# or
source ~/.zshrc
```

## Usage

1. **Set the `PASSKEY` Environment Variable**: Ensure you have a PASSKEY environment variable set for the encryption and decryption processes.

2. **Create the Encrypted SSH Password File**. For example:

```sh
gitload -e your_ssh_password ssh_password_file
```

3. **Create the Encrypted Keychain Arguments**: Use the gitload -e command to create the encrypted keychain arguments. The keychain_args_file should be a string containing both the SSH file path and the GPG key. For example:

```sh
gitload -e "~/.ssh/id_john_doe 3F4A1B2C5D6E7F8G"
```

4. **Use the Encrypted Files**: Finally, use the encrypted files with the gitload command:

```sh
gitload ssh_password_file keychain_args_file
```

5. **Execute git commands with GPG signing and SSH support**:

```sh
git commit -m ":tada:"
```

Now you can commit utilising your ssh but also signing with your loaded gpg key in a breeze.

## Switches
After installation and sourcing the script, you can use the gitload command in your shell. The command can be used for:

- Loading SSH and GPG Keys
- Encrypting Data to Gitload store
- Decrypting Data from Gitload store
- Displaying Help

> [!CAUTION]
> For the former 3 cases make sure the `PASSKEY` environment variable is properly set before running gitload command. This variable is crucial because it is used to encrypt / decrypt information back and forth from gitload store.

### Load SSH and GPG Keys
To load SSH and GPG keys from encrypted files, use the following command:

```sh
gitload ssh_password_file keychain_args_file
```

### Encrypt Data
To encrypt data to a specified filename, use the -e option:

```sh
gitload -e "data to encrypt" filename
```

### Decrypt Data
To decrypt a specified filename, use the -d option:

```sh
gitload -d filename
```

### Display Help
To display usage information, use the -h option:

```sh
gitload -h
```

## How It Works

### Loading Keys
The gitload script automates the process of loading SSH and GPG keys by decrypting the provided encrypted files and using Funtoo Keychain to manage the SSH and GPG agents. This ensures that your keys are securely loaded and available for use.

### Encrypting and Decrypting Data
The script provides functionality to encrypt and decrypt data files using OpenSSL. This allows users to securely store and manage sensitive information. The encrypted files are stored at `"/var/lib/gitload/keys/$USER"`.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request if you have any improvements or bug fixes.

## License
This project is licensed under the MIT License.