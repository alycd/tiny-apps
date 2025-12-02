#!/bin/bash

encrypt() {
  uuid="$1"

  # Remove dashes from UUID and convert to raw bytes
  raw=$(echo "$uuid" | tr -d '-' | xxd -r -p)

  # Base64 encode, then apply URL-safe replacements (reverse of decrypt)
  echo -n "$raw" \
    | base64 \
    | tr '+/' '-_' \
    | tr -d '='
}

# If arguments are provided, encode each
if [ $# -gt 0 ]; then
  for val in "$@"; do
    echo "Decrypted : $val"
    echo "Encrypted : $(encrypt "$val")"
    echo "--------------------------"
  done
else
  echo "Usage:"
  echo "  ./encrypt_uuid.sh <uuid> [more...]"
fi
