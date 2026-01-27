# if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
#     Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
#     Exit
# }

$remote = "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/main"

echo "Checking Windows 11 compatibility..."
$tmp = Join-Path $env:TEMP "$([Guid]::NewGuid()).ps1"
Invoke-WebRequest "https://aka.ms/HWReadinessScript" -OutFile $tmp
Unblock-File -Path $tmp
$hw_info = (& $tmp) | Out-String | ConvertFrom-Json
# Create WshShell object for popup window
$wshell = New-Object -ComObject Wscript.Shell 
if ($hw_info.returnResult -eq "CAPABLE") {
    echo "This system meets Microsoft's minimum requirements for Windows 11."
}
else {
    $hw_failure_log = $hw_info.logging.Replace(';', "`n`n")
    $wshell.Popup("This system does not meet Microsoft's minimum requirements for Windows 11!`n`n"+$hw_failure_log,0,"Not Windows 11 Compatible!",0x0)
}

echo "Setting up screensaver & power settings..."
# Download pictures for screensaver
$tmp = Join-Path $env:TEMP "$([Guid]::NewGuid()).zip"
Invoke-WebRequest -OutFile $tmp "$remote/windows/screensaver-pictures.zip"
Unblock-File -Path $tmp
# Create the destination folder if it doesn't exist
$saved_pictures = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("MyPictures"), "Saved Pictures")
if (!(Test-Path -Path $saved_pictures)) { New-Item -Path $saved_pictures -ItemType Directory }
Expand-Archive -Path $tmp -DestinationPath $saved_pictures -Force
Remove-Item $tmp
# Set screensaver to Photos
$photos_screensaver = "C:/Windows/System32/PhotoScreensaver.scr"
Set-ItemProperty -Path "HKCU:/Control Panel/Desktop" -Name "SCRNSAVE.EXE" -Value $photos_screensaver
Set-ItemProperty -Path "HKCU:/Control Panel/Desktop" -Name "ScresenSaveActive" -Value "1"
Set-ItemProperty -Path "HKCU:/Control Panel/Desktop" -Name "ScreenSaverIsSecure" -Value "0"
# Set power plan to Balanced
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
# Set display timeout for AC power to never
powercfg /change monitor-timeout-ac 0
# Set sleep timeout for AC power to never
powercfg /change standby-timeout-ac 0
# Set disk timeout for AC power to never
powercfg /change disk-timeout-ac 0

echo "Disabling autorun..."
Set-ItemProperty -Path "HKCU:/Software/Microsoft/Windows/CurrentVersion/Explorer/AutoplayHandlers" -Name "DisableAutoplay" -Value 1 -Type DWord -Force

echo "Enabling file extensions..."
Set-ItemProperty -Path "HKCU:/Software/Microsoft/Windows/CurrentVersion/Explorer/Advanced" -Name "HideFileExt" -Value 0

echo "Disabling Edge First Run Experience"
if (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Edge")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Edge" -Force | Out-Null}
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Edge" "HideFirstRunExperience" 1 -Force

echo "Setting time zone..."
Set-TimeZone -Name "Eastern Standard Time"

echo "Installing software..."
# -- (VLC, Libre Office, Firefox, Chrome via Ninite installer)
$tmp = Join-Path $env:TEMP "$([Guid]::NewGuid()).exe"
Invoke-WebRequest -OutFile $tmp "$remote/windows/Ninite.exe"
Unblock-File -Path $tmp
$installer = Start-Process -FilePath $tmp -WindowStyle Normal -PassThru
Start-Sleep -Seconds 3
(New-Object -Com WScript.Shell).AppActivate($installer.Id)
$installer | Wait-Process
Remove-Item $tmp

echo "Configuring software..."
# -- Replace LibreOffice configuration file for default file extensions (.docx, .pptx, .xlsx)
$libre_config_dir = "$env:APPDATA/LibreOffice/4/user"
if (-not (Test-Path $libre_config_dir)) { New-Item -ItemType Directory -Path $libre_config_dir }
Invoke-WebRequest -OutFile "$libre_config_dir/registrymodifications.xcu" "$remote/libreoffice-config/registrymodifications.xcu"

# Start the screensaver to signal end of script
(Start-Process -FilePath $photos_screensaver)