# kpn-news

A KPN-branded Wagtail-based news site starter template.

This project provides a preconfigured Wagtail site with example pages, styles, and layout components suitable for news publishing.

---

## 🚀 Quick Start

### 1. Clone the project

```bash
git clone https://github.com/yeongseon/kpn-news.git
cd kpn-news
```

### 2. Initialize development environment

Use the provided `Makefile` to set up everything in one command:

```bash
make init
```

This will:

- Create a Python virtual environment
- Install dependencies
- Run database migrations
- Create a superuser
- Start the development server

---

## 🛠 Makefile Commands

| Command           | Description |
|------------------|-------------|
| `make init`      | Full setup: venv → install → migrate → superuser → runserver |
| `make venv`      | Create a virtual environment (`venv/`) |
| `make install`   | Install required packages |
| `make migrate`   | Apply Django migrations |
| `make run`       | Run the development server |
| `make superuser` | Create a Django superuser |
| `make load-data` | Load initial data (requires `migrate` first) |
| `make reset`     | Reset the database (delete `db.sqlite3`, re-setup) |
| `make test`      | Run Django tests |
| `make lint`      | Run flake8 for code linting |
| `make format`    | Format code using black and isort |
| `make commit`    | Add and commit all changes to Git |
| `make clean`     | Remove venv, cache, and local DB |
| `make az-install`| Install Azure CLI (macOS/Linux only) |
| `make provision` | Create Azure resources using `provision_azure_resources.sh` |

---

## ⚠️ Notes

- **Run `make migrate` before `make load-data`**  
  The `load_initial_data` command expects the database tables to already exist.  
  Running it too early will cause `OperationalError: no such table: wagtailcore_site`.

- If no `requirements.txt` exists, `wagtail` will be installed directly.

---

## 🔐 Environment Variables

You can use a `.env` file to configure your environment:

```env
DEBUG=True
SECRET_KEY=your-secret-key
DATABASE_URL=sqlite:///db.sqlite3
```

For provisioning Azure infrastructure, create a `.env.azure` file:

```bash
cp .env.azure.example .env.azure
```

```env
POSTGRES_USER=adminuser
POSTGRES_PASSWORD=YourStrongPassword!123
```

Never commit `.env.azure` to Git. It should be added to `.gitignore`.

---

## ☁️ Provision Azure Infrastructure

You can provision all necessary Azure resources (App Service, PostgreSQL, Blob Storage) using the built-in script:

### 1. Prepare `.env.azure`

Create the environment file:

```bash
cp .env.azure.example .env.azure
```

Then set your actual values in `.env.azure`:

```env
POSTGRES_USER=adminuser
POSTGRES_PASSWORD=YourStrongPassword!123
```

Make sure `.env.azure` is in `.gitignore` and **never committed**.

### 2. Install Azure CLI (if needed)

```bash
make az-install
```

> macOS and Linux are supported. For Windows, install Azure CLI manually.

### 3. Provision the resources

```bash
make provision
```

This script will:

- Create a resource group `kpn-news-rg`
- Create a Linux App Service plan and Web App (`kpn-news-app`)
- Create a PostgreSQL Flexible Server (burstable B1ms)
- Create a Blob Storage account and media container

---

## 🔧 Post-Deployment Setup

After deployment (e.g., via GitHub Actions to Azure), run the following management commands
from the App Service SSH console or a local shell connected to the environment:

```bash
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser
```

These are required to initialize your database and admin panel for production.

---

## 🗂 Project Structure

This project contains both backend and frontend code. Here's how the codebase is organized:

```
.
├── myproject/              # Django/Wagtail backend application
│   ├── home/               # Homepage app
│   ├── news/               # News app
│   └── ...
├── static_src/             # Tailwind, JS, and frontend source files
├── static_compiled/        # Compiled frontend assets (output by Webpack)
├── templates/              # Jinja/Django templates
├── node_modules/           # Installed Node packages (auto-generated)
├── package.json            # Node project config for Tailwind/Webpack
├── tailwind.config.js      # Tailwind CSS config
├── webpack.config.js       # Webpack bundler config
├── manage.py               # Django entry point
├── requirements.txt        # Python dependencies
├── Makefile                # Setup, linting, deployment scripts
└── provision_azure_resources.sh # Azure resource setup script
```

---

## ⚙️ Technologies Used

| Layer      | Tech Stack                     |
|------------|--------------------------------|
| Backend    | Python, Django, Wagtail        |
| Frontend   | Tailwind CSS, Webpack, JS      |
| Deployment | Azure App Service, PostgreSQL, Blob Storage |
| Dev Tools  | Make, GitHub Actions, Codespaces |

---

## 🧭 How They Work Together

- The backend serves content and logic using Django and Wagtail.
- The frontend assets are authored using Tailwind CSS and compiled via Webpack.
- Compiled assets are collected with Django's `collectstatic` and served from Azure Blob Storage in production.
- You can provision infrastructure using the included shell script and deploy automatically using GitHub Actions.

---

## 📦 License

[BSD 3-Clause License](LICENSE)
