#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER odoo WITH PASSWORD 'odoo';
    CREATE DATABASE odoo;
    GRANT ALL PRIVILEGES ON DATABASE odoo TO odoo;
EOSQL