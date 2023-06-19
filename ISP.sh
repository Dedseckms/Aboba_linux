#!/bin/bash

apt update -y
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p
apt install network-manager* -y

echo "iptables"
iptables -t nat -A POSTROUTING -o eth0 -s 10.1.1.0/30 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 10.1.1.4/30 -j MASQUERADE 

echo "ssh"
sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen
