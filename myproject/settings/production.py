from .base import *  # noqa
import os
import dj_database_url

DEBUG = False

# 자동 감지된 Azure 호스트 or fallback
ALLOWED_HOSTS = [os.getenv("WEBSITE_HOSTNAME", "localhost")]

SECRET_KEY = os.getenv("SECRET_KEY")

DATABASES = {
    "default": dj_database_url.config(conn_max_age=600)
}

STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"
MIDDLEWARE.insert(1, "whitenoise.middleware.WhiteNoiseMiddleware")

DEFAULT_FILE_STORAGE = "storages.backends.azure_storage.AzureStorage"
AZURE_ACCOUNT_NAME = os.getenv("AZURE_ACCOUNT_NAME")
AZURE_ACCOUNT_KEY = os.getenv("AZURE_ACCOUNT_KEY")
AZURE_CONTAINER = os.getenv("AZURE_CONTAINER", "media")

SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_SSL_REDIRECT = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_REFERRER_POLICY = "no-referrer-when-downgrade"

WAGTAIL_REDIRECTS_FILE_STORAGE = "cache"
