# Find drive letter via "$OEM$" folder name
$driveLetter = Get-PSDrive -PSProvider FileSystem | ForEach-Object { if (Test-Path "$($_.Root)\`$OEM$") { $_.Root } } | Select-Object -First 1
$chamber = [System.IO.Path]::Combine($driveLetter, "`$OEM`$", "`$1", "TtT Setup")

echo "Chamber location: $chamber"

echo "Setting up screensaver & power settings..."
# -- Copy images and select photo screensaver
$usbPath = [System.IO.Path]::Combine($chamber, "Saved Pictures")
$computerPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("MyPictures"), "Saved Pictures")

# Create the destination folder if it doesn't exist
if (!(Test-Path -Path $computerPath)) { New-Item -Path $computerPath -ItemType Directory }
# Copy images from USB to computer
Copy-Item -Path "$usbPath\*" -Destination $computerPath -Recurse -Force

# Set power plan to Balanced
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
# Set display timeout for AC power to never
powercfg /change monitor-timeout-ac 0
# Set sleep timeout for AC power to never
powercfg /change standby-timeout-ac 0
# Set disk timeout for AC power to never
powercfg /change disk-timeout-ac 0

# Set screensaver to Photos
$photosScreensaver = "C:\Windows\System32\PhotoScreensaver.scr"

# Registry keys for screensaver settings
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "SCRNSAVE.EXE" -Value $photosScreensaver
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScresenSaveActive" -Value "1"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaverIsSecure" -Value "0"

echo "Disabling autorun..."
# Disable autorun popups

# Disable AutoPlay
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Value 1 -Type DWord -Force

echo "Enabling file extensions..."
# -- Show file extensions
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f

echo "Setting time zone..."
# -- Set time zone
Set-TimeZone -Name "Eastern Standard Time"

echo "Installing software..."
# -- Install Visual C++ prerequisite for Libre Office
Start-Process -FilePath "$chamber\Software\VCPP.exe" -ArgumentList "/quiet /norestart" -Wait
# -- Install software (VLC, Libre Office, Firefox, Chrome via Ninite installer)
Start-Process -FilePath "$chamber\Software\Ninite.exe" -Wait
echo "Configuring software..."
# -- Replace LibreOffice configuration file for default file extensions
$libreConfigDir = "$env:APPDATA\LibreOffice\4\user\"
if (-not (Test-Path $libreConfigDir)) { New-Item -ItemType Directory -Path $libreConfigDir }
Copy-Item -Path "$chamber\registrymodifications.xcu" -Destination $libreConfigDir -Force

# Start the screensaver immediately (optional)
(Start-Process -FilePath $photosScreensaver)