#!/bin/bash
set -euo pipefail

# ---------- Automatically go to the project root ----------
# This works whether you run the script from inside the repo or elsewhere
REPO_ROOT="$HOME/git/tiny/tiny-clickhouse"
cd "$REPO_ROOT"
echo "Working in project root: $REPO_ROOT"
# -----------------------------------------------------------

CSV_FILE="metadata/major_account.csv"
S3_DEST="s3://tinyemail-metadata/clickhouse/major_account.csv"

# Don't hard-code the password — read it securely at runtime
CLICKHOUSE_PRODUCTION_PASSWORD="${CLICKHOUSE_PRODUCTION_PASSWORD:-}"
CLICKHOUSE_PRODUCTION_HOST="${CLICKHOUSE_PRODUCTION_HOST:-}"
MIGRATION_SQL="migrations/22_create_major_account_dictionary.sql"

# Prompt for password if not already set in the environment
if [[ -z "$CLICKHOUSE_PRODUCTION_PASSWORD" ]]; then
  read -sp "ClickHouse password: " CLICKHOUSE_PRODUCTION_PASSWORD
  echo
fi

echo "=== Uploading CSV to S3 ==="
aws s3 cp "$CSV_FILE" "$S3_DEST" --only-show-errors

echo "=== Running ClickHouse migration: $MIGRATION_SQL ==="
clickhouse client \
  --host "$CLICKHOUSE_PRODUCTION_HOST" \
  --password "$CLICKHOUSE_PRODUCTION_PASSWORD" \
  --secure \
  --multiquery \
  --time \
  --progress \
  < "$MIGRATION_SQL"

echo "=== All done! ==="