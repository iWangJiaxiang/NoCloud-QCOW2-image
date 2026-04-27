#!/bin/bash
set -e

echo "=> [6/6] Cleanup"

apt-get -y autoremove --purge
apt-get -y clean

rm -f /var/log/*.log
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/apt/*
truncate -s 0 /etc/machine-id

echo "=> Swapping system sources to Tuna Mirrors for end user..."
# Debian APT
mkdir -p /etc/apt/mirrors
> /etc/apt/mirrors/debian.list
echo "https://mirrors.tuna.tsinghua.edu.cn/debian" > /etc/apt/mirrors/debian.list

> /etc/apt/mirrors/debian-security.list
echo "https://mirrors.tuna.tsinghua.edu.cn/debian-security" > /etc/apt/mirrors/debian-security.list

if [ -f /etc/apt/sources.list ]; then
  sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
fi
if [ -f /etc/apt/sources.list.d/debian.sources ]; then
  sed -i 's|Types: deb deb-src|Types: deb|g' /etc/apt/sources.list.d/debian.sources
fi

# Disable cloud-init mirrorlists generation if cloud-init exists
mkdir -p /etc/cloud/cloud.cfg.d
echo "generate_mirrorlists: false" > /etc/cloud/cloud.cfg.d/01_debian_cloud.cfg

# Docker APT
if [ -f /etc/apt/sources.list.d/docker.list ]; then
  sed -i 's|https://download.docker.com/linux/debian|https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian|g' /etc/apt/sources.list.d/docker.list
fi

# Node APT
if [ -f /etc/apt/sources.list.d/nodesource.list ]; then
  sed -i 's|https://deb.nodesource.com|https://mirrors.tuna.tsinghua.edu.cn/nodesource|g' /etc/apt/sources.list.d/nodesource.list
fi

echo "=> Cleanup completed."
