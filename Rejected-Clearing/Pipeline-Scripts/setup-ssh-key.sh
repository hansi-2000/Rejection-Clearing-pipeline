#!/bin/bash
set -e
set -x
set -o pipefail
# Assuming the base64-encoded variable is stored in the environment variable named MY_ENCODED_VARIABLE
encoded_value=$REIECTION_SYNC_FULLL_AUTOMATED_SSH_PRIVATE_KEY
# Decode the base64-encoded value
decoded_value=$(echo $encoded_value | base64 --decode)
# Save the decoded value to a text file
echo "$decoded_value" > /root/.ssh/id_rsa
chmod 600 /root/.ssh
chmod 600 /root/.ssh/id_rsa
# Optionally, you can display the decoded value
echo "[INFO] - Successfully set ssh key"