#!/bin/bash
set -e

echo "=> [5/6] OpenCode Setup"

# opencode installation script (anomalyco/opencode)
export OPENCODE_INSTALL_DIR=/usr/local/bin
curl -fsSL https://opencode.ai/install | bash

# Clean up space
apt-get -qq -y autoremove --purge || true
apt-get -qq -y clean || true
rm -rf /tmp/* /var/tmp/*

echo "=> OpenCode Setup completed."
