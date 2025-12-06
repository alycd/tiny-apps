#!/bin/bash
# =============================================================================
# Generic Ongage SMTP delivery test using swaks
# Usage examples at the bottom
# =============================================================================

# --- Required environment variables -----------------------------------------
: "${SMTP_USER:?Error: SMTP_USER is not set}"          # e.g. bryce.bgm@em.savvyfundssaver.com
: "${SMTP_PASSWORD:?Error: SMTP_PASSWORD is not set}"  # password (can contain special chars)
: "${FROM_EMAIL:?Error: FROM_EMAIL is not set}"        # usually same as SMTP_USER
: "${TO_EMAILS:?Error: TO_EMAILS is not set}"          # comma-separated list

# --- Optional environment variables (with sensible defaults) ----------------
SMTP_SERVER="${SMTP_SERVER:-smtp.ongage.tiny-email.com}"
SMTP_PORT="${SMTP_PORT:-2525}"
AUTH_METHOD="${AUTH_METHOD:-LOGIN}"
TEST_SUBJECT="${TEST_SUBJECT:-"SMTP Sender Test - $(date +%b\ %d\ %H:%M)"}"
TEST_BODY="${TEST_BODY:-"This is a test to see if ${FROM_EMAIL} can send mail via ${SMTP_SERVER}:${SMTP_PORT}."}"

echo "=============================================================="
echo "Testing SMTP sender: ${FROM_EMAIL}"
echo "Recipient(s)       : ${TO_EMAILS}"
echo "Server             : ${SMTP_SERVER}:${SMTP_PORT}"
echo "=============================================================="

swaks \
    --server "${SMTP_SERVER}" \
    --port "${SMTP_PORT}" \
    --auth "${AUTH_METHOD}" \
    --auth-user "${SMTP_USER}" \
    --auth-password "${SMTP_PASSWORD}" \
    --from "${FROM_EMAIL}" \
    --to "${TO_EMAILS}" \
    --header "Subject: ${TEST_SUBJECT}" \
    --body "${TEST_BODY}" \
    --silent 1 \
    --quit-after AUTH

echo "--------------------------------------------------------------"
if [ $? -eq 0 ]; then
    echo "Test email sent successfully from ${FROM_EMAIL}"
else
    echo "Failed to send test email from ${FROM_EMAIL}"
    exit 1
fi
echo