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

# Enable systemd-growfs for the root partition
echo "=> Enabling systemd-growfs"
awk '$2 == "/" && $4 !~ /x-systemd.growfs/ { $4 = $4 ",x-systemd.growfs" } 1' /etc/fstab > /tmp/fstab.tmp && mv /tmp/fstab.tmp /etc/fstab

echo "=> Base System Setup completed."
