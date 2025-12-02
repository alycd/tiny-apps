#!/bin/bash

decrypt() {
  short="$1"

  # Apply same replacements as Java
  fixed=$(echo "$short" | sed 's/_/\//g; s/-/+/g')

  # Decode Base64 into raw bytes then convert to UUID
  echo "$fixed" \
    | base64 --decode \
    | xxd -p -c 16 \
    | sed 's/\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)/\1\2\3\4-\5\6-\7\8-\9\10-\11\12\13\14\15\16/' \
    | tr 'a-f' 'a-f'
}

# If arguments are provided, decode each
if [ $# -gt 0 ]; then
  for val in "$@"; do
    echo "Encrypted : $val"
    echo "Decrypted : $(decrypt "$val")"
    echo "--------------------------"
  done
else
  echo "Usage:"
  echo "  ./decrypt_uuid.sh <short-uuid> [more...]"
fi
