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

echo "=> Apt Packages Installation completed."
