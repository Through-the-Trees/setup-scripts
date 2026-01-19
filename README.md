# setup-scripts
Central Repo for remote setup scripts

# Documentation
See [Google Drive](https://drive.google.com/drive/folders/1d_S3faZrwhpUiTw1B-DxLmTf3okOl1hV?usp=sharing) for up-to-date refurbishing documentation

## Windows
### /windows/setup.ps1
- Set up photo screen saver & configure power settings to keep screen on when plugged in for in-store display
- Disable autorun for end user security & to reduce popups when plugging in flash drives
- Show file extensions for end user security
- Set time zone to America/New York ("Eastern Standard Time")
- Pull Ninite executable to install desired software
- Pull /libreoffice-config/registrymodifications.xcu to set LibreOffice default file extensions (.docx, .pptx, .xlsx)

## Linux (Zorin OS)
### /linux/zorin/setup.sh
- Remove Brave browser
- Install Chrome, Firefox, VLC via Flathub
- Pull /libreoffice-config/registrymodifications.xcu to set LibreOffice default file extensions (.docx, .pptx, .xlsx)
- Configure mime defaults for VLC & Firefox
- Configure power settings to keep screen on when plugged in for in-store display
- Apply dash pin configuration
- Change default super key behavior to open Zorin menu
- Ask user if trackpad has bottom set of buttons, if not: enable zone-based right-click

## MacOS
### /macos/setup.sh (Work in Progress)
- Install Firefox, Chrome, LibreOffice via https://macapps.link

# Usage
```bash
curl https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/master/{windows|linux|macos}/{script}.sh | bash
```
