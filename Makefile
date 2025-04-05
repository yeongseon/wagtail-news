.PHONY: init venv install migrate superuser run load-data reset dbshell lint test clean commit format az-install provision

PYTHON=python
VENV_DIR=venv
ACTIVATE=. $(VENV_DIR)/bin/activate;

init: venv install migrate superuser run

venv:
	test -d $(VENV_DIR) || $(PYTHON) -m venv $(VENV_DIR)

install:
	$(ACTIVATE) pip install --upgrade pip
	$(ACTIVATE) pip install -r requirements.txt || pip install wagtail

migrate:
	$(ACTIVATE) python manage.py migrate

superuser:
	$(ACTIVATE) python manage.py createsuperuser

run:
	$(ACTIVATE) python manage.py runserver

load-data:
	$(ACTIVATE) python manage.py load_initial_data || true

reset:
	rm -f db.sqlite3
	make migrate
	make load-data

dbshell:
	$(ACTIVATE) python manage.py dbshell

lint:
	$(ACTIVATE) flake8 .

test:
	$(ACTIVATE) python manage.py test

clean:
	rm -rf __pycache__ */__pycache__ *.pyc *.pyo *.sqlite3 $(VENV_DIR)

commit:
	git add .
	git commit -m "$(m)"

format:
	$(ACTIVATE) black .
	$(ACTIVATE) isort .

az-install:
	@echo "Installing Azure CLI..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		brew update && brew install azure-cli; \
	elif [ "$$(uname)" = "Linux" ]; then \
		curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash; \
	else \
		echo "Unsupported OS. Please install Azure CLI manually."; \
	fi

provision:
	bash provision_azure_resources.sh
