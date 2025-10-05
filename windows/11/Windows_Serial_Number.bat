@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { Get-CimInstance -ClassName Win32_BIOS | Select-Object SerialNumber }"
pause