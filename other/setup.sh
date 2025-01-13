#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

# Update the package lists and install required dependencies
sudo apt update && sudo apt install git cpio gzip gawk tar coreutils -y || { echo "Failed to install dependencies."; exit 1; }

# Clone the reinstall repository from GitHub
git clone https://github.com/rezamarzban/reinstall || { echo "Failed to clone repository."; exit 1; }

# Navigate to the reinstall directory
cd reinstall || { echo "Failed to enter 'reinstall' directory."; exit 1; }

# Navigate to the 'other' directory inside the repository
cd other || { echo "Failed to enter 'other' directory."; exit 1; }

# Make all shell scripts in the directory executable
chmod +x *.sh || { echo "Failed to make scripts executable."; exit 1; }

# Fetch the MAC address of the VPS
MAC_ADDRESS=$(ip link | awk '/ether/ {print $2; exit}') || { echo "Failed to fetch MAC address."; exit 1; }

# Fetch the IP address of the VPS
IP_ADDRESS=$(ip -o -f inet addr show | awk '/scope global/ {print $4; exit}') || { echo "Failed to fetch IP address."; exit 1; }

# Fetch the default gateway of the VPS
GATEWAY=$(ip route | awk '/default/ {print $3; exit}') || { echo "Failed to fetch gateway."; exit 1; }

# IPV6_ADDRESS, IPV6_GATEWAY, and PARAM6
IPV6_ADDRESS=''
IPV6_GATEWAY=''
PARAM6='false'

# Generate the replacement string for the init.sh script
REPLACEMENT="'/initrd-network.sh' '$MAC_ADDRESS' '$IP_ADDRESS' '$GATEWAY' '$IPV6_ADDRESS' '$IPV6_GATEWAY' '$PARAM6'"

# Path to the init.sh file
INIT_FILE="init.sh"

# Replace the placeholder in the init.sh file with the generated values
if [ -f "$INIT_FILE" ]; then
    sed -i "s|'/initrd-network.sh' '' '' '' '' '' 'false'|$REPLACEMENT|" "$INIT_FILE" || { echo "Failed to replace placeholder in $INIT_FILE."; exit 1; }
    echo "Replaced string in $INIT_FILE:"
    echo "$REPLACEMENT"
else
    echo "File $INIT_FILE not found!"
    exit 1
fi

# Create a temporary directory to work in
mkdir tmp || { echo "Failed to create 'tmp' directory."; exit 1; }

# Enter the temporary directory
cd tmp || { echo "Failed to enter 'tmp' directory."; exit 1; }

# Extract the initramfs-virt file
zcat ../initramfs-virt | cpio -idm || { echo "Failed to extract initramfs-virt."; exit 1; }

# Install the init script with the correct permissions
install -Dm0755 ../init.sh init || { echo "Failed to install init script."; exit 1; }

# Copy necessary scripts into the working directory
cp ../initrd-network.sh . || { echo "Failed to copy initrd-network.sh."; exit 1; }
cp ../trans.sh . || { echo "Failed to copy trans.sh."; exit 1; }

# Extract the dhcpcd package contents
cat ../dhcpcd-10.1.0-r0.apk | tar xz --warning=no-unknown-keyword -C . || { echo "Failed to extract dhcpcd package."; exit 1; }

# Create a new initramfs file with the modified contents
find . | cpio --quiet -o -H newc | gzip -1 > /reinstall-initrd || { echo "Failed to create reinstall-initrd."; exit 1; }

# Copy the virtual kernel image to the root directory
cp ../vmlinuz-virt /reinstall-vmlinuz || { echo "Failed to copy vmlinuz-virt."; exit 1; }

# Copy GRUB configuration files to the boot directory
cp ../custom.cfg /boot/grub/. || { echo "Failed to copy custom.cfg."; exit 1; }
cp ../grubenv /boot/grub/. || { echo "Failed to copy grubenv."; exit 1; }

echo "Setup completed successfully, Now reboot."
