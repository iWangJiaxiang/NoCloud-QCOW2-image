#!/bin/bash
set -e

echo "=> [4/6] Development Environments Setup"

# Python UV
echo "=> Installing Python UV"
curl -LsSf https://astral.sh/uv/install.sh | sh
if [ -f /root/.cargo/bin/uv ]; then
  cp /root/.cargo/bin/uv /usr/local/bin/uv
  cp /root/.cargo/bin/uvx /usr/local/bin/uvx
elif [ -f /root/.local/bin/uv ]; then
  cp /root/.local/bin/uv /usr/local/bin/uv
  cp /root/.local/bin/uvx /usr/local/bin/uvx
fi

# Add UV global settings for Tuna mirror
mkdir -p /etc/profile.d
cat > /etc/profile.d/uv-env.sh <<EOF
export UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
EOF
chmod +x /etc/profile.d/uv-env.sh

# Node.js
echo "=> Installing Node.js"
curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb_20.x/setup_20.x | bash -
apt-get install -y nodejs

# Set npm mirror
npm config set registry https://registry.npmmirror.com -g

# Rust
echo "=> Installing Rust"
export RUSTUP_DIST_SERVER="https://mirrors.tuna.tsinghua.edu.cn/rustup"
export RUSTUP_UPDATE_ROOT="https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Link to /usr/local/bin so it's globally available
find /root/.cargo/bin -type f -exec ln -s {} /usr/local/bin/ \;

cat > /etc/profile.d/rust-env.sh <<EOF
export RUSTUP_DIST_SERVER="https://mirrors.tuna.tsinghua.edu.cn/rustup"
export RUSTUP_UPDATE_ROOT="https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup"
export PATH="\$PATH:/root/.cargo/bin"
EOF
chmod +x /etc/profile.d/rust-env.sh

# Configure Cargo directly for root user and global setting
mkdir -p /root/.cargo
cat > /root/.cargo/config.toml <<EOF
[source.crates-io]
replace-with = 'tuna'

[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"
EOF

echo "=> Development Environments Setup completed."
