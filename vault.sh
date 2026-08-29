#!/bin/bash

VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="${VAULT_TOKEN}"
RESPONSE=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" "$VAULT_ADDR/v1/secret/data/db")

DB_USER=$(echo $RESPONSE | jq -r '.data.data.POSTGRES_USER // empty')
DB_PASS=$(echo $RESPONSE | jq -r '.data.data.POSTGRES_PASSWORD // empty')
DB_NAME=$(echo $RESPONSE | jq -r '.data.data.POSTGRES_DB // empty')

# استخدام قيم افتراضية إذا كانت النتيجة فارغة
DB_USER=${DB_USER:-postgres}
DB_PASS=${DB_PASS:-postgres}
DB_NAME=${DB_NAME:-skills_db}

cat <<EOF > .env
POSTGRES_USER=$DB_USER
POSTGRES_PASSWORD=$DB_PASS
POSTGRES_DB=$DB_NAME
DATABASE_URL=postgresql://$DB_USER:$DB_PASS@db:5432/$DB_NAME
EOF

echo "تم تحديث ملف .env"
