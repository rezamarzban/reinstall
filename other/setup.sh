#!/bin/sh

# Fetch VPS details
MAC_ADDRESS=$(ip link | awk '/ether/ {print $2; exit}')
IP_ADDRESS=$(ip -o -f inet addr show | awk '/scope global/ {print $4; exit}')
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')
DNS=''
EXTRA=''
USE_DHCP='false'

# Generate the replacement string
REPLACEMENT="'/initrd-network.sh' '$MAC_ADDRESS' '$IP_ADDRESS' '$GATEWAY' '$DNS' '$EXTRA' '$USE_DHCP'"

# Path to the init.sh file
INIT_FILE="init.sh"

# Replace the placeholder in the init.sh file
if [ -f "$INIT_FILE" ]; then
    sed -i "s|'/initrd-network.sh' '' '' '' '' '' 'false'|$REPLACEMENT|" "$INIT_FILE"
    echo "Replaced string in $INIT_FILE:"
    echo "$REPLACEMENT"
else
    echo "File $INIT_FILE not found!"
    exit 1
fi
