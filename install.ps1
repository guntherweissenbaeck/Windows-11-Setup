# ---------------------------------------------------------------------------
# Description: This script installs software and configures Windows settings.
#  Author: Gunther Weißenbäck
#    Date: 2025-03-23
#    Version: 1.0
#    Usage: .\install.ps1
#    URL: https://github.com/guntherweissenbaeck/Windows-11-Setup
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Unset Execution Policy
# ---------------------------------------------------------------------------
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

# ---------------------------------------------------------------------------
# Set Variables
# ---------------------------------------------------------------------------
$Username = "TestUser"
$Password = "TestPassword"
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$UserDescription = "Test User"
$UserFullName = "Test User"
$ComputerName = "TestComputer"

# ---------------------------------------------------------------------------
# Setze den Computername auf TestComputer
# ---------------------------------------------------------------------------
Rename-Computer -NewName $ComputerName

# ---------------------------------------------------------------------------
# C:\Temp erstellen und Umgebungsvariable TEMP auf C:\Temp setzen
# ---------------------------------------------------------------------------
New-Item -Path "C:\Temp" -ItemType "directory"

# Verschiebe die Umgebungsvariable
[Environment]::SetEnvironmentVariable("TEMP", "C:\Temp", "Machine")

# Ausgabe der Umgebungsvariable
[Environment]::GetEnvironmentVariable("TEMP", "Machine")
[Environment]::GetEnvironmentVariable("TEMP", "User")
[Environment]::GetEnvironmentVariable("TEMP", "Process")

# ---------------------------------------------------------------------------
# Lege einen neuen Benutzer an mit Name und Passwort
# ---------------------------------------------------------------------------
New-LocalUser -Name $Username -Password $SecurePassword -FullName $UserFullName -Description $UserDescription

# Füge den Benutzer zur Gruppe Administratoren hinzu
Add-LocalGroupMember -Group "Administrators" -Member $Username

# Setze den Standardbenutzer auf TestUser
Set-DefaultUser -Name $Username

# ---------------------------------------------------------------------------
# Lade und installiere die neuesten Windows-Updates
# ---------------------------------------------------------------------------
Install-WindowsUpdate -AcceptAll -AutoReboot

# Installiere das neueste Windows-Update
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

# ---------------------------------------------------------------------------
# Installiere Chocolatey
# ---------------------------------------------------------------------------
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Benutze Chocolatey um Software zu installieren
choco install 7zip -y           # Installiere 7-Zip
choco install firefox -y        # Installiere Mozilla Firefox
choco install sysinternals -y   # Installiere Sysinternals
choco install keepass -y        # Installiere KeePass
# choco install notepadplusplus -y # Installiere Notepad++
# choco install vlc -y            # Installiere VLC Media Player
# choco install adobereader -y    # Installiere Adobe Reader
# choco install flashplayerplugin -y # Installiere Adobe Flash Player
# choco install javaruntime -y    # Installiere Java Runtime Environment
# choco install dotnet3.5 -y      # Installiere .NET Framework 3.5
# choco install dotnet4.8 -y      # Installiere .NET Framework 4.8
# choco install vscode -y         # Installiere Visual Studio Code
# choco install git -y            # Installiere Git

# ---------------------------------------------------------------------------
# Setze die Zeitzone auf Berlin
# ---------------------------------------------------------------------------
Set-TimeZone -Id "W. Europe Standard Time"

# ---------------------------------------------------------------------------
# Setze den Standort auf Deutschland
# ---------------------------------------------------------------------------
Set-WinUILanguageOverride -Language de-DE

# Setze die Tastatur auf Deutsch
Set-WinUserLanguageList -LanguageList de-DE -Force

# Setze die Anzeigesprache auf Deutsch
Set-WinUILanguageOverride -Language de-DE

# Setze die Region auf Deutschland
Set-WinSystemLocale de-DE

# Setze die Formatierung auf Deutsch
Set-WinHomeLocation de-DE

# ---------------------------------------------------------------------------
# Setze den Hintergrund auf Schwarz
# ---------------------------------------------------------------------------
Set-ItemProperty -Path 'HKCU:\Console' -Name 'ColorTable00' -Value 0

# Setze den Hintergrund auf Dunkelgrau
# Set-ItemProperty -Path 'HKCU:\Console' -Name 'ColorTable08' -Value 8

# ---------------------------------------------------------------------------
# Show all devices in Device Manager
# ---------------------------------------------------------------------------
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy' -Name 'UpgradedSystem' -Value 1

# ---------------------------------------------------------------------------
# Setze den Bildschirmschoner auf 15 Minuten
# ---------------------------------------------------------------------------
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'ScreenSaveTimeOut' -Value 900

# ---------------------------------------------------------------------------
# Setze kein Soundschema
# ---------------------------------------------------------------------------
Set-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value ''
