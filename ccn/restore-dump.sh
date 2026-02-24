#!/bin/bash
set -e

# SPIP Restore Script
# Restores images and database from remote archives

read -rp "Enter the IMG archive URL: " IMG_URL
read -rp "Enter the database dump URL: " DUMP_URL

if [[ -z "$IMG_URL" || -z "$DUMP_URL" ]]; then
    echo "Error: Both URLs are required."
    exit 1
fi

echo "==> Updating system and installing wget..."
apt update && apt upgrade -y && apt install wget -y

echo "==> Downloading IMG archive..."
wget "$IMG_URL" -O IMG.tar.gz

echo "==> Downloading database dump..."
mkdir -p tmp/dump
wget "$DUMP_URL" -O tmp/dump/dump.sqlite

echo "==> Extracting IMG archive..."
tar -xzvf IMG.tar.gz
# To extract without overwriting existing files, uncomment the line below:
# tar -xzvf IMG.tar.gz --skip-old-files

echo "==> Restoring database with SPIP CLI..."
spip sql:dump:restore --name dump

echo "==> Cleaning up..."
rm -f IMG.tar.gz
rm -f tmp/dump/dump.sqlite

echo "==> Restore complete!"
