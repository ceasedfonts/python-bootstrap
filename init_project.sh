#!/bin/bash

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./init_project.sh myproject"
  exit 1
fi

echo "Creating folder structure for '$PROJECT_NAME'"
mkdir -p "$PROJECT_NAME"/{notebooks,data,scripts} || exit 1

cd "$PROJECT_NAME" || exit 1

# Find path to this script's directory to call setup reliably
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/setup_venv_ds.sh" "$PROJECT_NAME"

echo "Project '$PROJECT_NAME' is ready at $(pwd)"