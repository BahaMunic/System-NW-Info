@echo off
mode con: cols=120 lines=30
title System & Network Information Tool
color 0B

:menu
cls
echo ================================
echo      System Information Tool
echo ================================
echo 1. System 
echo 2. Network 
echo 3. Exit
echo ================================
set /p choice="Select an option (1-3): "

if "%choice%"=="1" goto system_menu
if "%choice%"=="2" goto network_troubleshooting
if "%choice%"=="3" exit

goto menu

:system_menu
cls
echo ================================
echo      System Options
echo ================================
echo 1. Computer Info (IP Address and Computer Name)
echo 2. System Information (systeminfo)
echo 3. Search Running User Processes (tasklist)
echo 4. Terminate Process (taskkill)
echo 5. Search Files in a Directory
echo 6. WMIC Information
echo 7. Return to Main Menu
echo ================================
set /p choice="Select an option (1-7): "

if "%choice%"=="1" goto computer_info
if "%choice%"=="2" goto systeminfo
if "%choice%"=="3" goto tasklist
if "%choice%"=="4" goto taskkill
if "%choice%"=="5" goto search_in_directory
if "%choice%"=="6" goto wmic
if "%choice%"=="7" goto menu

goto system_menu

:computer_info
cls
echo ================================
echo      Computer Info
echo ================================

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
echo ================================
pause
goto system_menu

:systeminfo
cls
echo ================================
echo      System Information
echo ================================
systeminfo | more
echo ================================
pause
goto system_menu

:tasklist
cls
echo ================================
echo      Search Running User Processes
echo ================================
set /p process_name="Enter the process name to search for (e.g., notepad.exe): "
echo Searching for "%process_name%"...
tasklist | findstr /i "%process_name%" | findstr /v "System" | more
if errorlevel 1 (
    echo No matching processes found.
) else (
    echo ================================
    echo Search complete.
)
echo ================================
pause
goto system_menu

:taskkill
cls
echo ================================
echo      Terminate Process
echo ================================
set /p pid="Enter the PID of the process to terminate: "
taskkill /PID %pid% /F
if errorlevel 1 (
    echo Failed to terminate process with PID %pid%. It may not exist.
) else (
    echo Process with PID %pid% terminated successfully.
)
echo ================================
pause
goto system_menu

:search_in_directory
cls
echo ================================
echo      Search Files in a Directory
echo ================================
set /p dir_path="Enter the directory path (e.g., C:\Users\YourUsername): "
set /p file_name="Enter the file name to search for (e.g., *.txt): "
echo Searching for files matching "%file_name%" in "%dir_path%"...
dir "%dir_path%\%file_name%" /s /b | more
if errorlevel 1 (
    echo No matching files found.
) else (
    echo ================================
    echo Search complete.
)
echo ================================
pause
goto system_menu

:wmic
cls
echo ================================
echo      WMIC Information
echo ================================
echo 1. CPU Information
echo 2. Disk Drives
echo 3. Operating System Information
echo 4. Exit to Menu
set /p wmic_choice="Select an option (1-4): "

if "%wmic_choice%"=="1" (
    echo ================================
    echo      CPU Information
    echo ================================
    wmic cpu get name | more
) else if "%wmic_choice%"=="2" (
    echo ================================
    echo      Disk Drives
    echo ================================
    wmic diskdrive get model | more
) else if "%wmic_choice%"=="3" (
    echo ================================
    echo      Operating System Information
    echo ================================
    wmic os get Caption, Version, BuildNumber | more
) else (
    goto system_menu
)
echo ================================
pause
goto system_menu

:network_troubleshooting
cls
title Network Troubleshooting Tool
color 0A

:network_menu
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
echo 7. Return to Main Menu
echo ================================
set /p network_choice="Select an option (1-7): "

if "%network_choice%"=="1" goto ping_specific
if "%network_choice%"=="2" goto mac_from_ip
if "%network_choice%"=="3" goto ipconfig
if "%network_choice%"=="4" goto nslookup
if "%network_choice%"=="5" goto tracert_d
if "%network_choice%"=="6" goto port_check
if "%network_choice%"=="7" goto menu

goto network_menu

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
goto network_menu

:mac_from_ip
cls
echo Get MAC Address from Specific IP
set /p ip="Enter IP address to get MAC: "
arp -a %ip%
pause
goto network_menu

:ipconfig
cls
echo Network Configuration
ipconfig /all
pause
goto network_menu

:nslookup
cls
echo DNS Lookup
set /p hostname="Enter hostname: "
nslookup %hostname%
pause
goto network_menu

:tracert_d
cls
echo Traceroute with -d Option
set /p target="Enter IP address or hostname: "
tracert -d %target%
pause
goto network_menu

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
goto network_menu