#!/bin/bash

VAULT_ADDR='http://127.0.0.1:8200'
VAULT_TOKEN='VAULT_TOKEN'
SECRET_PATH='secret/data/skills-utilization'
ENV_FILE='../Skills_Utilization/.env'

export VAULT_ADDR
export VAULT_TOKEN
 
echo "Checking Vault for secrets..."
 
if ! vault kv get "$SECRET_PATH" >/dev/null 2>&1; then
  echo "No secrets found. Creating initial secrets in Vault..."
 
  vault kv put "$SECRET_PATH" \
    POSTGRES_PASSWORD="123456" \
    DATABASE_URL="postgresql://postgres:123456@db:5432/course_recommendation_db" \
    SECRET_KEY="temporary-secret-key" \
    JWT_SECRET_KEY="temporary-jwt-secret-key"
 
  if [ $? -ne 0 ]; then
    echo "Failed to create secrets in Vault."
    exit 1
  fi
fi
 
echo "Retrieving secrets from Vault..."
 
SECRETS=$(vault kv get -format=json "$SECRET_PATH")
 
if [ $? -ne 0 ]; then
  echo "Failed to retrieve secrets from Vault."
  exit 1
fi
 
echo "Saving secrets to $ENV_FILE..."
 
echo "$SECRETS" | jq -r \
  '.data.data | to_entries[] | .key + "=" + (.value|tostring)' \
> "$ENV_FILE"
 
if [ $? -ne 0 ]; then
  echo "Failed to save secrets."
  exit 1
fi
 
echo "Secrets retrieved successfully."
