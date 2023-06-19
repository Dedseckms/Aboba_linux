#!/bin/bash

#nmcli con del id eth0
#nmcli con add con-name eth0 ifname eth0 autoconnect yes type ethernet ip4 "172.16.2.25/24" gw4 172.16.2.254

yum install nano nginx NetworkManager-tui ncurses samba -y

echo "Samba"
mkdir /opt/nfs/site{1,2} -p
systemctl enable smb --now
echo "" > /etc/samba/smb.conf

echo "l-srv site1" > /opt/nfs/site1/index1.html
echo "l-srv site2" > /opt/nfs/site2/index2.html
echo "r-srv site1" > /opt/nfs/site1/index1.html
echo "r-srv site2" > /opt/nfs/site2/index2.html