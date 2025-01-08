#https://github.com/safebuffer/vulnerable-AD

# Variables
$ComputerName = "medicare"
$DomainNetbiosName = "MEDICARE"
$DomainFQDN = "medicare.local"
$LogPath = "C:\Logs\Install-ADDS.log"
$SafeModePassword = (ConvertTo-SecureString "admin123;" -AsPlainText -Force) # Set a secure password for DSRM (Directory Services Restore Mode)
$LocalAdminPassword = "admin123;"


# Create log directory
if (-Not (Test-Path -Path "C:\Logs")) {
    mkdir C:\Logs
    Write-Host "Log directory created at C:\Logs"
} else {
    Write-Host "Log directory already exists."
}


# Set a strong password for the local Administrator account
Write-Host "Setting a strong password for the local Administrator account..."
$AdminAccount = Get-LocalUser -Name "Administrator"
if ($AdminAccount.Enabled -eq $false) {
    Enable-LocalUser -Name "Administrator"
    Write-Host "Enabled the local Administrator account."
}

# Set the password for the Administrator account
$SecurePassword = ConvertTo-SecureString $LocalAdminPassword -AsPlainText -Force
Set-LocalUser -Name "Administrator" -Password $SecurePassword
Write-Host "Password for the local Administrator account has been set."

# Install AD DS and Management Tools
Write-Host "Installing Active Directory Domain Services and management tools..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Write-Host "AD DS installation complete."

# Import AD DS Deployment module
Write-Host "Importing AD DS Deployment module..."
Import-Module ADDSDeployment

# Configure AD DS
Write-Host "Configuring Active Directory Domain Services..."
try {
    Install-ADDSForest -DomainName $DomainFQDN -DomainNetbiosName $DomainNetbiosName -SafeModeAdministratorPassword $SafeModePassword -InstallDNS -Force -NoRebootOnCompletion

    Write-Host "Active Directory Domain Services configuration is complete."
    Write-Host "A reboot is required to finalize the configuration."

} catch {
    Write-Error "Failed to configure Active Directory Domain Services: $_"
    exit 1
}

# Reboot the machine


# AD LDS


# .NET framework

DISM /online /enable-feature /featurename:NetFx3 /all


# Define variables
$SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$SysmonZipPath = "C:\Program Files\Sysmon.zip"
$SysmonExtractPath = "C:\Program Files\sysmon"
$SysmonExePath = "$SysmonExtractPath\sysmon.exe"


$SplunkForwarderUrl = "https://download.splunk.com/products/universalforwarder/releases/9.4.0/windows/splunkforwarder-9.4.0-6b4ebe426ca6-windows-x64.msi"
$SplunkForwarderPath = "C:\Program Files\splunkforwarder-9.4.0-6b4ebe426ca6-windows-x64.msi"


$hmailUrl = "https://www.hmailserver.com/files/hMailServer-5.6.8-B2494.exe"
$hmailPath = "C:\Program Files\hMailServer-5.6.8-B2494.exe"

$powershellUrl = "https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/PowerShell-7.4.6-win-x64.msi"
$powershellPath = "C:\Program Files\PowerShell-7.4.6-win-x64.msi"

# Function to check if wget is installed
function Check-Wget {
    $wgetPath = Get-Command wget -ErrorAction SilentlyContinue
    if (-Not $wgetPath) {
        Write-Error "wget is not installed or not available in the PATH. Please install wget to proceed."
        exit 1
    }
}

# Check if Sysmon is already downloaded
if (-Not (Test-Path -Path $SysmonZipPath)) {
    Write-Host "Downloading Sysmon..."
    try {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $SysmonUrl -OutFile $SysmonZipPath -TimeoutSec 60
        Write-Host "Sysmon downloaded successfully."
    } catch {
        Write-Error "Failed to download Sysmon: $_"
        exit 1
    }
} else {
    Write-Host "Sysmon.zip already exists at $SysmonZipPath."
}

# Check if Sysmon is already unzipped
if (-Not (Test-Path -Path $SysmonExePath)) {
    Write-Host "Unzipping Sysmon..."
    try {
        # Ensure the destination folder exists
        if (-Not (Test-Path -Path $SysmonExtractPath)) {
            New-Item -ItemType Directory -Path $SysmonExtractPath | Out-Null
        }

        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($SysmonZipPath, $SysmonExtractPath)
        Write-Host "Sysmon unzipped successfully."
    } catch {
        Write-Error "Failed to unzip Sysmon: $_"
        exit 1
    }
} else {
    Write-Host "Sysmon is already unzipped at $SysmonExtractPath."
}


# Download Splunk Forwarder using wget
if (-Not (Test-Path -Path $SplunkForwarderPath)) {
    Write-Host "Downloading Splunk Forwarder..."
    try {
        Check-Wget
        & wget -O $SplunkForwarderPath $SplunkForwarderUrl
        Write-Host "Splunk Forwarder downloaded successfully."
    } catch {
        Write-Error "Failed to download Splunk Forwarder: $_"
        exit 1
    }
} else {
    Write-Host "Splunk Forwarder MSI already exists at $SplunkForwarderPath."
}

# you need to enable .Net framework in role in windows server
# Download  hmail using wget
if (-Not (Test-Path -Path $hmailPath)) {
    Write-Host "Downloading Hmail..."
    try {
        Check-Wget
        & wget -O $hmailPath $hmailUrl
        Write-Host "Hmail downloaded successfully."
    } catch {
        Write-Error "Failed to download Hmailserver: $_"
        exit 1
    }
} else {
    Write-Host "Hmail already exists at $hmailPath."
}


# Download powershell 7

if (-Not (Test-Path -Path $powershellPath)) {
    Write-Host "Downloading Pw7..."
    try {
        Check-Wget
        & wget -O $powershellPath $powershellUrl
        Write-Host "Hmail downloaded successfully."
    } catch {
        Write-Error "Failed to download Pw7: $_"
        exit 1
    }
} else {
    Write-Host "Pw7 already exists at $powershellPath."
}


# install OPENBAS agent (need powershell 7 => pwsh.exe)
# Check for PowerShell 7 executable
$pwshPath = "C:\Program Files\PowerShell\7\pwsh.exe"

if (Test-Path $pwshPath) {
    # Run the command using PowerShell 7
    & $pwshPath -Command 'iex (iwr "http://192.168.10.50:8080/api/agent/installer/openbas/windows/622868ca-f71f-4cd8-afe9-5d6fe981bebe").Content'
} else {
    Write-Host "PowerShell 7 is not installed or the path is incorrect."
}


[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
IEX((new-object net.webclient).downloadstring("https://raw.githubusercontent.com/wazehell/vulnerable-AD/master/vulnad.ps1"));
Invoke-VulnAD -UsersLimit 100 -DomainName $DomainFQDN

# Reboot the machine
Write-Host "Rebooting the machine to apply changes..."
Restart-Computer -Force
