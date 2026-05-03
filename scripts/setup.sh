#!/usr/bin/env bash
set -euo pipefail

# Only user creation, missing SSH and firewall
if ! id deployer &>/dev/null; then
  useradd -m -s /bin/bash deployer
  usermod -aG sudo deployer
fi
