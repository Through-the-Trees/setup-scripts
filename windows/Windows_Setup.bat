@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\$OEM$\$1\Windows_Setup.ps1"

pause