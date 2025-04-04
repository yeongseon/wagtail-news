# wagtail-news

A Wagtail-based news site starter template.

This project provides a preconfigured Wagtail site with example pages, styles, and layout components suitable for news publishing.

---

## 🚀 Quick Start

### 1. Clone the project

```bash
git clone https://github.com/yeongseon/wagtail-news.git
cd wagtail-news
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
| `make start`     | Alias for `make run` |
| `make superuser` | Create a Django superuser |
| `make load-data` | Load initial data (requires `migrate` first) |
| `make dump-data` | Dump database into `fixtures/demo.json` |
| `make reset`     | Reset the database (delete `db.sqlite3`, re-setup) |
| `make test`      | Run Django tests |
| `make lint`      | Run flake8 for code linting |
| `make commit`    | Add and commit all changes to Git |
| `make clean`     | Remove venv, cache, and local DB |

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

(Optional) You can also enable `.env` support via `python-dotenv` or `python-decouple`.

---

## 📦 License

[BSD 3-Clause License](LICENSE)
