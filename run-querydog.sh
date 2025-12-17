#!/bin/bash

# Run QueryDog with environment variables
docker run \
  -p 3001:3001 \
  -e CLICKHOUSE_HOST="$CLICKHOUSE_PRODUCTION_HOST" \
  -e CLICKHOUSE_USER="default" \
  -e CLICKHOUSE_PASSWORD="$CLICKHOUSE_PRODUCTION_PASSWORD" \
  -e CLICKHOUSE_DATABASE="tinyemail" \
  -e CLICKHOUSE_SECURE=1 \
  -e CLICKHOUSE_PORT_HTTP=8443 \
  ghcr.io/benjaminwootton/querydog:latest