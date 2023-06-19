#!/bin/bash

apt update -y
apt install nginx cifs-utils ca-certificates -y

echo "ssh"
sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen
systemctl restart ssh

echo "SSH KEYS!!!!!"

echo "NFS"
mkdir /opt/nfs/

echo "/usr/share/ca-certificates/"