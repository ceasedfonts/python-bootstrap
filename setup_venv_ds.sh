#!/bin/bash

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Please provide a project name: ./setup_venv_ds.sh myproject"
  exit 1
fi

echo "Creating virtual environment for project: $PROJECT_NAME"
VENV_DIR=".venv-${PROJECT_NAME}"
python3 -m venv "$VENV_DIR"

if [ ! -f "${VENV_DIR}/bin/activate" ]; then
  echo "Failed to create .venv"
  exit 1
fi

echo "Activating environment"
export VIRTUAL_ENV_DISABLE_PROMPT=1
source "${VENV_DIR}/bin/activate"

echo "Installing common data science packages"
pip install --upgrade pip
pip install jupyter ipykernel numpy pandas dtale matplotlib seaborn scikit-learn

# Optional: confirm ipykernel installed (defensive)
if ! python -c "import ipykernel" &>/dev/null; then
  echo "ipykernel not found after install — retrying..."
  pip install ipykernel
fi

echo "All set. VS Code will auto-detect the local .venv kernel."

# DO NOT delete this — we now rely on it:
# .venv/share/jupyter/kernels/python3

# Do NOT register a separate named kernel

# ──────────────────────────────
# Generate project-local Makefile
echo "Generating local Makefile for project: $PROJECT_NAME"

cat <<EOF > Makefile
PROJECT := $(notdir \$(CURDIR))
VENV_DIR := .venv-\$(PROJECT)
BOOTSTRAP_DIR := \$(dir \$(abspath \$(lastword \$(MAKEFILE_LIST))))

notebook:
	@echo "Launching Jupyter Notebook..."
	@source \$(VENV_DIR)/bin/activate && jupyter notebook

venv:
	@echo "Recreating environment via bootstrap script..."
	@\$(BOOTSTRAP_DIR)/setup_venv_ds.sh \$(PROJECT)

freeze:
	@echo "Freezing environment to requirements.txt"
	@source \$(VENV_DIR)/bin/activate && pip freeze > requirements.txt

clean:
	@echo "Cleaning cache and virtual environment"
	@rm -rf \$(VENV_DIR) __pycache__ .ipynb_checkpoints *.pyc

clean-kernels:
	@echo "Running kernel cleanup from bootstrap..."
	@\$(BOOTSTRAP_DIR)/delete_stale_kernels.sh

doctor:
	@echo "Running environment check for '\$(PROJECT)'..."
	@if [ ! -d \$(VENV_DIR) ]; then echo " \$(VENV_DIR) not found."; exit 1; fi
	@if [ ! -x \$(VENV_DIR)/bin/python ]; then echo " Python binary missing."; exit 1; fi
	@source \$(VENV_DIR)/bin/activate && \
		which jupyter > /dev/null || (echo " Jupyter not found"; exit 1)
	@echo " All good: \$(VENV_DIR) and Jupyter are in place."
EOF

echo "All done!"
echo "Activate with: source ${VENV_DIR}/bin/activate"
echo "Then launch 'Jupyter Notebook' or open a .ipynb file in VS Code"