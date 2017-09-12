#!/bin/bash
set -e

# Create user
if [[ -n ${DB_USER} ]]; then
  if [[ -z ${DB_PASS} ]]; then
    echo "ERROR! Please specify a password for DB_USER in DB_PASS. Exiting..."
    exit 1
  fi
  echo "Creating database user: ${DB_USER}"
  if [[ -z $(psql -U ${POSTGRES_USER} -Atc "SELECT 1 FROM pg_catalog.pg_user WHERE usename = '${DB_USER}'";) ]]; then
    psql -U ${POSTGRES_USER} -c "CREATE ROLE \"${DB_USER}\" with LOGIN CREATEDB PASSWORD '${DB_PASS}';" >/dev/null
  fi
fi

# Create databases
if [[ -n ${DB_NAME} ]]; then
  for database in $(awk -F',' '{for (i = 1 ; i <= NF ; i++) print $i}' <<< "${DB_NAME}"); do
    echo "Creating database: ${database}..."
    if [[ -z $(psql -U ${POSTGRES_USER} -Atc "SELECT 1 FROM pg_catalog.pg_database WHERE datname = '${database}'";) ]]; then
      psql -U ${POSTGRES_USER} -c "CREATE DATABASE \"${database}\" WITH TEMPLATE = \"template1\";;" >/dev/null
    fi

    if [[ ${DB_UNACCENT} == true ]]; then
      echo "‣ Loading unaccent extension..."
      psql -U ${POSTGRES_USER} -d ${database} -c "CREATE EXTENSION IF NOT EXISTS unaccent;" >/dev/null 2>&1
    fi

    if [[ -n ${DB_USER} ]]; then
      echo "‣ Granting access to ${DB_USER} user..."
      psql -U ${POSTGRES_USER} -c "GRANT ALL PRIVILEGES ON DATABASE \"${database}\" to \"${DB_USER}\";" >/dev/null
    fi
  done
fi

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
echo "Allow connections from all hosts"
echo "host all  all    0.0.0.0/0  md5" >> "$PGDATA/pg_hba.conf"

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
echo "Adding listen addresses from anywhere"
echo "listen_addresses='*'" > "$PGDATA/postgresql.conf"
