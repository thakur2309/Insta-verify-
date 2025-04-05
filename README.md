# Insta Verify

This tool is used for Instagram verification and information dumping. Built for educational and ethical purposes using Termux.

## Preview

/storage/emulated/0/Pictures/Screenshots/Screenshot_2025_0405_104926.jpg

## Installation & Setup

Follow these steps to install and run the tool:

```bash
# Update and upgrade Termux packages
$ apt update && apt upgrade

# Install necessary packages
$ pkg install curl
$ pkg install php
$ pkg install figlet git

# Clone the repository
$ git clone https://github.com/thakur2309/Insta-verify-.git

# Navigate into the directory
$ cd Insta-verify-

# Give execute permission and run the install script
$ chmod +x install.sh
$ bash install.sh

# Give execute permission to the main tool script
$ chmod +x instadump.sh
$ bash instadump.sh
