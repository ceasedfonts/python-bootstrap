#!/bin/bash

# Clean up Jupyter kernels that point to missing .venv interpreters

echo "Checking for stale Jupyter kernels..."

# Ensure jq is installed
if ! command -v jq >/dev/null; then
  echo "jq is not installed. Please run 'brew install jq'"
  exit 1
fi

KERNEL_DIR="$HOME/Library/Jupyter/kernels"
FOUND=0
REMOVED=0

for kernel in "$KERNEL_DIR"/*; do
  KERNEL_NAME=$(basename "$kernel")
  KERNEL_JSON="$kernel/kernel.json"

  if [[ ! -f "$KERNEL_JSON" ]]; then
    continue
  fi

  PYTHON_PATH=$(jq -r '.argv[0]' "$KERNEL_JSON" 2>/dev/null)

  if [[ ! -x "$PYTHON_PATH" ]]; then
    echo "Stale kernel found: $KERNEL_NAME (missing: $PYTHON_PATH)"
    jupyter kernelspec uninstall -y "$KERNEL_NAME"
    ((REMOVED++))
  else
    ((FOUND++))
  fi
done

echo "Checked $((FOUND + REMOVED)) kernels."
echo "Removed $REMOVED stale kernels."