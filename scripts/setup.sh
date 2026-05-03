#!/usr/bin/env bash
# System setup script for Lab 1
# cfg:e1a4d2 rev:20260503

set -euo pipefail

# Task 1: Create deployer user with sudo
if ! id deployer &>/dev/null; then
  useradd -m -s /bin/bash deployer
  usermod -aG sudo deployer
  echo "deployer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deployer
  chmod 0440 /etc/sudoers.d/deployer
  echo "Created user: deployer"
else
  echo "User deployer already exists"
fi

# Task 2: Harden SSH configuration
SSHD_CONFIG="/etc/ssh/sshd_config"

sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' "$SSHD_CONFIG"
sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' "$SSHD_CONFIG"
sed -i 's/^#\?ClientAliveInterval.*/ClientAliveInterval 300/' "$SSHD_CONFIG"
sed -i 's/^#\?ClientAliveCountMax.*/ClientAliveCountMax 2/' "$SSHD_CONFIG"
sed -i 's/^#\?X11Forwarding.*/X11Forwarding no/' "$SSHD_CONFIG"
sed -i 's/^#\?AllowAgentForwarding.*/AllowAgentForwarding no/' "$SSHD_CONFIG"

echo "SSH hardened"

# Task 3: Configure UFW firewall
ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# Allow ports from config/allowed_ports.conf
ufw allow 22/tcp
ufw allow 8443/tcp
ufw allow 443/tcp

ufw --force enable
echo "UFW configured"
