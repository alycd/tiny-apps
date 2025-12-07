#!/bin/bash
# Run send-email.sh directly with custom environment variables

# Check required environment variables
if [ -z "$SMTP_PASSWORD" ]; then
    echo "❌ Error: SMTP_PASSWORD environment variable is not set"
    exit 1
fi

if [ -z "$SMTP_USER" ]; then
    echo "❌ Error: SMTP_USER environment variable is not set"
    exit 1
fi

if [ -z "$FROM_EMAIL" ]; then
    echo "❌ Error: FROM_EMAIL environment variable is not set"
    exit 1
fi

if [ -z "$TO_EMAILS" ]; then
    echo "❌ Error: TO_EMAILS environment variable is not set"
    exit 1
fi

echo "Running send-email.sh with custom parameters..."
echo "From: ${FROM_EMAIL}"
echo "To: ${TO_EMAILS}"
echo ""

docker run --rm \
    -e SMTP_USER="${SMTP_USER}" \
    -e SMTP_PASSWORD="${SMTP_PASSWORD}" \
    -e FROM_EMAIL="${FROM_EMAIL}" \
    -e TO_EMAILS="${TO_EMAILS}" \
    -e SMTP_SERVER="${SMTP_SERVER:-smtp.ongage.tiny-email.com}" \
    -e SMTP_PORT="${SMTP_PORT:-2525}" \
    -e AUTH_METHOD="${AUTH_METHOD:-LOGIN}" \
    -e TEST_SUBJECT="${TEST_SUBJECT}" \
    -e TEST_BODY="${TEST_BODY}" \
    swaks-emailer \
    /app/send-email.sh
