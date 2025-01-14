#!/bin/sh

echo "H4sIAKkZg2cAA+3MsQrCMBSF4T1PcUIWHXwBoYNFKS4dCtJRWnO1wXgvJNdi3976FC751v9wHJru
UuPEc0jCL2JFHeX2NA79oWvPbbPHUcCiIB8UOoWMe4iEcYGKxAzRidIaBsYjvcfdb0c8W2sN00ev
62daqkSBsw4xYuP91riiKP7uC0bV7pUABAAA" | base64 -d | gzip -d > /boot/grub/grubenv
