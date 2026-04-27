#!/bin/bash
set -e

QCOW_URL="https://cloud.debian.org/images/cloud/trixie/latest/debian-13-nocloud-amd64.qcow2"
QCOW_IMG="debian-13-nocloud-amd64.qcow2"
ROOT_PASSWORD="root"
OUTPUT_DIR="release"

echo "=> Downloading Debian 13 NoCloud QCOW2 image..."
if [ ! -f "${QCOW_IMG}" ]; then
  wget -q "${QCOW_URL}" -O "${QCOW_IMG}"
else
  echo "=> Image already exists, skipping download."
fi

# Ensure virt-customize exists
if ! command -v virt-customize &> /dev/null; then
  echo "=> virt-customize not found. Please install libguestfs-tools (and qemu-utils)."
  exit 1
fi

echo "=> Preparing release directory..."
mkdir -p "${OUTPUT_DIR}"
cp "${QCOW_IMG}" "${OUTPUT_DIR}/${QCOW_IMG}"

echo "=> Customizing Image..."

virt-customize -a "${OUTPUT_DIR}/${QCOW_IMG}" \
  --smp 2 \
  --timezone "Asia/Shanghai" \
  --root-password password:"${ROOT_PASSWORD}" \
  --run scripts/01-base-setup.sh \
  --run scripts/02-apt-packages.sh \
  --run scripts/03-docker.sh \
  --run scripts/04-dev-env.sh \
  --run scripts/05-opencode.sh \
  --run scripts/06-cleanup.sh

echo "=> Build completed successfully. Customized image is ready at: ${OUTPUT_DIR}/${QCOW_IMG}"
