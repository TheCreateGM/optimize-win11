@echo off
:: ============================================================================
:: Windows 11 Basic Optimizer Script
:: Version: 1.1
:: Purpose: Perform common cleanup and optimization tasks.
:: REQUIRES ADMINISTRATOR PRIVILEGES
:: USE AT YOUR OWN RISK! Ensure backups are available.
:: ============================================================================

:: BatchGotAdmin
:-------------------------------------
REM --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting Administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:: Set Title
title Windows 11 Optimizer - Running as Admin

:: Clear Screen
cls

:: ============================================================================
:: START OF SCRIPT
:: ============================================================================
echo ============================================================
echo  Windows 11 Basic Optimizer
echo ============================================================
echo.
echo IMPORTANT: This script will perform several system cleanup
echo and optimization tasks. It requires Administrator rights.
echo.
echo TASKS TO BE PERFORMED:
echo  - Clean Temporary Files (User & System)
echo  - Clear Windows Update Cache
echo  - Clear Prefetch Files
echo  - Flush DNS Cache
echo  - Run System File Checker (SFC)
echo  - Run DISM CheckHealth, ScanHealth, RestoreHealth
echo  - Optimize System Drive (Defrag/TRIM)
echo  - Set Power Plan to High Performance (Optional - See Note Below)
echo.
echo NOTE ON POWER PLAN: High Performance can improve speed but
echo increases power usage (especially on laptops). Balanced is
echo often sufficient. This script sets it to High Performance.
echo You can change it back later in Control Panel -> Power Options.
echo.
echo MAKE SURE YOU HAVE CLOSED IMPORTANT APPLICATIONS.
echo Ensure you have backups of critical data before proceeding.
echo.

:Confirm
set /p "confirm=Do you want to continue? (Y/N): "
if /I not "%confirm%" == "Y" (
    echo Aborted by user.
    goto EndScript
)

echo Starting optimization tasks...
echo.

:: ------------------------------------------------------------
echo [TASK 1/8] Cleaning Temporary Files...
:: ------------------------------------------------------------
echo  - Deleting User Temp Files...
if exist "%TEMP%" rd /s /q "%TEMP%" > nul 2>&1
md "%TEMP%" > nul 2>&1
echo  - Deleting System Temp Files...
if exist "%SystemRoot%\Temp" rd /s /q "%SystemRoot%\Temp" > nul 2>&1
md "%SystemRoot%\Temp" > nul 2>&1
echo Temporary file cleanup attempted.
echo.
pause
:: ------------------------------------------------------------
echo [TASK 2/8] Clearing Windows Update Cache...
:: ------------------------------------------------------------
echo  - Stopping Windows Update Service...
net stop wuauserv > nul 2>&1
net stop bits > nul 2>&1
echo  - Deleting Software Distribution Download folder...
if exist "%SystemRoot%\SoftwareDistribution\Download" rd /s /q "%SystemRoot%\SoftwareDistribution\Download" > nul 2>&1
echo  - Restarting Windows Update Service...
net start wuauserv > nul 2>&1
net start bits > nul 2>&1
echo Windows Update Cache cleared.
echo.
pause
:: ------------------------------------------------------------
echo [TASK 3/8] Clearing Prefetch Files...
:: ------------------------------------------------------------
REM Note: Benefit of clearing prefetch is debated, but it's a common tweak.
echo  - Deleting Prefetch files...
if exist "%SystemRoot%\Prefetch" rd /s /q "%SystemRoot%\Prefetch" > nul 2>&1
md "%SystemRoot%\Prefetch" > nul 2>&1
echo Prefetch files cleared.
echo.
pause
:: ------------------------------------------------------------
echo [TASK 4/8] Flushing DNS Cache...
:: ------------------------------------------------------------
ipconfig /flushdns
echo DNS Cache flushed.
echo.
pause
:: ------------------------------------------------------------
echo [TASK 5/8] Running System File Checker (SFC)...
:: ------------------------------------------------------------
echo This may take some time...
sfc /scannow
echo SFC scan complete. Check output above for issues.
echo.
pause
:: ------------------------------------------------------------
echo [TASK 6/8] Running DISM Commands...
:: ------------------------------------------------------------
echo Checking component store health (CheckHealth)...
DISM /Online /Cleanup-Image /CheckHealth
echo.
echo Scanning component store health (ScanHealth)...
DISM /Online /Cleanup-Image /ScanHealth
echo.
echo Attempting to repair component store (RestoreHealth)...
echo This may take some time and requires an internet connection...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM commands complete. Check output above for issues.
echo.
pause
:: ------------------------------------------------------------
echo [TASK 7/8] Optimizing System Drive (%SystemDrive%)...
:: ------------------------------------------------------------
echo This performs TRIM on SSDs or Defrag on HDDs...
defrag %SystemDrive% /O
echo System drive optimization complete.
echo.
pause
:: ------------------------------------------------------------
echo [TASK 8/8] Setting Power Plan to High Performance...
:: ------------------------------------------------------------
REM GUID for High Performance Plan (Usually the same, but standard)
set HighPerfGUID=8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo Setting active power scheme to High Performance...
powercfg /setactive %HighPerfGUID%
echo Power plan set. You can change this in Control Panel -> Power Options.
echo.

:EndScript
echo ============================================================
echo  Optimization Tasks Attempted
echo ============================================================
echo.
echo Please review the output above for any errors or messages.
echo.
echo *** A RESTART IS RECOMMENDED to ensure all changes take effect cleanly. ***
echo.
pause
exit /b