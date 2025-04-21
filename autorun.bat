@echo off
:: ============================================================================
:: Batch Script for Advanced Windows Troubleshooting, Optimization,
:: Black Screen Fix Attempts, Lightweight Tweaks, and BSOD Guidance.
:: Version: 1.4
:: IMPORTANT: Run this script as an Administrator!
:: ============================================================================
title Advanced Windows Troubleshoot Tool

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
echo =          ADVANCED WINDOWS TROUBLESHOOT / OPTIMIZE TOOL               =
echo ============================================================================
echo This script will attempt to:
echo 1. Reset network configurations.
echo 2. Optionally reset the Windows Firewall.
echo 3. Repair Windows system files and component store (DISM, SFC).
echo 4. Clean temporary files and optimize disk drives.
echo 5. Address common software causes of Black Screen issues.
echo 6. Apply "Lightweight" OS tweaks (Optional Telemetry, Cortana, Search, Sysmain).
echo 7. Provide information and suggest manual steps for troubleshooting BSODs.
echo.
echo WARNING: MANY steps require a system RESTART afterwards to complete.
echo WARNING: Resetting Firewall or Display Cache removes custom settings.
echo WARNING: Check Disk runs before Windows loads on reboot and can take time.
echo WARNING: "Lightweight" tweaks disable Windows features.
echo WARNING: This script DOES NOT automatically fix hardware problems.
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
    reg delete "HKLM\SYSTEM\CurrentSet\Control\GraphicsDrivers\Configuration" /f > nul 2>&1 :: Added CurrentSet just in case
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity" /f > nul 2>&1
    reg delete "HKLM\SYSTEM\CurrentSet\Control\GraphicsDrivers\Connectivity" /f > nul 2>&1 :: Added CurrentSet
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
rmdir /s /q "%TEMP%" >nul 2>&1
mkdir "%TEMP%" >nul 2>&1
rmdir /s /q "%SystemRoot%\Temp" >nul 2>&1
mkdir "%SystemRoot%\Temp" >nul 2>&1
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
echo SECTION 4: LIGHTWEIGHT WINDOWS TWEAKS
:: ============================================================================
echo.
echo [INFO] Applying potential lightweight OS tweaks...
echo.

:DISABLE_TELEMETRY_PROMPT
echo [ACTION REQUIRED] Reduce Windows Telemetry (Data Collection)?
echo          This reduces background data sending to Microsoft.
set /p DisableTelemetry="Type 'YES' to reduce, or 'NO' to skip: "
echo.

if /i "%DisableTelemetry%"=="YES" (
    echo [INFO] Reducing Windows Telemetry...
    :: Set AllowTelemetry to 0 (Disables most data collection)
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > nul 2>&1
    echo [INFO] Telemetry reduced. Requires restart.
) else if /i "%DisableTelemetry%"=="NO" (
    echo [INFO] Skipping Telemetry reduction.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_TELEMETRY_PROMPT
)
echo.

:DISABLE_CORTANA_PROMPT
echo [ACTION REQUIRED] Disable Cortana?
echo          This frees up resources if you don't use the assistant.
set /p DisableCortana="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableCortana%"=="YES" (
    echo [INFO] Disabling Cortana...
    :: Set AllowCortana to 0
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f > nul 2>&1
    echo [INFO] Cortana disabled. Requires restart.
) else if /i "%DisableCortana%"=="NO" (
    echo [INFO] Skipping Cortana disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_CORTANA_PROMPT
)
echo.

:DISABLE_SEARCH_PROMPT
echo [ACTION REQUIRED] Disable Windows Search Indexing Service?
echo WARNING: This SIGNIFICANTLY reduces disk I/O and CPU usage for indexing,
echo          BUT makes Windows Search (Start Menu, File Explorer search) very slow or unusable.
echo          ONLY do this if you understand the trade-off and rarely use Windows Search.
set /p DisableSearch="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableSearch%"=="YES" (
    echo [INFO] Disabling Windows Search service...
    :: Stop and disable the Windows Search service
    sc stop "WSearch" > nul 2>&1
    sc config "WSearch" start=disabled > nul 2>&1
    echo [INFO] Windows Search indexing service disabled. Requires restart.
    echo WARNING: Windows Search functionality will be severely impacted.
) else if /i "%DisableSearch%"=="NO" (
    echo [INFO] Skipping Windows Search disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_SEARCH_PROMPT
)
echo.

