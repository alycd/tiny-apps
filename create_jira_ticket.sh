#!/bin/bash

# --- Jira Configuration ---
# Replace with your Jira instance URL (e.g., https://your-domain.atlassian.net)
JIRA_INSTANCE="https://martechapp.atlassian.net"

# Replace with your Jira email address
JIRA_EMAIL="aly@tinyemail.com"

# Replace with your Jira API token. Generate one at https://id.atlassian.com/manage-api-tokens
JIRA_API_TOKEN="${JIRA_API_TOKEN}"

if [ -z "${JIRA_API_TOKEN}" ]; then
  echo "Error: JIRAPAIToken environment variable is not set."
  exit 1
fi

# Replace with your Jira Project Key (e.g., "PROJ")
JIRA_PROJECT_KEY="MAR"

# Replace with your desired Issue Type (e.g., "Task", "Bug", "Story")
JIRA_ISSUE_TYPE="Task"

# --- Ticket Details ---
# Read JSON from stdin to create the ticket
JSON_INPUT=$(cat)

# Provide a summary for your Jira ticket
TICKET_SUMMARY=$(echo "$JSON_INPUT" | jq -r '.Topic')

# Provide a detailed description for your Jira ticket
STORY=$(echo "$JSON_INPUT" | jq -r '.Story')
CRITERIA=$(echo "$JSON_INPUT" | jq -r '.Criteria')

TICKET_DESCRIPTION="**Story:**
$STORY

**Acceptance Criteria:**
$CRITERIA"

# Check if summary is empty
if [ -z "$TICKET_SUMMARY" ]; then
  echo "Error: Topic is missing from JSON input."
  exit 1
fi

# --- DO NOT MODIFY BELOW THIS LINE ---

echo "Attempting to create Jira ticket..."


# Construct the JSON payload for the Jira API
JSON_PAYLOAD=$(jq -n \
  --arg projectKey "$JIRA_PROJECT_KEY" \
  --arg summary "$TICKET_SUMMARY" \
  --arg description "$TICKET_DESCRIPTION" \
  --arg issueType "$JIRA_ISSUE_TYPE" \
  '{
    "fields": {
      "project": { "key": $projectKey },
      "summary": $summary,
      "description": $description,
      "issuetype": { "name": $issueType }
    }
  }')

# Execute the curl command to create the Jira ticket
curl -s -D- \
  -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
  -X POST \
  --data "${JSON_PAYLOAD}" \
  -H "Content-Type: application/json" \
  "${JIRA_INSTANCE}/rest/api/2/issue/"
