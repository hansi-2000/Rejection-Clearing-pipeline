import json
import os
import subprocess
from pathlib import Path
from datetime import datetime, timedelta, timezone
# SQL script generation function
def replace_date(file_name):
    # Get the path of SQL template file
    file_path = os.path.join(os.getcwd(), 'templates', file_name)
    # Read the content of the file
    with open(file_path, 'r') as file:
        content = file.readlines()
    # Generate the current date and time string
    sri_lanka_offset = timezone(timedelta(hours=5, minutes=30))
    sri_lanka_time = datetime.now(sri_lanka_offset)
    today_str = sri_lanka_time.strftime('%Y%m%d')
    # Replace the old table name and environment name with the new ones
    old_table_date = f'<CURRENT_DATE>'
    bitbucket_build_no = os.getenv('BITBUCKET_BUILD_NUMBER')
    replacement_table_date = f'{today_str}_{bitbucket_build_no}'
    print(replacement_table_date)
    # Update the content of the file line by line
    updated_lines = []
    for line in content:
        updated_line = line.replace(old_table_date, replacement_table_date)
        updated_lines.append(updated_line)
    # Create a new files with the updated content
    if file_name == "create-table-script.sql":
        file_name = f"create-table-script-{today_str}-{bitbucket_build_no}.sql"
    # Create a new directory to store the generated files
    directory = os.path.join(os.getcwd(), 'TRANSLATION-CLEARING-SCRIPT')
    # If the directory does not exist, create the directory
    os.makedirs(directory, exist_ok=True)
    # Write the updated content to the new file
    with open(os.path.join(directory, file_name), 'w') as file:
        file.writelines(updated_lines)
    print(f"[INFO] - Successfully created file {file_name}")
# Main function
def main():
    try:
        # Get the path of the template folder, join the CWD with templates folder
        folder_path = os.path.join(os.getcwd(), 'templates')
        # Iterate over the files in the template folder
        for file_name in os.listdir(folder_path):
            # Get the path of the file
            file_path = os.path.join(folder_path, file_name)
            # Check if the file exists
            if os.path.isfile(file_path):
                # Replace the date in the file
                if file_name == "create-table-script.sql":
                    replace_date(file_name)
    # Handle exceptions
    except FileNotFoundError as e:
        print(f"[ERROR] - File or directory not found {str(e)}")
    except json.JSONDecodeError as e:
        print(f"[ERROR] - Invalid JSON format in the file: {str(e)}")
    except Exception as e:
        print(f"[ERROR] - An unexpected error occurred {str(e)}")
# Entry point of the script
if __name__ == "__main__":
    main()