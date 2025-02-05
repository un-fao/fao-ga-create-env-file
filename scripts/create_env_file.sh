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
  chmod -R 777 "$OUTPUT_NAME"
  ls -lart

  if [[ -n $VARIABLES ]]; then 
    # Extract variables and write them to .env
    echo "$VARIABLES"
    JSON_STRING='{"PROJECT_ID":"project_id","SERVICE_ACCOUNT":"serv"}'
    echo "$JSON_STRING" | jq -c -r 'to_entries | .[] | "\(.key)=\(.value)"' >> "$OUTPUT_ENV"
  fi

  if [[ -n $SECRETS ]]; then 
    # Extract secrets and write them to .env
    echo "$SECRETS"
    JSON_STRING='{"PROJECT_ID":"project_id","SERVICE_ACCOUNT":"serv"}'
    echo "$JSON_STRING" | jq -c -r 'to_entries | .[] | "\(.key)=\(.value)"' >> "$OUTPUT_ENV"
  fi

    echo "$OUTPUT_NAME file has been created successfully!"
}

create_env_file