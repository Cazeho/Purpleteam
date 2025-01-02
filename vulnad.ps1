[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocoleType]::Tls12
IEX((new-object net.webclient).downloadstring("https://raw.githubusercontent.com/wazehell/vulnerable-AD/master/vulnad.ps1"));
Invoke-VulnAD -UsersLimit 100 -DomainName "DC01.local"
