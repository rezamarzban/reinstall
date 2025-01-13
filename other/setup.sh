#!/bin/sh

git clone https://github.com/rezamarzban/reinstall
cd reinstall
cd other
chmod +x *.sh

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

mkdir tmp
cd tmp
zcat ../initramfs-virt | cpio -idm
install -Dm0755 ../init.sh init
cp ../initrd-network.sh .
cp ../trans.sh .
cat ../dhcpcd-openrc-10.1.0-r0.apk | tar xz --warning=no-unknown-keyword -C .
find . | cpio --quiet -o -H newc | gzip -1 > /reinstall-initrd
cp ../vmlinuz-virt /reinstall-vmlinuz
cp ../custom.cfg /boot/grub/.
cp ../grubenv /boot/grub/.
