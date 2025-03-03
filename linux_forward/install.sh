cd /opt
wget -O splunkforwarder-9.4.0-6b4ebe426ca6-linux-amd64.tgz "https://download.splunk.com/products/universalforwarder/releases/9.4.0/linux/splunkforwarder-9.4.0-6b4ebe426ca6-linux-amd64.tgz"
tar -xvf splunkforwarder-9.4.0-6b4ebe426ca6-linux-amd64.tgz
cd /opt/splunkforwarder
./bin/splunk start --accept-license --no-prompt --answer-yes --seed-passwd Password123!
./bin/splunk enable boot-start
./bin/splunk add forward-server 192.168.10.100:9997 -auth admin:Password123!
#./bin/splunk add monitor /var/log/squid/access.log -sourcetype squid:access


nano /opt/splunkforwarder/etc/system/local/inputs.conf

[monitor:///var/log/squid/access.log]
index = proxy
sourcetype = squid:access


./bin/splunk restart

/opt/splunkforwarder/bin/splunk status
