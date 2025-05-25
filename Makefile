.PHONY: init venv install migrate superuser run load-data reset dbshell lint test clean commit format az-install provision collectstatic createcachetable deploy

PYTHON := $(shell command -v python3)
VENV_DIR := venv
VENV_PY := $(VENV_DIR)/bin/python
VENV_PIP := $(VENV_DIR)/bin/pip

# Full initialization: venv + install + migrate + superuser + run
init: venv install migrate superuser run

# Create virtual environment
venv:
	test -d $(VENV_DIR) || $(PYTHON) -m venv $(VENV_DIR)

# Install dependencies
install:
	$(VENV_PIP) install --upgrade pip
	$(VENV_PIP) install -r requirements.txt

# Run database migrations
migrate:
	$(VENV_PY) manage.py migrate

# Create Django superuser
superuser:
	$(VENV_PY) manage.py createsuperuser

# Run development server
run:
	$(VENV_PY) manage.py runserver

# Load initial data (if available)
load-data:
	-$(VENV_PY) manage.py load_initial_data

# Reset local DB (only for SQLite-based local dev)
reset:
	rm -f db.sqlite3
	make migrate
	make load-data

# Launch Django database shell
dbshell:
	$(VENV_PY) manage.py dbshell

# Lint code using flake8
lint:
	$(VENV_PY) -m flake8 .

# Run test suite
test:
	$(VENV_PY) manage.py test

# Remove virtualenv, cache files, and database
clean:
	rm -rf __pycache__ */__pycache__ *.pyc *.pyo *.sqlite3 $(VENV_DIR)

# Git commit shortcut: make commit m="your message"
commit:
ifndef m
	$(error Commit message required. Usage: make commit m="your message")
endif
	git add .
	git commit -m "$(m)"

# Format code using black and isort
format:
	$(VENV_PY) -m black .
	$(VENV_PY) -m isort .

# Install Azure CLI (macOS or Linux only)
az-install:
	@echo "Installing Azure CLI..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		brew update && brew install azure-cli; \
	elif [ "$$(uname)" = "Linux" ]; then \
		curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash; \
	else \
		echo "Unsupported OS. Please install Azure CLI manually."; \
	fi

# Provision Azure resources using script
provision:
	bash provision_azure_resources.sh

# Collect static files for production
collectstatic:
	$(VENV_PY) manage.py collectstatic --noinput

# Create cache table for database cache backend
createcachetable:
	$(VENV_PY) manage.py createcachetable

# Deploy app: run production-ready commands
deploy: migrate collectstatic
