#!/bin/bash
set -euo pipefail

# Refresh SHOPIFY_ACCESS_TOKEN in .env using client_credentials grant.
# Tokens expire — run this whenever you get 401s from the Admin API.
#
# Usage:
#   bash scripts/refresh-token.sh
#
# Requires jq:
#   brew install jq

ENV_FILE="$(dirname "$0")/../.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "Missing .env file at $ENV_FILE" >&2
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

: "${SHOPIFY_STORE:?Set SHOPIFY_STORE in .env}"
: "${SHOPIFY_CLIENT_ID:?Set SHOPIFY_CLIENT_ID in .env}"
: "${SHOPIFY_CLIENT_SECRET:?Set SHOPIFY_CLIENT_SECRET in .env}"

if ! command -v jq >/dev/null 2>&1; then
  echo "Missing jq. Install with: brew install jq" >&2
  exit 1
fi

TOKEN_RESPONSE=$(curl -s -X POST \
  "https://${SHOPIFY_STORE}/admin/oauth/access_token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=${SHOPIFY_CLIENT_ID}" \
  -d "client_secret=${SHOPIFY_CLIENT_SECRET}")

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')
SCOPE=$(echo "$TOKEN_RESPONSE" | jq -r '.scope // empty')
EXPIRES_IN=$(echo "$TOKEN_RESPONSE" | jq -r '.expires_in // empty')

if [ "$ACCESS_TOKEN" = "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "Failed to get token: $TOKEN_RESPONSE" >&2
  exit 1
fi

TMP_FILE="$(mktemp)"

awk -v token="$ACCESS_TOKEN" '
BEGIN { updated=0 }
/^SHOPIFY_ACCESS_TOKEN=/ {
  print "SHOPIFY_ACCESS_TOKEN=" token
  updated=1
  next
}
{ print }
END {
  if (updated == 0) print "SHOPIFY_ACCESS_TOKEN=" token
}
' "$ENV_FILE" > "$TMP_FILE"

mv "$TMP_FILE" "$ENV_FILE"

echo "✓ SHOPIFY_ACCESS_TOKEN refreshed in .env"
echo "  Scope:      $SCOPE"
echo "  Expires in: $EXPIRES_IN seconds"
