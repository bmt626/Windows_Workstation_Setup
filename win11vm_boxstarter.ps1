choco install office365proplus -y
choco install ghidra -y
choco install dependencywalker -y
choco install ollydbg -y
choco install cheatengine -y
choco install processhacker -y
choco install regshot -y
choco install dotpeek -y
choco install jadx -y

winget install Google.Chrome --accept-source-agreements --accept-package-agreements
winget install Mozilla.Firefox --accept-source-agreements --accept-package-agreements
winget install 7zip.7zip --accept-source-agreements --accept-package-agreements
winget install Git.Git --accept-source-agreements --accept-package-agreements
winget install VideoLAN.VLC --accept-source-agreements --accept-package-agreements
winget install Microsoft.Sysinternals --accept-source-agreements --accept-package-agreements
winget install Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements
winget install WiresharkFoundation.Wireshark --accept-source-agreements --accept-package-agreements
winget install WinSCP.WinSCP --accept-source-agreements --accept-package-agreements
winget install Rizin.Cutter --accept-source-agreements --accept-package-agreements
winget install horsicq.DIE-engine --accept-source-agreements --accept-package-agreements
winget install icsharpcode.ILSpy --accept-source-agreements --accept-package-agreements
winget install Microsoft.VisualStudio.2022.Community --accept-source-agreements --accept-package-agreements
winget install dnSpyEx.dnSpy --accept-source-agreements --accept-package-agreements
winget install Postman.Postman --accept-source-agreements --accept-package-agreements
winget install EclipseAdoptium.Temurin.21.JDK --accept-source-agreements --accept-package-agreements
winget install PuTTY.PuTTY --accept-source-agreements --accept-package-agreements
winget install Telegram.TelegramDesktop --accept-source-agreements --accept-package-agreements
winget install Python.Python.3.10 --accept-source-agreements --accept-package-agreements

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions

# Description - Script to download the "Latest RRG / Iceman generic build for Proxmark3 devices (non RDV4), for Proxmark3 Easy, RDV1, RDV2, RDV3, etc etc"
# will download to c:\tools and uncompress using 7zget to c:\tools\proxmark

# check for the c:\tools directory and create it if needed
if (-not (Test-Path "C:\Tools")) 
{ 
    New-Item -ItemType Directory -Path "C:\Tools" 
}

# Set toolsdir variable to c:\tools
$toolsdir = "C:\Tools\"

# Follow redirect and get final URL 
$response = Invoke-WebRequest -Uri "https://www.proxmarkbuilds.org/latest/rrg_other" -MaximumRedirection 0 -ErrorAction Ignore

# Extract Location header (where it redirects to)
$redirectUrl = $response.Headers.Location

# Get final filename from URL
$filename = [System.IO.Path]::GetFileName($redirectUrl)

# Set the outfile to c:\tools\$filename
$outfile = Join-Path $toolsdir $filename

# Download file and save with extracted filename
Invoke-WebRequest -Uri $redirectUrl -OutFile $outfile

Write-Host "Downloaded file saved to $toolsdir as $filename"

# Check if 7z is in PATH using Get-Command and if it is not check c:\program files\7-zip
# Then extract the 7z archive to the tools dir \proxmark
$sevenZip = ""

$cmd = Get-Command 7z.exe -ErrorAction SilentlyContinue

if ($cmd) {
    7z x $outfile "-o$toolsdir\proxmark" -y    
} elseif (Test-Path "C:\Program Files\7-Zip\7z.exe") {
    $sevenZip = "C:\Program Files\7-Zip\7z.exe"
    & $sevenZip x $outfile "-o$toolsdir\proxmark" -y
} else {
    Write-Host "❌ 7z.exe not found."
}

# Add proxmark profile to windows terminal
Write-Host "Adding proxmark profile to windows terminal"

$iconDir = Join-Path $toolsdir "Icons"

if (-not (Test-Path $iconDir)) 
{ 
    New-Item -ItemType Directory -Path $iconDir 
}

# Download the icon used for the windows terminal profile
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bmt626/AppIcons/refs/heads/main/Terminal.png" -OutFile (Join-Path $iconDir "Terminal.png")

# Get a new GUID for the profile
$proxmarkGUID = [guid]::NewGuid().ToString()

