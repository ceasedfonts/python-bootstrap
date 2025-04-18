# Python Project Bootstrap

A lightweight starter kit to spin up reproducible Python environments for data science projects. With make, virtualenv, and Jupyter baked in. Plus a few data science libraries to get you started.

⸻

Features
• Creates a .venv-myproject with essential DS libraries
• Registers a Jupyter kernel for the venv
• Generates standard project folders: notebooks/, data/, scripts/
• Includes Makefile targets for setup, cleanup, freezing, and launching notebooks
• No poetry, no pipenv, just portable, dependency-free shell scripts

⸻

## Usage

### Full project setup

```bash
make init PROJECT=myproject
```

Creates this structure:

myproject/
├── .venv-myproject/
├── notebooks/
├── data/
├── scripts/
└── Makefile

### Reset venv inside existing project

```bash
make venv PROJECT=myproject
```

(Re)creates .venv-myproject and reinstalls packages.

### Freeze requirements

```bash
make freeze
```

Creates requirements.txt with pip freeze.

### Clean cache + venv

```bash
make clean
```

Removes .venv-*, __pycache__, checkpoints, and .pyc files.

### Launch Jupyter

```bash
make notebook
```

Starts Jupyter Notebook using your local venv.

### Destroy project (IRREVERSIBLE!)

```bash
make destroy
```

Deletes venv, notebooks, scripts, data, and cached files.

⸻

Use Anywhere (Optional)

Set a global alias in your shell config:

```bash
newproj() {
  local project_name="$1"
  local current_dir="$(pwd)"
  make -C ~/PATH-TO-YOUR-PROJECT/python-bootstrap init PROJECT="$project_name" TARGET_DIR="$current_dir"
}
```

Then run:

```bash
newproj PROJECT=myproject - or anything else you want as the project name.
```

This will create a new project in the current directory with the specified name.
