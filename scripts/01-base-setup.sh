#!/bin/bash
set -e

echo "=> [1/6] Base System Setup"

# Disable OS prober in grub
echo "=> Disabling grub OS prober"
echo "# disables OS prober to avoid loopback detection which breaks booting" >> /etc/default/grub
echo "GRUB_DISABLE_OS_PROBER=true" >> /etc/default/grub
update-grub



# Set NTP to Aliyun
echo "=> Configuring NTP"
echo "NTP=ntp.aliyun.com" >> /etc/systemd/timesyncd.conf

# Configure APT mirrors to Tsinghua Tuna
echo "=> Configuring APT mirrors"
# Remove deb-src
if [ -f /etc/apt/sources.list.d/debian.sources ]; then
  sed -i 's|Types: deb deb-src|Types: deb|g' /etc/apt/sources.list.d/debian.sources
fi

# Disable cloud-init mirrorlists generation if cloud-init exists
mkdir -p /etc/cloud/cloud.cfg.d
echo "generate_mirrorlists: false" > /etc/cloud/cloud.cfg.d/01_debian_cloud.cfg

# Truncate default debian lists and add Tuna
mkdir -p /etc/apt/mirrors
> /etc/apt/mirrors/debian.list
echo "https://mirrors.tuna.tsinghua.edu.cn/debian" > /etc/apt/mirrors/debian.list

> /etc/apt/mirrors/debian-security.list
echo "https://mirrors.tuna.tsinghua.edu.cn/debian-security" > /etc/apt/mirrors/debian-security.list

# Replace sources.list if it exists
if [ -f /etc/apt/sources.list ]; then
  sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
fi

echo "=> Base System Setup completed."
