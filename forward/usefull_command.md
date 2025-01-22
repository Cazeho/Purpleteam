http://localhost:8000/fr-FR/app/splunk_monitoring_console/forwarder_instance?form.time.earliest=-4h%40m&form.time.latest=now&form.funcVolume=avg&form.hostname=windows2019

http://localhost:8000/fr-FR/app/splunk_monitoring_console/monitoringconsole_overview



C:\Program Files\SplunkUniversalForwarder\etc\system\local


rename to inputs.conf


dsa.msc



enable reception in port 9997
create index win
readapt macro with use of index win

| tstats count where index=* by host,sourcetype _time
| rex field=host "(?<host>[^.]+)" 
| eval host=upper(host) 
| stats dc(host) as number_of_hosts dc(sourcetype) as number_of_sourcetype

## index

- win => sysmon (ok)
- proxy => squid (ok)
- suricata => suricata 
- mail => hmail
- web => IIS
