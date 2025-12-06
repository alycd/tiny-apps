#!/bin/bash
set -euo pipefail

# Your encoded string (can also pass as argument)
INPUT="${1:-0ZAyKmMWsm-5TgOHZhpctZhzaoaIbkLqHTQ8drvXjTnBvw0qVCKYoSyr-WJu_ERQepJyzo18aZoKyASzfGsrYVEdqi7nngUUp56ryubu6yCysXHJAN7X5moFsJWcwM2BBh55XvRx3q618K5NFH5tlLF3yutK0paYwBzF3vf4p34}"

# 1. Extract part after the dash
ENCODED_PAYLOAD=$(echo "$INPUT" | cut -d '-' -f 2-)

# 2. base64url → standard base64
B64=$(echo "$ENCODED_PAYLOAD" | tr '_-' '/+' )

# 3. Add padding if needed
case ${#B64} % 4 in
  2) B64="${B64}==" ;;
  3) B64="${B64}=" ;;
esac

# 4. Decrypt with OpenSSL (key is exactly "MySuperSecretKey" in UTF-8 → 16 bytes)
DECRYPTED=$(echo "$B64" | openssl enc -d -aes-128-ecb -base64 -K $(printf '%s' "MySuperSecretKey" | xxd -p) 2>/dev/null || { echo "Decrypt failed — wrong key?"; exit 1; })

# 5. Convert to hex for easy parsing
HEX=$(echo -n "$DECRYPTED" | xxd -p | tr -d '\n')

# 6. Parse exactly like the Java code
email_len=$((16#${HEX:0:2}))           # first byte → unsigned int
email_hex=${HEX:2:${email_len}*2}
email=$(echo "$email_hex" | xxd -r -p)

pos=$((2 + ${email_len}*2))
account_hex=${HEX:$pos:32}
relay_hex=${HEX:$((pos+32)):32}
activity_hex=${HEX:$((pos+64)):}

account_uuid=$(printf "%s-%s-%s-%s-%s" \
  "${account_hex:0:8}" "${account_hex:8:4}" "${account_hex:12:4}" "${account_hex:16:4}" "${account_hex:20:32}" | \
  sed -e 's/../&-/g; s/-$//' | sed 's/\(..\)/\1/g' | fold -w2 | paste -sd'-' -)

relay_uuid=$(printf "%s-%s-%s-%s-%s" \
  "${relay_hex:0:8}" "${relay_hex:8:4}" "${relay_hex:12:4}" "${relay_hex:16:4}" "${relay_hex:20:32}" | \
  sed -e 's/../&-/g; s/-$//' | sed 's/\(..\)/\1/g' | fold -w2 | paste -sd'-' -)

activity=$(echo "$activity_hex" | xxd -r -p)

echo "Email       : $email"
echo "Account ID  : $account_uuid"
echo "Relay ID    : $relay_uuid"
echo "Activity ID : $activity"