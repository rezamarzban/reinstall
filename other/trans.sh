#!/bin/sh

printf '\nyes' | setup-sshd
echo "root:123@@@" | chpasswd 
