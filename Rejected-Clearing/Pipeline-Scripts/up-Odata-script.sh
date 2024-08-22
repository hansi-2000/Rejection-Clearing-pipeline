#!/bin/bash
set -e
set -x
set -o pipefail
upOdata() {
    local env="$1"
    local parent_dir="$2"
    local json_file="$3"
    local namespace=$(jq -r ".$env.k8snamespace" <<< "$json_file")
    local kube_config_path="$parent_dir/KUBE_CONFIGS/$env-kube-config.yml"
    local kube_config=$(base64 -d "$kube_config_path")
    # Conditionally perform actions based on environment
    if [ "$env" == "Test3" ]; then
        # for testing purposes only
        kubectl scale deploy ifs-file-storage --replicas=1 -n "$namespace" --kubeconfig <(echo "$kube_config")
        echo "[INFO] - Successfully up environment $env"
    else
        # for real environment
        kubectl scale deploy ifsapp-odata --replicas=1 -n "$namespace" --kubeconfig <(echo "$kube_config")
        echo "[INFO] - Successfully up environment $env"
    fi
}
# Read JSON configuration file
config_file=$(cat "$BITBUCKET_CLONE_DIR/Translation-Scripts/Translation-automating/config-test.json")
# Iterate through the environments array and call shutdown for each
for env in $(jq -r '.environments[]' <<< "$config_file"); do
    upOdata "$env" "$BITBUCKET_CLONE_DIR" "$config_file"
done