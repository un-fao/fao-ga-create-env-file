#!/bin/bash

set -eE -o functrace

fatal() {
  local LINE="$1"
  local CMD="$2"
  echo "[FATAL] $LINE: $CMD"
  exit 1
}

trap 'fatal "$LINENO" "$BASH_COMMAND"' ERR

create_env_file() {
  # echo $VARIABLES
  # # Escape quotes in VARIABLES
  # VARIABLES=$(echo "$VARIABLES" | sed 's/"/\\"/g')
  echo $VARIABLES

  # Create or overwrite .env file
  touch "$OUTPUT_NAME"

  if [[ -n $VARIABLES ]]; then 
    # Extract variables and write them to .env with conditional quotes
    echo "$VARIABLES" | jq -c -r 'to_entries | .[] | if (.value | test("\\s")) then "\(.key)=\"\(.value)\"" else "\(.key)=\(.value)" end' >> "$OUTPUT_NAME"
  fi

  echo "$OUTPUT_NAME file has been created successfully!"
}

create_env_file
