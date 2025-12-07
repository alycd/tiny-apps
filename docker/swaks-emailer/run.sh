#!/bin/bash
# Run the swaks-emailer container with environment variables

# Check if SMTP_PASSWORD is set
if [ -z "$SMTP_PASSWORD" ]; then
    echo "❌ Error: SMTP_PASSWORD environment variable is not set"
    echo ""
    echo "Usage:"
    echo "  export SMTP_PASSWORD=\"your-password\""
    echo "  ./run.sh"
    echo ""
    echo "Or run directly:"
    echo "  SMTP_PASSWORD=\"your-password\" ./run.sh"
    exit 1
fi

echo "Running swaks-emailer container..."
echo ""

docker run --rm \
    -e SMTP_PASSWORD="${SMTP_PASSWORD}" \
    -e SMTP_SERVER="${SMTP_SERVER:-smtp.ongage.tiny-email.com}" \
    -e SMTP_PORT="${SMTP_PORT:-2525}" \
    -e AUTH_METHOD="${AUTH_METHOD:-LOGIN}" \
    swaks-emailer

# Alternative: Run with all custom environment variables
# docker run --rm \
#     -e SMTP_PASSWORD="your-password" \
#     -e SMTP_SERVER="smtp.ongage.tiny-email.com" \
#     -e SMTP_PORT="2525" \
#     -e AUTH_METHOD="LOGIN" \
#     swaks-emailer

# Alternative: Run with specific email test parameters calling send-email.sh
# docker run --rm \
#   -e SMTP_SERVER="smtp.ongage.tiny-email.com" \
#   -e SMTP_PORT="2525" \
#   -e AUTH_METHOD="LOGIN" \
#   -e SMTP_USER="ailani.bm@em.nestsupportgroup.com" \
#   -e SMTP_PASSWORD="$SMTP_PASSWORD" \
#   -e FROM_EMAIL="ailani.bm@em.nestsupportgroup.com" \
#   -e TO_EMAILS="alysidi@gmail.com,deliverability@tinyemail.com" \
#   -e TEST_SUBJECT="SMTP Sender Test - $(date +'%b %d %H:%M')" \
#   -e TEST_BODY="This is a test to see if ailani.bm@em.nestsupportgroup.com can send mail." \
#   swaks-emailer \
#   /app/send-email.sh
