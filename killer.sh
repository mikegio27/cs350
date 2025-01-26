#!/bin/bash

# Define exclusion patterns to ignore specific Python processes
EXCLUSIONS=(
    "unattended-upgrade-shutdown"
    "vscode-server"
    "vscode-pylance"
)

# Get list of PIDs for python3 processes, filtering out exclusions
PIDS=$(ps aux | grep '[p]ython3' | awk '{print $2, $11, $12, $13}' | while read -r pid cmd args; do
    skip=false
    for exclusion in "${EXCLUSIONS[@]}"; do
        if [[ "$cmd $args" == *"$exclusion"* ]]; then
            skip=true
            break
        fi
    done
    if [ "$skip" = false ]; then
        echo "$pid"
    fi
done)

# Kill processes if there are any
if [ -n "$PIDS" ]; then
    echo "Killing PIDs: $PIDS"
    kill -9 $PIDS
else
    echo "No matching Python processes to kill."
fi

