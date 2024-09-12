@echo off
title Network Troubleshooting Tool
color 0A

:menu
cls
echo ================================
echo      Network Troubleshooting
echo ================================
echo 1. Ping Specific IP
echo 2. Get MAC Address from Specific IP
echo 3. Check Network Configuration
echo 4. DNS Lookup
echo 5. Traceroute with -d Option
echo 6. Check if Port is Open
echo 7. Exit
echo ================================
set /p choice="Select an option (1-7): "

if "%choice%"=="1" goto ping_specific
if "%choice%"=="2" goto mac_from_ip
if "%choice%"=="3" goto ipconfig
if "%choice%"=="4" goto nslookup
if "%choice%"=="5" goto tracert_d
if "%choice%"=="6" goto port_check
if "%choice%"=="7" exit

goto menu

:ping_specific
cls
echo Ping Specific IP
set /p ip="Enter IP address to ping: "
ping -n 1 -w 100 %ip% | find "Reply from" > nul
if errorlevel 1 (
    echo %ip% is offline
) else (
    echo %ip% is online
)
pause
goto menu

:mac_from_ip
cls
echo Get MAC Address from Specific IP
set /p ip="Enter IP address to get MAC: "
arp -a %ip%
pause
goto menu

:ipconfig
cls
echo Network Configuration
ipconfig /all
pause
goto menu

:nslookup
cls
echo DNS Lookup
set /p hostname="Enter hostname: "
nslookup %hostname%
pause
goto menu

:tracert_d
cls
echo Traceroute with -d Option
set /p target="Enter IP address or hostname: "
tracert -d %target%
pause
goto menu
:port_check
cls
echo Check if Port is Open
set /p ip="Enter IP address: "
set /p port="Enter port number: "
echo Checking if port %port% on %ip% ...

rem Use PowerShell to check if the port is open with error handling
powershell -Command "try { $tcp = New-Object System.Net.Sockets.TcpClient; $tcp.Connect('%ip%', %port%); $tcp.Close(); Write-Output 'True' } catch { Write-Output 'False' }" > temp_output.txt

set /p result=<temp_output.txt

if "%result%"=="True" (
    echo Port %port% on %ip% is open.
) else (
    echo Port %port% on %ip% is closed or unreachable.
)

del temp_output.txt
echo Check complete. Returning to menu...
pause
goto menu