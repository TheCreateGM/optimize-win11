@echo off
:: ============================================================================
:: Batch Script to Fix Common Network Issues, Optimize Windows OS,
:: and Attempt Fixes for Common Black Screen Issues.
:: Version: 1.2
:: IMPORTANT: Run this script as an Administrator!
:: ============================================================================
title Network, OS, and Black Screen Fix/Optimize Tool

:: Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrator privileges confirmed. Continuing...
) else (
    echo ERROR: This script requires Administrator privileges.
    echo Please right-click the script and select 'Run as administrator'.
    echo.
    pause
    exit /b 1
)

cls
echo ============================================================================
echo =      NETWORK, OS, AND BLACK SCREEN FIX / OPTIMIZE TOOL               =
echo ============================================================================
echo This script will attempt to:
echo 1. Reset network configurations (IP, DNS, Winsock, TCP/IP).
echo 2. Optionally reset the Windows Firewall to defaults.
echo 3. Repair Windows system files and component store (DISM, SFC).
echo 4. Clean temporary files and optimize disk drives (Defrag/TRIM).
echo 5. Address common software causes of Black Screen issues:
echo    - Disable Fast Startup.
echo    - Schedule Check Disk (chkdsk) for C: on next reboot.
echo    - Optionally clear the display configuration cache.
echo    - Attempt to restart the Windows Explorer shell.
echo.
echo WARNING: MANY steps require a system RESTART afterwards to complete.
echo WARNING: Resetting Firewall or Display Cache removes custom settings.
echo WARNING: Check Disk runs before Windows loads on reboot and can take time.
echo.
pause
cls

:: ============================================================================
echo SECTION 1: NETWORK FIXES
:: ============================================================================
echo.
echo [INFO] Flushing DNS Resolver Cache...
ipconfig /flushdns
echo.

echo [INFO] Releasing current IP configuration...
ipconfig /release
ipconfig /release6 >nul 2>&1
echo.

echo [INFO] Renewing IP configuration...
ipconfig /renew
ipconfig /renew6 >nul 2>&1
echo.

echo [INFO] Resetting Winsock Catalog... (Restart Recommended Later)
netsh winsock reset
echo.

echo [INFO] Resetting TCP/IP Stack... (Restart Required Later)
netsh int ip reset
echo.

:FIREWALL_RESET_PROMPT
echo [ACTION REQUIRED] Reset Windows Firewall to Defaults?
echo WARNING: This will remove ALL custom firewall rules.
set /p ResetFirewall="Type 'YES' to reset, or 'NO' to skip: "
echo.

if /i "%ResetFirewall%"=="YES" (
    echo [INFO] Resetting Windows Firewall...
    netsh advfirewall reset
    echo [INFO] Firewall reset to defaults.
) else if /i "%ResetFirewall%"=="NO" (
    echo [INFO] Skipping Firewall reset.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto FIREWALL_RESET_PROMPT
)
echo.
echo [INFO] Network fixes applied. A restart is recommended later.
echo.
pause
cls

:: ============================================================================
echo SECTION 2: WINDOWS SYSTEM FILE & DISK HEALTH
:: ============================================================================
echo.
echo [INFO] Starting Deployment Image Servicing and Management (DISM)...
echo [INFO] This may take a while. Please wait...
echo [INFO] Stage 1/3: Checking component store health...
DISM /Online /Cleanup-Image /CheckHealth
echo [INFO] Stage 2/3: Scanning component store health...
DISM /Online /Cleanup-Image /ScanHealth
echo [INFO] Stage 3/3: Attempting to repair component store (if needed)...
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo [INFO] DISM operations completed.
echo.
pause
echo.

echo [INFO] Starting System File Checker (SFC)...
echo [INFO] This will scan and attempt to repair protected system files.
echo [INFO] This may take a significant amount of time. Please wait...
sfc /scannow
echo.
echo [INFO] SFC scan completed. Check the output above for results.
echo.
pause
echo.

