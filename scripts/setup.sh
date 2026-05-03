#!/usr/bin/env bash
# cfg:e1a4d2 rev:20260503
set -euo pipefail

if ! id deployer &>/dev/null; then
  useradd -m -s /bin/bash deployer
  usermod -aG sudo deployer
  echo "deployer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deployer
  chmod 0440 /etc/sudoers.d/deployer
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' "$SSHD_CONFIG"
sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' "$SSHD_CONFIG"
sed -i 's/^#\?ClientAliveInterval.*/ClientAliveInterval 300/' "$SSHD_CONFIG"
sed -i 's/^#\?ClientAliveCountMax.*/ClientAliveCountMax 2/' "$SSHD_CONFIG"
sed -i 's/^#\?X11Forwarding.*/X11Forwarding no/' "$SSHD_CONFIG"
sed -i 's/^#\?AllowAgentForwarding.*/AllowAgentForwarding no/' "$SSHD_CONFIG"

ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 8443/tcp
ufw allow 443/tcp
ufw --force enable
