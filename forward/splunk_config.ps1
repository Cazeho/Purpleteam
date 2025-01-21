[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
IEX((new-object net.webclient).downloadstring("https://raw.githubusercontent.com/Cazeho/Purpleteam/refs/heads/main/forward/splunk_config.ps1"));
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\win_outputs_app\local" -ItemType Directory -Force
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\powershell_inputs_app\local" -ItemType Directory -Force
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\sysmon_inputs_app\local" -ItemType Directory -Force
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\win_inputs_app\local" -ItemType Directory -Force


"C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" edit user admin -password Password123! -auth admin:Password123!
"C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" set default-hostname windows2019 -auth admin:Password123!


sysmon64.exe -accepteula -i "C:\Program Files\sysmon\Sysmon.xml"

"C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" restart
