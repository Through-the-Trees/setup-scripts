$remote = "https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/master"

echo "Setting up screensaver & power settings..."
# Download pictures for screensaver
$saved_pictures = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("MyPictures"), "Saved Pictures")
$tmp = New-TemporaryFile | Rename-Item -NewName { $_ -replace 'tmp$', 'zip' } –PassThru
Invoke-WebRequest -OutFile $tmp "$remote/windows/screensaver-pictures.zip"
# Create the destination folder if it doesn't exist
if (!(Test-Path -Path $saved_pictures)) { New-Item -Path $saved_pictures -ItemType Directory }
$tmp | Expand-Archive -DestinationPath $saved_pictures -Force
$tmp | Remove-Item
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

echo "Setting time zone..."
Set-TimeZone -Name "Eastern Standard Time"

echo "Installing software..."
# -- (VLC, Libre Office, Firefox, Chrome via Ninite installer)
$tmp = New-TemporaryFile | Rename-Item -NewName { $_ -replace 'tmp$', 'exe' } –PassThru
Invoke-WebRequest -OutFile $tmp "$remote/windows/Ninite.exe"
Start-Process -FilePath $tmp -Wait
$tmp | Remove-Item

echo "Configuring software..."
# -- Replace LibreOffice configuration file for default file extensions (.docx, .pptx, .xlsx)
$libre_config_dir = "$env:APPDATA/LibreOffice/4/user/registrymodifications.xcu"
if (-not (Test-Path $libre_config_dir)) { New-Item -ItemType Directory -Path $libre_config_dir }
Invoke-WebRequest -OutFile $libre_config_dir "$remote/libreoffice-config/registrymodifications.xcu"

# Start the screensaver to signal end of script
(Start-Process -FilePath $photos_screensaver)