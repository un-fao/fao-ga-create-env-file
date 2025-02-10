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
  local TMP_FILE="tmp.env"

  if [ -z ${ENV_VARIABLES+x} ] || [ "$ENV_VARIABLES" = "null" ]; then
    echo "No $NAME where found."
    return
  fi

  # Map variables to .env file, add delimenters in case of space separated values
  echo "$ENV_VARIABLES" | jq -c -r 'to_entries | .[] | if (.value | test("\\s")) then "\(.key)=¦\(.value)¦" else "\(.key)=\(.value)" end' >> "$TMP_FILE"
  # Add backslash before double quotes and quotes
  sed -i 's/\"/\\\"/g' "$TMP_FILE"
  sed -i "s/'/\\\'/g" "$TMP_FILE"
  # Replace delimeters with double quotes
  sed -i 's/¦/\"/g' "$TMP_FILE"

  cat "$TMP_FILE" >> "$OUTPUT_FILE"
  rm "$TMP_FILE"
  echo "$NAME added to $FILE_NAME!"
}

create_env_file "$OUTPUT_NAME"
add_env_variables "$VARIABLES" "Variables" "$OUTPUT_NAME"
add_env_variables "$SECRETS" "Secrets" "$OUTPUT_NAME"
