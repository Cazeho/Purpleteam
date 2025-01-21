http://localhost:8000/fr-FR/app/splunk_monitoring_console/forwarder_instance?form.time.earliest=-4h%40m&form.time.latest=now&form.funcVolume=avg&form.hostname=windows2019

http://localhost:8000/fr-FR/app/splunk_monitoring_console/monitoringconsole_overview



C:\Program Files\SplunkUniversalForwarder\etc\system\local


rename to inputs.conf


dsa.msc



enable reception in port 9997
create index win
readapt macro with use of index win



index

- win
- proxy
- mail
- web
