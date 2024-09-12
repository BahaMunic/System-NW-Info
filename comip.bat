@echo off
setlocal enabledelayedexpansion

echo Getting IP address and computer name...

rem Get the computer name
set "ComputerName=%COMPUTERNAME%"

rem Initialize the IP address variable
set "IPAddress="

rem Get the IP address
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4 Address"') do (
    set "IPAddress=%%i"
    rem Remove leading spaces
    set "IPAddress=!IPAddress:~1!"
)

rem Display the results
echo.
echo Computer Name: %ComputerName%
echo IP Address: !IPAddress!
echo.

pause