#!/bin/bash

apt update -y
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
sysctl -p
apt install network-manager* bind9 isc-dhcp-server nginx ca-certificates -y

echo "Firewall...."
iptables -t nat -A POSTROUTING -o eth0 -s 172.16.1.0/24 -j MASQUERADE
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 5000 -j DNAT --to-destination 172.16.1.50:22
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 123 -j DNAT --to-destination 172.16.2.254:123

iptables -A INPUT -i lo -J ACCEPT
iptables -A INPUT -i eth1 -J ACCEPT
iptables -A INPUT -i gre1 -J ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED, RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 123 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT

iptables -P INPUT DROP
iptables -A INPUT -j DROP

echo "dhcp-server"
sed -ie "s/INTERFACESv4=\"\"/INTERFACESv4=\"eth0 eth1\"/" /etc/default/isc-dhcp-server
systemctl enable --now isc-dhcp-server

echo "ssh"
sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
ssh-keygen
systemctl restart ssh

echo "/usr/share/ca-certificates/"