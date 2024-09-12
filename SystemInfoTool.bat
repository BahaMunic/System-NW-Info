@echo off
mode con: cols=120 lines=30
title System Information Tool
color 0B

:menu
cls
echo ================================
echo      System Information Tool
echo ================================
echo 1. System Information (systeminfo)
echo 2. Search Running User Processes (tasklist)
echo 3. Terminate Process (taskkill)
echo 4. Search Files in a Directory
echo 5. WMIC Information
echo 6. Exit
echo ================================
set /p choice="Select an option (1-6): "

if "%choice%"=="1" goto systeminfo
if "%choice%"=="2" goto tasklist
if "%choice%"=="3" goto taskkill
if "%choice%"=="4" goto search_in_directory
if "%choice%"=="5" goto wmic
if "%choice%"=="6" exit

goto menu

:systeminfo
cls
echo ================================
echo      System Information
echo ================================
systeminfo | more
echo ================================
pause
goto menu

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
goto menu

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
goto menu

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
goto menu

:wmic
cls
echo ================================
echo      WMIC Information
echo ================================
echo 1. CPU Information
echo 2. Disk Drives
echo 3. Operating System Information
echo 4. Exit to Menu
set /p wmic_choice="Select an option (1-3): "

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
    goto menu
)
echo ================================
pause
goto menu