#!/bin/bash
set -e

echo "=> [6/6] Cleanup"

apt-get -y autoremove --purge
apt-get -y clean

rm -f /var/log/*.log
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/apt/*
truncate -s 0 /etc/machine-id

echo "=> Cleanup completed."
