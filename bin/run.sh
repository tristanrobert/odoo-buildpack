#!/bin/bash
# usage: /app/bin/run

set -e
export PYTHONPATH="/app/odoo:$PYTHONPATH"
DB_ARGS=()
DB_ARGS+=("--db_host")
DB_ARGS+=("$DB_HOST")
DB_ARGS+=("--db_port")
DB_ARGS+=("$DB_PORT")
DB_ARGS+=("--db_user")
DB_ARGS+=("$DB_USER")
DB_ARGS+=("--db_password")
DB_ARGS+=("$DB_PASSWORD")
python3 /app/bin/wait-for-psql.py "${DB_ARGS[@]}" --timeout=30
ODOO_ARGS=()
ODOO_ARGS+=("--addons-path")
ODOO_ARGS+=("/app/odoo/odoo/addons")
ODOO_ARGS+=("--http-port")
ODOO_ARGS+=("$PORT")
if [[ "$PROXY_MODE" == "true" ]]; then
 ODOO_ARGS+=("--proxy-mode")
fi
DB_ARGS+=("--database")
DB_ARGS+=("$DB_NAME")
DB_ARGS+=("--no-database-list")
if [[ "$DB_INIT" == "true" ]]; then
 DB_ARGS+=("-i")
 DB_ARGS+=("all")
fi
ODOO_ARGS+=("${DB_ARGS[@]}")
SMTP_ARGS=()
SMTP_ARGS+=("--smtp")
SMTP_ARGS+=("$SMTP_HOST")
SMTP_ARGS+=("--smtp-port")
SMTP_ARGS+=("$SMTP_PORT")
SMTP_ARGS+=("--smtp-user")
SMTP_ARGS+=("$SMTP_USER")
SMTP_ARGS+=("--smtp-password")
SMTP_ARGS+=("$SMTP_PASSWORD")
SMTP_ARGS+=("--email-from")
SMTP_ARGS+=("$SMTP_FROM")
if [[ "$SMTP_SSL" == "true" ]]; then
 SMTP_ARGS+=("--smtp-ssl")
fi
ODOO_ARGS+=("${SMTP_ARGS[@]}")
exec python3 /app/odoo/setup/odoo "${ODOO_ARGS[@]}"