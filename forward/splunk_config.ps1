[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
IEX((new-object net.webclient).downloadstring("https://raw.githubusercontent.com/Cazeho/Purpleteam/refs/heads/main/forward/splunk_config.ps1"));


"C:\Program Files\splunkforwarder-9.4.0-6b4ebe426ca6-windows-x64.msi" 'WINEVENTLOG_SEC_ENABLE=0 WINEVENTLOG_SYS_ENABLE=0 WINEVENTLOG_APP_ENABLE=0 PRIVILEGESECURITY=1 USE_LOCAL_SYSTEM=1 SPLUNKPASSWORD=Password123! AGREETOLICENSE=YES /quiet'

"C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" edit user admin -password Password123! -auth admin:Password123!
"C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" set default-hostname windows2019 -auth admin:Password123!

sysmon64.exe -accepteula -i "C:\Program Files\sysmon\Sysmon.xml"

"C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" restart



New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\win_outputs_app\local" -ItemType Directory -Force
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\powershell_inputs_app\local" -ItemType Directory -Force
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\sysmon_inputs_app\local" -ItemType Directory -Force
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\win_inputs_app\local" -ItemType Directory -Force










