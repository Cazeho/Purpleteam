

# https://github.com/diladele/squid-ubuntu

# add diladele apt key
wget -qO - https://packages.diladele.com/diladele_pub.asc | sudo apt-key add -

# add new repo
echo "deb https://squid610.diladele.com/ubuntu/ jammy main" \
    > /etc/apt/sources.list.d/squid610.diladele.com.list

# and install
apt-get update && apt-get install -y \
    squid-common \
    squid-openssl \
    squidclient \
    libecap3 libecap3-dev

mkdir -p /etc/squid/ssl_cert

openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/squid/ssl_cert/myCA.pem -out /etc/squid/ssl_cert/myCA.pem
openssl x509 -in myCA.pem -outform DER -out myCA.der
/usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB



squid.conf
```
acl localnet src 10.0.0.0/8     # RFC1918 possible internal network
acl localnet src 172.16.0.0/12  # RFC1918 possible internal network
acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
acl localnet src 192.168.10.0/24
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http


http_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=40MB cert=/etc/squid/ssl_cert/myCA.pem
#sslcrtd_program /usr/lib/squid/security_file_certgen -s /var/lib/ssl_db -M 40MB
#ssl_bump peek all
#ssl_bump splice all


ssl_bump server-first all
always_direct allow all
sslcrtd_program /usr/lib/squid/security_file_certgen -s /var/lib/ssl_db -M 4MB
sslcrtd_children 1000 startup=1 idle=1


logformat ssl_full %ts.%03tu logformat=ssl_full duration=%tr src_ip=%>a src_port=%>p dest_ip=%<a dest_port=%<p user_ident="%[ui" user="%[un" local_time=[%tl] http_method=%rm request_method_from_client=%<rm request_method_to_server=%>rm url="%ru" http_referrer="%{Referer}>h" http_user_agent="%{User-Agent}>h" status=%>Hs vendor_action=%Ss dest_status=%Sh total_time_milliseconds=%<tt http_content_type="%mt" bytes=%st bytes_in=%>st bytes_out=%<st sni="%ssl::>sni"


access_log /var/log/squid/access.log ssl_full


acl allowed_methods method GET POST CONNECT
http_access allow allowed_methods
http_access allow all
```

in windows server

open win+r

certmgr.msc

in "Trusted Root Certification Authorities." import myCA.der

confgure the windows proxy settings
