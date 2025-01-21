[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
IEX((new-object net.webclient).downloadstring("https://raw.githubusercontent.com/Cazeho/Purpleteam/refs/heads/main/forward/splunk_config.ps1"));
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\win_outputs_app\local" -ItemType Directory -Force
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\powershell_inputs_app\local" -ItemType Directory -Force
New-Item -Path "C:\Program Files\SplunkUniversalForwarder\etc\apps\sysmon_inputs_app\local" -ItemType Directory -Force
