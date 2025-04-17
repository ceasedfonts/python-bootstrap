# ┌────────────────────────────────────────────┐
# │           Python Project Bootstrap         │
# └────────────────────────────────────────────┘

# You can override this when calling: make init PROJECT=myproject
PROJECT ?= myproject

# Default directory structure for new projects
DIRS = notebooks data scripts

# ──────────────────────────────
# Create project folder + structure + setup venv
# Get the absolute path to the directory where the Makefile is located
BOOTSTRAP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

init:
	@echo "Initializing project: $(PROJECT)"
	@chmod +x $(BOOTSTRAP_DIR)/setup_venv_ds.sh
	@chmod +x $(BOOTSTRAP_DIR)/delete_stale_kernels.sh
	@mkdir -p $(TARGET_DIR)/$(PROJECT)/{notebooks,data,scripts}
	@cd $(TARGET_DIR)/$(PROJECT) && $(BOOTSTRAP_DIR)/setup_venv_ds.sh $(PROJECT)
	@echo "Project $(PROJECT) is ready at $(TARGET_DIR)/$(PROJECT)"
# ──────────────────────────────
# Just create/refresh the venv in current directory
venv:
	@echo "Creating fresh virtual environment..."
	@VIRTUAL_ENV_DISABLE_PROMPT=1 python3 -m venv .venv --prompt "$(PROJECT)" && \
	export VIRTUAL_ENV_DISABLE_PROMPT=1 && \
	. .venv/bin/activate && \
	pip install -U pip && \
	pip install jupyter ipykernel numpy pandas matplotlib seaborn scikit-learn

# ──────────────────────────────
# Freeze requirements into file
freeze:
	@source .venv/bin/activate && pip freeze > requirements.txt
	@echo "requirements.txt created."

# ──────────────────────────────
# Clean junk: venv, pycache, ipynb checkpoints
clean:
	@echo "Cleaning .venv, __pycache__, .ipynb_checkpoints..."
	@rm -rf .venv __pycache__ .ipynb_checkpoints *.pyc

# ──────────────────────────────
# Launch Jupyter Notebook with correct kernel
notebook:
	@echo "Starting Jupyter Notebook..."
	@source .venv/bin/activate && jupyter notebook

# ──────────────────────────────
# Nuke everything (use with care!)
destroy:
	@echo "Removing all files and folders in this project!"
	@rm -rf .venv __pycache__ .ipynb_checkpoints *.pyc requirements.txt $(DIRS)

# ──────────────────────────────
# Clean up stale Jupyter kernels
clean-kernels:
	@$(BOOTSTRAP_DIR)/delete_stale_kernels.sh