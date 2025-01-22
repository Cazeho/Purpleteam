Generation du self signed certificate :
 
  
ssl bump certificate  
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -keyout  
squidCA.pem -out squidCA.pem  
The der certificate was generated and deployed on client computer trusted  
root  
openssl x509 -in squidCA.pem -outform DER -out squidCA.der
 
download ca-bundle.crt :
https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt
 
copie ca-bundle.crt to C:\Squid\etc\ssl\certs\ca-bundle.crt
 
Configuration
```
#
# Recommended minimum configuration:
#
 
# Example rule allowing access from your local networks.
# Adapt to list your (internal) IP networks from where browsing
# should be allowed
 
acl localnet src 10.0.0.0/8	# RFC1918 possible internal network
acl localnet src 172.16.0.0/12	# RFC1918 possible internal network
acl localnet src 192.168.0.0/16	# RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
 
acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl CONNECT method CONNECT
 
#
# Recommended minimum Access Permission configuration:
#
 
# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager
 
# Deny requests to certain unsafe ports
http_access deny !Safe_ports
 
# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports
 
# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
#http_access deny to_localhost
 
#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#
 
# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
http_access allow localhost
 
# And finally deny all other access to this proxy
http_access deny all
 
# Squid normally listens to port 3128
#http_port 3128
 
 
http_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=C:\Squid\etc\ssl\squidca.pem
#C:\Squid\etc\ssl\certs\ca-bundle.crt
 
#sslproxy_foreign_intermediate_certs C:\Squid\etc\ssl\certs\ca-bundle.crt
tls_outgoing_options cafile=C:\Squid\etc\ssl\certs\ca-bundle.crt
 
#acl ssl_exclude_domains ssl::server_name "/cygdrive/c/squid/etc/squid/ssl_exclude_domains.conf"
#acl ssl_exclude_ips     dst              "/cygdrive/c/squid/etc/squid/ssl_exclude_ips.conf"
 
#always_direct allow all
 
acl step1 at_step SslBump1
ssl_bump peek step1
ssl_bump bump all
sslcrtd_program C:\Squid\lib\squid\security_file_certgen.exe -s c:\Squid\var\cache\ssl_db2 -M 4 Mo
 
# Uncomment the line below to enable disk caching - path format is /cygdrive/<full path to cache folder>, i.e.
#cache_dir aufs /cygdrive/d/squid/cache 3000 16 256
 
 
# Leave coredumps in the first cache dir
#coredump_dir /var/cache/squid
 
# Add any of your own refresh_pattern entries above these.
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320
 
dns_nameservers 8.8.8.8 208.67.222.222
 
max_filedescriptors 3200
 
logformat splunk_recommended_squid %ts.%03tu logformat=splunk_recommended_squid duration=%tr src_ip=%>a src_port=%>p dest_ip=%<a dest_port=%<p user_ident="%[ui" user="%[un" local_time=[%tl] http_method=%rm request_method_from_client=%<rm request_method_to_server=%>rm url="%ru" http_referrer="%{Referer}>h" http_user_agent="%{User-Agent}>h" status=%>Hs vendor_action=%Ss dest_status=%Sh total_time_milliseconds=%<tt http_content_type="%mt" bytes=%st bytes_in=%>st bytes_out=%<st sni="%ssl::>sni"
 
access_log daemon:C:\Squid\var\log\squid\access.log splunk_recommended_squid
```
