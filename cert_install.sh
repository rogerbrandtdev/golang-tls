#!/bin/bash -e

CRT_FILE=$1
sudo security add-trusted-cert -d -r trust -k "/Library/Keychains/System.keychain" $CRT_FILE
echo "Done!"

