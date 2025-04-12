@echo off
:: ============================================================================
:: Batch Script to Fix Common Network Issues and Optimize Windows OS
:: Version: 1.1
:: IMPORTANT: Run this script as an Administrator!
:: ============================================================================
title Network and OS Fix/Optimize Tool

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
echo =             NETWORK AND OS FIX / OPTIMIZE TOOL                       =
echo ============================================================================
echo This script will attempt to:
echo 1. Reset network configurations (IP, DNS, Winsock, TCP/IP).
echo 2. Optionally reset the Windows Firewall to defaults.
echo 3. Repair Windows system files and the component store (DISM, SFC).
echo 4. Clean temporary files.
echo 5. Optimize disk drives (Defrag/TRIM).
echo.
echo WARNING: Some steps require a system RESTART afterwards to complete.
echo WARNING: Resetting the Firewall will REMOVE custom rules.
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

echo [INFO] Resetting Winsock Catalog... (Restart Recommended)
netsh winsock reset
echo.

echo [INFO] Resetting TCP/IP Stack... (Restart Required)
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
echo SECTION 2: WINDOWS OS OPTIMIZATION
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

echo [INFO] Cleaning User and System Temporary Files...
del /q /f /s %TEMP%\*.* >nul 2>&1
del /q /f /s %SystemRoot%\Temp\*.* >nul 2>&1
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
echo SECTION 3: FINAL CHECKS AND COMPLETION
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
echo Network and OS optimization tasks have been executed.
echo.
echo *** IMPORTANT RECOMMENDATION ***
echo A system RESTART is highly recommended to ensure all changes,
echo especially the network stack resets (Winsock, TCP/IP),
echo take full effect.
echo.
echo Please check the output above for any specific errors reported by commands.
echo.
pause
exit /b 0
