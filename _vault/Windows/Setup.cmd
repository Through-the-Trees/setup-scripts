@echo off
set "URL=https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/master/windows/setup.ps1"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "iex (Invoke-WebRequest -UseBasicParsing -Uri '%URL%').Content"