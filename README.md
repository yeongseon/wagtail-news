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

```bash
cp .env.azure.example .env.azure
```

Then set your actual values in `.env.azure`.

### 2. Install Azure CLI (if needed)

```bash
make az-install
```

### 3. Provision the resources

```bash
make provision
```

---

## 🔧 Post-Deployment Setup (Production)

After deploying to Azure App Service, you must perform additional setup to complete production configuration.

### ✅ 1. Configure Environment Variables in Azure

Go to **Azure Portal → App Service → Configuration → Application Settings**, and add the following:

| Name               | Value (Example)                                                                 |
|--------------------|----------------------------------------------------------------------------------|
| `DATABASE_URL`     | `postgres://adminuser:MyPassword@mydb.postgres.database.azure.com:5432/mydb`    |
| `SECRET_KEY`       | `your-very-secret-django-key`                                                    |
| `AZURE_ACCOUNT_NAME` | Your Azure Storage account name                                                |
| `AZURE_ACCOUNT_KEY`  | Your Azure Storage account access key                                          |
| `AZURE_CONTAINER`    | `media` (or other name you used)                                               |

#### 🔍 How to retrieve Azure Storage environment variables

You can retrieve storage-related environment variables using the Azure CLI:

```bash
# Set your variables
RESOURCE_GROUP=kpn-news-rg
STORAGE_ACCOUNT=kpnnewsstorage

# Get Azure Storage Account Name
export AZURE_ACCOUNT_NAME=$STORAGE_ACCOUNT

# Get Azure Storage Account Key
export AZURE_ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query "[0].value" -o tsv)

# Set container name (default: media)
export AZURE_CONTAINER=media
```

You can then add these values to `.env.azure` manually or through the Azure Portal.

---

### ✅ 2. Database Configuration

The production config uses `dj_database_url`:

```python
DATABASES = {
    "default": dj_database_url.config(conn_max_age=600)
}
```

It reads `DATABASE_URL` from the environment.  
Make sure the variable is set properly in App Service.

If not set, Django may fall back to using the local `sqlite3` database, which is **not recommended in production**.

### ✅ 3. Run Production Commands

After deployment, run the following commands **inside the Azure App Service** (via SSH or App Console):

```bash
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser
```

You can also automate these steps using GitHub Actions `post-deploy` steps if needed.

---

## 📦 License

[BSD 3-Clause License](LICENSE)
