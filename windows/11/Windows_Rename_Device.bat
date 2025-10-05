@echo off
set /p "asset=Asset Tag: "
echo Changing name to TtT-%asset%
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { Rename-Computer -NewName TtT-"%asset%" }"
pause