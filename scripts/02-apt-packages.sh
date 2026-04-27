#!/bin/bash
set -e

echo "=> [2/6] Apt Packages Installation"

apt-get update

# Install requested base and networking packages
apt-get -y install \
  wget curl nano vim sudo unzip mtr-tiny iputils-ping bind9-host dnsutils net-tools \
  lsb-release ca-certificates bash-completion fail2ban dialog netbase iproute2 whois \
  ssh dbus systemd systemd-sysv locales apt-utils gnupg2 apt-transport-https rsyslog \
  logrotate less rsync qemu-guest-agent haveged systemd-timesyncd

# Install custom dev tools for vibecoding
apt-get -y install \
  tmux git jq build-essential zsh htop

# Configure SSH to allow root and password login
echo "=> Configuring SSH"
if [ -f /etc/ssh/sshd_config ]; then
  sed -i 's/^#\?\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config 2>/dev/null || true
  sed -i 's/^#\?\s*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config 2>/dev/null || true
  
  # Ensure the lines are present even if sed didn't match
  grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config || echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
  grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config || echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
fi

echo "=> Apt Packages Installation completed."
