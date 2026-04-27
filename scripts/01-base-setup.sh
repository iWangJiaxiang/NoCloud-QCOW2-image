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



echo "=> Base System Setup completed."
