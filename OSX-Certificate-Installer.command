#!/bin/bash
cd /private/tmp
curl -O https://support.securly.com/hc/en-us/article_attachments/202462327/securly_SHA-256.crt
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "/private/tmp/securly_SHA-256.crt"
echo "Done!"
