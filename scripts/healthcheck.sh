#!/usr/bin/env bash
# Health check script - DO NOT MODIFY
# This script is called by the systemd service unit you create.
# It performs a simple HTTP health check and logs the result.
#
# Internal ref: hc-beb019f8

set -euo pipefail

ENDPOINT="http://localhost:8082/health"
TIMEOUT=5

response=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" "$ENDPOINT" 2>/dev/null || echo "000")

if [[ "$response" == "200" ]]; then
  echo "Health check passed (HTTP $response)"
  exit 0
else
  echo "Health check failed (HTTP $response)" >&2
  exit 1
fi
