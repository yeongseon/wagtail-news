#!/bin/bash

# Provision Azure resources for kpn-news project

# Load environment variables (POSTGRES_USER, POSTGRES_PASSWORD)
if [ -f .env.azure ]; then
  source .env.azure
else
  echo "❌ .env.azure not found. Please create it with POSTGRES_USER and POSTGRES_PASSWORD."
  exit 1
fi

# Variables
RESOURCE_GROUP="kpn-news-rg"
LOCATION="koreacentral"
APP_NAME="kpn-news-app"
PLAN_NAME="kpn-news-plan"
STORAGE_ACCOUNT="kpnnewsstorage"
CONTAINER_NAME="media"
POSTGRES_NAME="kpnnewsdb"

# Check if resource group already exists
if az group show --name $RESOURCE_GROUP &>/dev/null; then
  echo "✅ Resource group '$RESOURCE_GROUP' already exists."
else
  echo "➕ Creating resource group..."
  az group create --name $RESOURCE_GROUP --location $LOCATION
fi

# Create App Service plan
az appservice plan create \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku B1 \
  --is-linux

# Create Web App
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $PLAN_NAME \
  --name $APP_NAME \
  --runtime "PYTHON|3.12"

# Create PostgreSQL flexible server
az postgres flexible-server create \
  --name $POSTGRES_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --admin-user $POSTGRES_USER \
  --admin-password $POSTGRES_PASSWORD \
  --tier burstable \
  --sku-name Standard_B1ms \
  --storage-size 32

# Create storage account
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2

# Create blob container
az storage container create \
  --account-name $STORAGE_ACCOUNT \
  --name $CONTAINER_NAME \
  --public-access blob
