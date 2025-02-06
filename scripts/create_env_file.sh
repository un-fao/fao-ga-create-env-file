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

  if [ -z ${VARIABLES+x} ]; then
    echo "$OUTPUT_NAME file has been created but no variables where found."
    return 1
  fi

  # Map variables to .env file, add delimenters in case of multiple words value
  echo "$VARIABLES" | jq -c -r 'to_entries | .[] | if (.value | test("\\s")) then "\(.key)=¦\(.value)¦" else "\(.key)=\(.value)" end' >> "$OUTPUT_NAME"
  # Add backslash before double quotes and quotes
  sed -i 's/\"/\\\"/g' "$OUTPUT_NAME"
  sed -i "s/'/\\\'/g" "$OUTPUT_NAME"
  # Replace ¦ delimeter
  sed -i 's/¦/\"/g' "$OUTPUT_NAME"

  echo "$OUTPUT_NAME file has been created successfully!"
}

create_env_file
