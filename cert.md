apt-get update && sudo apt-get install -y squid-common squid squidclient libecap3 libecap3-dev

mkdir -p /etc/squid/ssl_cert

chmod 700 ssl_cert/

openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout myCA.pem -out myCA.pem

openssl x509 -in myCA.pem -outform DER -out myCA.der


# iptables -t nat -A PREROUTING -i br0 -p tcp --dport 443 -j DNAT --to 192.168.1.51:3129
# iptables -t nat -A PREROUTING -i br0 -p tcp --dport 443 -j REDIRECT --to-port 3129
# iptables-save > /etc/iptables/rules.v4
