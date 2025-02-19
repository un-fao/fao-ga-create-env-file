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
  local FILE_NAME="$1"
  # Check if the file exists
  if [ -e "OUTPUT_NAME" ]; then
    echo "[FAILED]"
    echo "File '$FILE_NAME' already exists."
  else
    # Create the file
    touch "$FILE_NAME"
    echo "File '$FILE_NAME' created successfully."
  fi
}

add_env_variables() {
  local ENV_VARIABLES="$1"
  local NAME="$2"
  local OUTPUT_FILE="$3"

  if [ -z ${ENV_VARIABLES+x} ] || [ "$ENV_VARIABLES" = "null" ]; then
    echo "No $NAME where found."
    return
  fi

  # Map variables to .env file
  while IFS='=' read -r key value; do
    if [[ "$value" == *'"'* ]]; then
      echo "export $key='$value'" >> "$OUTPUT_FILE"
    elif [[ "$value" == *"'"* ]]; then
      echo "export $key=\"$value\"" >> "$OUTPUT_FILE"
    else
      echo "export $key=\"$value\"" >> "$OUTPUT_FILE"
    fi
  done < <(echo "$ENV_VARIABLES" | jq -r 'to_entries | .[] | "\(.key)=\(.value)"')

  echo "$NAME added to $OUTPUT_FILE!"
}

create_env_file "$OUTPUT_NAME"
add_env_variables "$VARIABLES" "Variables" "$OUTPUT_NAME"
add_env_variables "$SECRETS" "Secrets" "$OUTPUT_NAME"
