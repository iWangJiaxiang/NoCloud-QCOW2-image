#!/bin/bash
set -e

echo "=> [5/6] OpenCode Setup"

# opencode installation script (anomalyco/opencode)
export OPENCODE_INSTALL_DIR=/usr/local/bin
curl -fsSL https://opencode.ai/install | bash

echo "=> OpenCode Setup completed."
