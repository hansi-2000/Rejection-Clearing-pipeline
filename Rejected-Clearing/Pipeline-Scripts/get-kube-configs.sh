#!/bin/bash
set -e
set -x
set -o pipefail
getIP(){
    env="$1"
    parent="$2"
    json_file="$3"
    env_linux=$(echo "$json_file" | jq -r ".$env.linux")
    # SSH into server & generate kube configs, base64 is an encoding scheme used to represent binary data in an ASCII string format.
    echo "[STEP - 1] --------------------------------------------"
    ssh -o StrictHostKeyChecking=no ifs@$env_linux "microk8s config | base64 -w 0 > $env-kube-config.yml"
    echo "[STEP - 1] Complete -----------------------------------"
    # Copy config files from remote server to local directory
    echo "[STEP - 2] --------------------------------------------"
    scp -o StrictHostKeyChecking=no ifs@$env_linux:$env-kube-config.yml $parent/KUBE_CONFIGS
    echo "[STEP - 2] Complete -----------------------------------"
    # Get kube config file path and decode the content
    echo "[STEP - 3] --------------------------------------------"
    kube_config_data="$parent/KUBE_CONFIGS/$env-kube-config.yml"
    base64_string=$(cat "$kube_config_data")
    decoded_data=$(echo "$base64_string" | base64 -d)
    echo $decoded_data
    echo "[STEP - 3] Complete -----------------------------------"
}
# Get translation environments
config=$(cat $BITBUCKET_CLONE_DIR/Translation-Scripts/Translation-automating/config-test.json)
# Iterate through the Bash array and perform actions
for subarray in $(echo "$config" | jq -r '.environments[]'); do
  getIP "$subarray" "$BITBUCKET_CLONE_DIR" "$config"
done
# Get all environments count
count=$(echo "$config" | jq -r '.environments | length')
echo "[INFO] - All updated file count $count"
# Count the number of txt files in the folder
file_count=$(find "$BITBUCKET_CLONE_DIR/KUBE_CONFIGS" -maxdepth 1 -type f -name "*.yml" | wc -l)
echo "[INFO] - All translation environments count $file_count"
# Iterate through the Bash array and perform actions
for subarray in $(echo "$config" | jq -r '.environments[]'); do
    # Find the file and store the result in a variable
    file_path=$(find $BITBUCKET_CLONE_DIR/KUBE_CONFIGS -type f -name "$subarray-kube-config.yml")
    # Check if the file was found
    if [ -n "$file_path" ]; then
        echo "[INFO] - $subarray-kube-config.yml successfully update"
    else
        echo "[ERROR] - File '$subarray-kube-config.yml' not found"
        exit 1
    fi
done