# create-env-file

## Overview

`create-env-file` is a GitHub Actions composite action that generates a `.env` file from a JSON extraction of GitHub environment variables and secrets.

## Features

- Converts GitHub environment variables and secrets (provided in JSON format) into a `.env` file.
- Handles spaces within variable and secrets values by encapsulating them in double quotes.
- Escapes special characters (quotes and double quotes) to ensure correct formatting.

## Usage

To use this action in your workflow, add the following step:

```yaml
- name: Generate .env file
  uses: un-fao/create-env-file@main
  with:
    variables: ${{ toJson(vars) }}
    secrets: ${{ toJson(secrets) }}
    output-name: '.env'  # Optional, defaults to '.env'
```

## Inputs

| Name          | Description                                 | Required | Default |
| ------------- | ------------------------------------------- | -------- | ------- |
| `variables`   | GitHub environment variables in JSON format | ❌        | N/A     |
| `secrets`     | GitHub environment secrets in JSON format   | ❌        | N/A     |
| `output-name` | Name of the output .env file                | ❌        | `.env`  |

## Example Output

If the provided JSON input is:

```json
{
  "VAR_1": "variable_1",
  "VAR_2": "\"variable_2\"",
  "VAR_3": "variable number 3"
}
```

The resulting `.env` file will contain:

```env
VAR_1=variable_1
VAR_2=\"variable_2\"
VAR_3="variable number 3"
```