# Path to Windows Terminal settings
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Load current settings
$json = Get-Content $settingsPath -Raw | ConvertFrom-Json

# Define new profile
$newProfile = @{
    name = "Proxmark3"
    commandline = "cmd.exe /k C:\Tools\Proxmark\pm3.bat"
    startingDirectory = "C:\Tools\Proxmark"
    icon = "C:\\Tools\\Icons\\Terminal.png"
    guid = "{$proxmarkGUID}"
    hidden = $false
}

# Append profile to list
$json.profiles.list += $newProfile

# Save updated settings
$json | ConvertTo-Json -Depth 5 | Set-Content $settingsPath

Write-Host "✅ 'Proxmark3' profile added with custom icon."

# Get jadx icon
$iconDir = Join-Path $toolsdir "Icons"

if (-not (Test-Path $iconDir)) 
{ 
    New-Item -ItemType Directory -Path $iconDir 
}

# Download the icon used for the windows terminal profile
Invoke-WebRequest -Uri "https://github.com/skylot/jadx/raw/refs/heads/master/jadx-gui/src/main/resources/logos/jadx-logo.ico" -OutFile (Join-Path $iconDir "jadx-logo.ico")

# Add dnSpy to desktop
# $WScriptShell = New-Object -ComObject WScript.Shell
# $shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\dnSpy.lnk")
# $shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\dnspy\tools\dnSpy.exe"
# $shortcut.Save()

# Add procmon64 to desktop
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\Procmon64.lnk")
$shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\sysinternals\tools\Procmon64.exe"
$shortcut.Save()

# Add procmon to desktop
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\Procmon.lnk")
$shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\sysinternals\tools\Procmon.exe"
$shortcut.Save()

# Add ollydbg to desktop
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\ollydbg.lnk")
$shortcut.TargetPath = "C:\Program Files (x86)\OllyDbg\OLLYDBG.EXE"
$shortcut.Save()

# Add dependency walker to desktop
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\Dependency Walker.lnk")
$shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\dependencywalker\content\depends.exe"
$shortcut.Save()

# Add ilspy to desktop
# $WScriptShell = New-Object -ComObject WScript.Shell
# $shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\ILSpy.lnk")
# $shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\ilspy\tools\ILSpy.exe"
# $shortcut.Save()

# Add ghidra to desktop with icon
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\Ghidra.lnk")
$shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\ghidra\tools\ghidra_11.3.2_PUBLIC\ghidraRun.bat"
$shortcut.IconLocation = "C:\ProgramData\chocolatey\lib\ghidra\tools\ghidra_11.3.2_PUBLIC\support\ghidra.ico,0"
$shortcut.Save()

# Add jadx to desktop
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\Jadx.lnk")
$shortcut.IconLocation = "C:\\Tools\\Icons\\jadx-logo.ico,0"
$shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\jadx\tools\bin\jadx-gui.bat"
$shortcut.Save()

# Add Detect It Easy to desktop
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut("$([Environment]::GetFolderPath("Desktop"))\die.lnk")
$shortcut.IconLocation = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\die.exe"
$shortcut.TargetPath = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\die.exe"
$shortcut.Save() # TODO: not pulling icon need to fix

# Create Powershell profile for user if it doesnt exist
    if (!(Test-Path -Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force
    }

# Add get-ipinfo function to profile
@'
function Get-IpInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$Ip = 'what-is-my-ip'
    )
    Invoke-RestMethod "https://ipinfo.io/$Ip"
}
'@ | out-file $PROFILE -Encoding Ascii -Append

# add convert file to and from b64 to profile
@' 
function ConvertFrom-Base64 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$InputPath,

        [Parameter(Mandatory, Position=1)]
        [string]$OutputPath
    )

    try {
        certutil.exe -decode $InputPath $OutputPath
    }
    catch {
        Write-Error "Error decoding '$InputPath' → '$OutputPath': $_"
    }
} 

function ConvertTo-Base64 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$InputPath,

        [Parameter(Mandatory, Position=1)]
        [string]$OutputPath
    )

    try {
        certutil.exe -encode $InputPath $OutputPath
    }
    catch {
        Write-Error "Error decoding '$InputPath' → '$OutputPath': $_"
    }
}
'@ | out-file $PROFILE -Encoding Ascii -Append
