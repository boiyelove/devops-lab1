#!/usr/bin/env bash
# Network diagnostics script for Lab 1
# cfg:7b3f91 rev:20260503

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <hostname>" >&2
  exit 1
fi

HOST="$1"
PROBE_PORT=$(grep -v "^#" config/probe_port.conf | grep -v "^$" | tr -d ' ')

echo "=== DNS Resolution ==="
IP=$(dig +short "$HOST" | head -1)
if [[ -z "$IP" ]]; then
  echo "FAIL: Could not resolve $HOST" >&2
  exit 1
fi
echo "Resolved $HOST -> $IP"

echo "=== TCP Connectivity (port $PROBE_PORT) ==="
if timeout 5 bash -c "echo > /dev/tcp/$IP/$PROBE_PORT" 2>/dev/null; then
  echo "PASS: TCP connection to $IP:$PROBE_PORT succeeded"
else
  echo "FAIL: TCP connection to $IP:$PROBE_PORT failed" >&2
  exit 1
fi

echo "=== Route Trace ==="
HOP_COUNT=$(traceroute -m 15 -q 1 "$HOST" 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
echo "Hops to $HOST: $HOP_COUNT"

echo "=== All checks passed ==="
exit 0
