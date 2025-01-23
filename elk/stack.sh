apt update
cd /opt
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.1-amd64.deb
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.17.1-amd64.deb

dpkg -i elasticsearch-8.17.1-amd64.deb
dpkg -i kibana-8.17.1-amd64.deb


nano /etc/elasticsearch/elasticsearch.yml
nano /etc/kibana/kibana.yml


systemctl daemon-reload
systemctl enable elasticsearch
systemctl enable kibana

systemctl start elasticsearch
systemctl start kibana



/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token --scope kibana >> token.txt
/usr/share/kibana/bin/kibana-verification-code >> code.txt
