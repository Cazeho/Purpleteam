apt-get update && sudo apt-get install -y squid-common squid squidclient libecap3 libecap3-dev

mkdir -p /etc/squid/ssl_cert

chmod 700 ssl_cert/

openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout myCA.pem -out myCA.pem

openssl x509 -in myCA.pem -outform DER -out myCA.der




http_port 3128 ssl-bump cert=/etc/squid/ssl_cert/squidCA.pem generate-host-certificates=on dynamic_cert_mem_cache_size=4MB

acl step1 at_step SslBump1
ssl_bump peek step1
ssl_bump bump all

# Certificate error handling
sslproxy_cert_error allow all
sslproxy_flags DONT_VERIFY_PEER
