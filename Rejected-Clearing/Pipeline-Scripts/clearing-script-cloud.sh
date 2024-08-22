#!/bin/bash
set -e
set -x
set -o pipefail
clearingCloud() {
    src="$1"
    json_file="$2"
    parent=BITBUCKET_CLONE_DIR
    script_path="$parent/Translation-Scripts/Translation-automating/Rejected-Clearing"
    # Get the create table name with current date
    today=$(date -u +"%y%m%d")
    generate_create_table_name=create-table-script-${today}-${BITBUCKET_BUILD_NUMBER}.sql
    src_node=$(echo "$json_file" | jq -r ".$src.node")
    src_db=$(echo "$json_file" | jq -r ".$src.db")
    # Run the SQL commands using sql plus to lock table
    echo "[STEP - 1] --------------------------------------------"
    sqlplus "$src_db" @"${script_path}/templates/lock-table-script.sql"
    echo "[STEP - 1] Complete -----------------------------------"
    # Set sleep to finishing print outputs in terminal
    echo "15s sleep"
    sleep 15
    # Run the SQL commands which is created in TRANSLATION-CLEARING-SCRIPT directory using sql plus to create table
    echo "[STEP - 2] --------------------------------------------"
    sqlplus "$src_db" @"${script_path}/TRANSLATION-CLEARING-SCRIPT/${generate_create_table_name}"
    echo "[STEP - 2] Complete -----------------------------------"
    # Set sleep to finishing print outputs in terminal
    echo "15s sleep"
    sleep 15
    # Run the SQL commands using sql plus to lock table
    echo "[STEP - 3] --------------------------------------------"
    sqlplus "$src_db" @"${script_path}/templates/lock-table-script.sql"
    echo "[STEP - 3] Complete -----------------------------------"
    # Set sleep to finishing print outputs in terminal
    echo "15s sleep"
    sleep 15
    # Run the SQL commands using sql plus to disable history-setting-disable-script
    echo "[STEP - 4] --------------------------------------------"
    sqlplus "$src_db" @"${script_path}/templates/history-setting-disable-script.sql"
    echo "[STEP - 4] Complete -----------------------------------"
    # Set sleep to finishing print outputs in terminal
    echo "15s sleep"
    sleep 15
    # Run the SQL commands using sql plus to update table script
    echo "[STEP - 5] --------------------------------------------"
    sqlplus "$src_db" @"${script_path}/templates/update-table-script.sql"
    echo "[STEP - 5] Complete -----------------------------------"
    # Set sleep to finishing print outputs in terminal
    echo "15s sleep"
    sleep 15
    # Run the SQL commands using sql plus to enable history-setting-disable-script
    echo "[STEP - 6] --------------------------------------------"
    sqlplus "$src_db" @"${script_path}/templates/history-setting-enable-script.sql"
    echo "[STEP - 6] Complete -----------------------------------"
    # Set sleep to finishing print outputs in terminal
    echo "15s sleep"
    sleep 15
}
# Get translation endearments
config=$(cat $BITBUCKET_CLONE_DIR/Translation-Scripts/Translation-automating/config-test.json)
# Iterate through the Bash array and perform actions
for subarray in $(echo "$config" | jq -c '.translations[]'); do
  # Get the first element of subarray as raw string (without quotes)
  index1=$(echo "$subarray" | jq -r '.[0]')
  clearingCloud "$index1" "$config"
done
# Set sleep to finishing print outputs in terminal
echo "15s sleep"
sleep 15