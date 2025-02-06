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
  # Create or overwrite .env file
  touch "$OUTPUT_NAME"

  if [[ -n $VARIABLES ]]; then 
    # Extract variables and write them to .env with conditional quotes
    #echo "$VARIABLES" | jq -c -r 'to_entries | .[] | if (.value | test("\\s")) then "\(.key)=\"\(.value)\"" else "\(.key)=\(.value)" end' >> "$OUTPUT_NAME"
    echo "$VARIABLES" | jq -c -r 'to_entries | .[] | "\(.key)=\(.value)"' >> "$OUTPUT_NAME"
  fi

  # Add backslash before each quote or double quote
  sed -i 's/\"/\\\"/g' "$OUTPUT_NAME"

  echo "$OUTPUT_NAME file has been created successfully!"
}

create_env_file
