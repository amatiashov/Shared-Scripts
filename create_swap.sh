#!/bin/bash
set -e

if [ $(free | grep Swap | awk '{print $2}') -ne 0 ]; then
    echo "Swap is active. Skip..."
    exit 0
else:
    echo "Swap not found. Creating..."
fi


ACTUAL_RAM_SIZE_MB=$(free -m | awk '/^Mem:/{print $2}')
echo "Actual RAM Size: $ACTUAL_RAM_SIZE_MB Mb"

if [ $ACTUAL_RAM_SIZE_MB -le 512 ]; then
    SWAP_SIZE_MB=2048
elif [ $ACTUAL_RAM_SIZE_MB -le 4096 ]; then
    SWAP_SIZE_MB=$((ACTUAL_RAM_SIZE_MB * 2))
else
    SWAP_SIZE_MB=$((ACTUAL_RAM_SIZE_MB / 2))
fi
echo "SWAP size: $SWAP_SIZE_MB Mb"

AVAILABLE_SPACE=$(df / | tail -1 | awk '{print $4}')
AVAILABLE_SPACE_MB=$((AVAILABLE_SPACE / 1024))
echo "Available space: $AVAILABLE_SPACE_MB Mb"


if [ $AVAILABLE_SPACE_MB -lt $SWAP_SIZE_MB ]; then
    echo "Unable to create SWAP. Available: ${AVAILABLE_SPACE_MB}MB. Required: ${SWAP_SIZE_MB}MB."
    exit 1
fi


# Add Swap Space on Ubuntu
# https://linuxize.com/post/how-to-add-swap-space-on-ubuntu-20-04/
echo "Creating SWAP..."
sudo fallocate -l ${SWAP_SIZE_MB}M /swapfile
#sudo dd if=/dev/zero of=/swapfile bs=1024 count=2097152
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
free -m