echo [INFO] Scheduling Check Disk for the System Drive (C:) on next reboot...
echo        (This scans for and attempts to fix file system errors)
echo        IMPORTANT: The scan runs *before* Windows loads on the *next* restart.
echo        It can take a long time. Do NOT turn off your PC during the scan.
chkdsk C: /f /r /x /scan > nul 2>&1  :: Attempt quick online scan first (less disruptive)
fsutil dirty set C:
echo [INFO] Check Disk (thorough version) scheduled for C: on the next restart.
echo.
pause
cls

:: ============================================================================
echo SECTION 3: OS OPTIMIZATION & BLACK SCREEN FIX ATTEMPTS
:: ============================================================================
echo.
echo [INFO] Disabling Fast Startup (Helps prevent some boot/resume issues)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f > nul 2>&1
echo [INFO] Fast Startup disabled. Change takes effect after restart.
echo.

:CLEAR_DISPLAY_CACHE_PROMPT
echo [ACTION REQUIRED] Clear Display Configuration Cache from Registry?
echo WARNING: This forces Windows to redetect monitors on next boot.
echo          It *might* help with certain black/blank screen issues after updates/driver changes.
echo          It involves deleting registry keys. Proceed with caution.
set /p ClearCache="Type 'YES' to clear, or 'NO' to skip: "
echo.

if /i "%ClearCache%"=="YES" (
    echo [INFO] Clearing Display Configuration registry keys...
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration" /f > nul 2>&1
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity" /f > nul 2>&1
    echo [INFO] Display configuration registry keys deleted (if they existed). Requires restart.
) else if /i "%ClearCache%"=="NO" (
    echo [INFO] Skipping Display Cache clear.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto CLEAR_DISPLAY_CACHE_PROMPT
)
echo.
pause
echo.

echo [INFO] Attempting to restart Windows Explorer (Shell)...
echo        (Useful if you see a black screen *after* logging in, maybe with a cursor)
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak > nul
start explorer.exe
echo [INFO] Windows Explorer restart command issued. May take a moment to reappear.
echo.
pause
echo.

echo [INFO] Cleaning User and System Temporary Files...
del /q /f /s %TEMP%\*.* >nul 2>&1
del /q /f /s %SystemRoot%\Temp\*.* >nul 2>&1
rmdir /s /q %TEMP% >nul 2>&1
mkdir %TEMP% >nul 2>&1
rmdir /s /q %SystemRoot%\Temp >nul 2>&1
mkdir %SystemRoot%\Temp >nul 2>&1
echo [INFO] Temporary files cleaned.
echo.

echo [INFO] Optimizing System Drive (typically C:)...
echo [INFO] This performs Defrag on HDDs or TRIM on SSDs. May take time.
defrag C: /O
echo.
echo [INFO] Drive optimization command issued.
echo.
pause
cls

:: ============================================================================
echo SECTION 4: FINAL CHECKS AND COMPLETION
:: ============================================================================
echo.
echo [INFO] Performing final connectivity tests...
echo.
echo Pinging Google DNS (8.8.8.8)...
ping 8.8.8.8 -n 4
echo.
echo Pinging Google.com (testing DNS resolution)...
ping google.com -n 4
echo.

echo ============================================================================
echo =                           SCRIPT COMPLETE                              =
echo ============================================================================
echo.
echo Network, OS optimization, and black screen fix tasks have been executed.
echo Check the output above for any specific errors reported by commands.
echo.
echo *** CRITICAL REMINDER ***
echo A system RESTART is NOW STRONGLY RECOMMENDED!
echo Many changes (Network Resets, Fast Startup, Check Disk scheduling,
echo Display Cache) require a restart to take effect.
echo The Check Disk scan will run automatically on C: during the next boot.
echo.
echo If you still experience issues after restarting, further troubleshooting
echo (e.g., checking drivers in Safe Mode, hardware diagnostics) may be needed.
echo.
pause
exit /b 0