:DISABLE_SYSMAIN_PROMPT
echo [ACTION REQUIRED] Disable Superfetch / Sysmain Service?
echo          This service preloads frequently used data.
echo          Disabling *might* help high disk usage on older systems,
echo          but often benefits SSDs. Test if needed.
set /p DisableSysmain="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableSysmain%"=="YES" (
    echo [INFO] Disabling Superfetch / Sysmain service...
    :: Stop and disable the Sysmain service (formerly Superfetch)
    sc stop "Sysmain" > nul 2>&1
    sc config "Sysmain" start=disabled > nul 2>&1
    echo [INFO] Superfetch / Sysmain service disabled. Requires restart.
) else if /i "%DisableSysmain%"=="NO" (
    echo [INFO] Skipping Superfetch / Sysmain disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_SYSMAIN_PROMPT
)
echo.

echo [INFO] Lightweight tweaks section completed.
echo.
pause
cls

:: ============================================================================
echo SECTION 5: BSOD INFORMATION AND MANUAL DIAGNOSTIC STEPS
:: ============================================================================
echo.
echo [INFO] Information and Manual Steps for BSOD Troubleshooting:
echo.
echo This script has run various fixes for common *software* causes of BSODs
echo (corrupted system files, file system errors, potentially unstable settings).
echo However, BSODs are often caused by hardware issues.
echo.
echo Batch scripts CANNOT directly test CPU, RAM, SSD physical health, or PSU.
echo If BSODs persist after restarting, consider these MANUAL steps:
echo.
echo 1. Check Event Viewer:
echo    - Press Windows Key + R, type "eventvwr.msc" and press Enter.
echo    - Navigate to "Windows Logs" -> "System".
echo    - Look for Error or Critical events around the time of the BSOD.
echo    - Look for "BugCheck" events. Note the "Stop Code" (e.g., PAGE_FAULT_IN_NONPAGED_AREA)
echo      and associated parameters. This is the MOST important clue.
echo    - Search online for the specific Stop Code you find.
echo.
echo 2. Test RAM:
echo    - Press Windows Key + R, type "mdsched.exe" and press Enter.
echo    - Choose to restart now and check for problems.
echo    - This tool runs a memory test before Windows fully loads.
echo    - If it finds errors, your RAM is likely faulty.
echo.
echo 3. Check Drive Health:
echo    - This script scheduled a thorough Check Disk (chkdsk) for C: on reboot.
echo      This fixes *file system* errors.
echo    - For physical drive health (SSD or HDD), use tools that read S.M.A.R.T. data
echo      (e.g., CrystalDiskInfo, or `wmic diskdrive get status` in an Admin Command Prompt -
echo      though wmic is basic).
echo.
echo 4. Check Component Temperatures:
echo    - Overheating CPU or GPU is a common cause of instability/BSODs, especially under load.
echo    - Download a hardware monitoring tool (e.g., HWMonitor, HWiNFO) to check temps.
echo.
echo 5. Stress Test Components (Advanced):
echo    - If temps are okay, you might need to test components under load.
echo    - Tools like Prime95 (CPU), FurMark (GPU), or MemTest86 (RAM - separate bootable tool)
echo      can help identify instability when the component is stressed.
echo.
echo 6. Check Power Supply Unit (PSU):
echo    - A failing PSU can cause random crashes, especially under heavy system load.
echo    - Harder to diagnose. Look for symptoms like shutdowns instead of BSODs, or issues only under load.
echo    - May require swapping the PSU to test.
echo.
echo 7. Update/Rollback Drivers:
echo    - Graphics drivers, network drivers, and storage controller drivers are common BSOD culprits.
echo    - Try updating them or rolling back to a previous stable version.
echo.
echo Consider using Safe Mode to troubleshoot driver issues if BSODs prevent normal boot.
echo.
pause
cls

:: ============================================================================
echo SECTION 6: FINAL CHECKS AND COMPLETION
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
echo All selected network, OS optimization, black screen fix, lightweight
echo tweaks, and internal BSOD-related fixes (SFC, DISM, Chkdsk) have been executed.
echo.
echo Refer to SECTION 5 in the output above for guidance on MANUAL steps
echo to diagnose potential HARDWARE causes of BSODs if they continue.
echo.
echo *** CRITICAL REMINDER ***
echo A system RESTART is NOW STRONGLY RECOMMENDED!
echo Many changes (Network Resets, Fast Startup, Check Disk scheduling,
echo Display Cache, Lightweight Tweaks) require a restart to take effect.
echo The Check Disk scan will run automatically on C: during the next boot.
echo.
pause
exit /b 0
