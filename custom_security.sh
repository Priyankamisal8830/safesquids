#!/bin/bash

CONFIG_FILE="/etc/security/custom_checks.conf"


run_check() {
    local check_name="$1"
    local check_command="$2"
    echo "Running $check_name..."
    eval "$check_command"
    echo "$check_name completed."
}

if [ -f "$CONFIG_FILE" ]; then
    while IFS= read -r line; do
        
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        
        check_name=$(echo "$line" | awk -F '|' '{print $1}')
        check_command=$(echo "$line" | awk -F '|' '{print $2}')
        
        run_check "$check_name" "$check_command"
    done < "$CONFIG_FILE"
else
    echo "Custom checks configuration file not found: $CONFIG_FILE"
fi
