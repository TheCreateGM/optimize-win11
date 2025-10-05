@echo off
:: ============================================================================
:: Batch Script for Advanced Windows Troubleshooting, Optimization,
:: Black Screen Fix Attempts, Enhanced Cleanup, Performance Tweaks, Memory/Disk Boosts,
:: Privacy Adjustments, Update Resets, and BSOD Guidance.
:: Version: 2.3 (Added Memory & Disk Boosts)
:: IMPORTANT: Run this script as an Administrator!
:: ============================================================================
title Advanced Windows Troubleshoot & Optimize Tool v2.3

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
echo =      ADVANCED WINDOWS TROUBLESHOOT / OPTIMIZE / MAINTAIN TOOL        =
echo ============================================================================
echo This script will attempt to:
echo 1. Reset network configurations (IP, Winsock, optional Firewall).
echo 2. Repair Windows system files and component store (DISM, SFC).
echo 3. Perform OS Optimizations, Enhanced Disk Cleanup, and Black Screen Fixes.
echo    (Temp Files, Windows Update Cache, Prefetch, Fast Startup, Display Cache, Explorer Restart, Drive Optimization)
echo 4. Apply Performance & Responsiveness Tweaks (Visual Effects, UI Animations, Power Plan).
echo 5. Adjust Privacy settings and disable selected Background Services/Features
echo    (Telemetry, Cortana, Search Indexing, Sysmain, DiagTrack, CEIP, Ad ID).
echo 6. Apply Memory & Disk Performance Boosts (Paging, Last Access Time, Hibernation).
echo 7. Provide guidance on Memory Optimization.
echo 8. Perform Driver & Windows Update Maintenance (Reset Update Components, Trigger Scan).
echo 9. Provide information and suggest manual steps for troubleshooting BSODs.
echo 10. Disable Automatic Restart on System Failure (Helps diagnose BSODs).
echo 11. Optimize Network Settings
echo 12. Clean Up Disk and Unwanted Files
echo 13. Final Connectivity Checks and Completion.
echo.
echo WARNING: MANY steps require a system RESTART afterwards to complete.
echo WARNING: Resetting Firewall or Display Cache removes custom settings.
echo WARNING: Check Disk runs before Windows loads on reboot and can take time.
echo WARNING: Some tweaks disable Windows features or change system behavior.
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
echo SECTION 3: OS OPTIMIZATION, ENHANCED CLEANUP & BLACK SCREEN FIX ATTEMPTS
:: ============================================================================
echo.
echo [INFO] Cleaning User and System Temporary Files...
del /q /f /s %TEMP%\*.* >nul 2>&1
del /q /f /s %SystemRoot%\Temp\*.* >nul 2>&1
if exist "%TEMP%" rmdir /s /q "%TEMP%" >nul 2>&1
mkdir "%TEMP%" >nul 2>&1
if exist "%SystemRoot%\Temp" rmdir /s /q "%SystemRoot%\Temp" >nul 2>&1
mkdir "%SystemRoot%\Temp" >nul 2>&1
echo [INFO] Temporary files cleaned.
echo.

echo [INFO] Cleaning Prefetch Files...
if exist "%SystemRoot%\Prefetch\*.*" del /q /f /s %SystemRoot%\Prefetch\*.* >nul 2>&1
echo [INFO] Prefetch files cleaned.
echo.

echo [INFO] Attempting to clean Windows Update Cache (SoftwareDistribution)...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop cryptSvc >nul 2>&1 :: Often related
if exist "%SystemRoot%\SoftwareDistribution.old" rmdir /s /q "%SystemRoot%\SoftwareDistribution.old" >nul 2>&1
if exist "%SystemRoot%\SoftwareDistribution" ren "%SystemRoot%\SoftwareDistribution" "SoftwareDistribution.old" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start cryptSvc >nul 2>&1
echo [INFO] Windows Update Cache (SoftwareDistribution) cleared. A new one will be generated.
echo.

echo [INFO] Running Windows Disk Cleanup (automated, non-interactive for low disk space preset)...
echo        This may take a few minutes.
cleanmgr /verylowdisk /d C: > nul 2>&1
echo [INFO] Windows Disk Cleanup initiated.
echo.
pause
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
    reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\ScaleFactors" /f > nul 2>&1 :: Another related key
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

echo [INFO] Optimizing System Drive (typically C:)...
echo [INFO] This performs Defrag on HDDs or TRIM on SSDs. May take time.
defrag C: /O
echo.
echo [INFO] Drive optimization command issued.
echo.
pause
cls

:: ============================================================================
echo SECTION 4: PERFORMANCE & RESPONSIVENESS TWEAKS
:: ============================================================================
echo.
:VISUAL_EFFECTS_PROMPT
echo [ACTION REQUIRED] Adjust Visual Effects for Best Performance?
echo          This disables most animations and visual niceties for snappier response.
set /p AdjustVisuals="Type 'YES' to adjust, or 'NO' to skip: "
echo.

if /i "%AdjustVisuals%"=="YES" (
    echo [INFO] Adjusting Visual Effects for Best Performance...
    :: This registry key controls the "Adjust for best performance" setting
    :: It sets UserPreferencesMask to a value that disables most effects.
    :: 9E = visual styles on windows and buttons enabled (keeps it looking mostly modern)
    :: 1E = visual styles off (classic look) - going with 9E as less jarring
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFxSetting /t REG_DWORD /d 2 /f > nul 2>&1
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f > nul 2>&1
    :: Specific items (0=disable, 1=enable)
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /d "0" /f > nul 2>&1
    echo [INFO] Visual Effects set for best performance. Log off/on or restart may be needed for full effect.
) else if /i "%AdjustVisuals%"=="NO" (
    echo [INFO] Skipping Visual Effects adjustment.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto VISUAL_EFFECTS_PROMPT
)
echo.

:DISABLE_ANIMATIONS_PROMPT
echo [ACTION REQUIRED] Disable Additional Windows Animation Effects?
echo          This disables window animations, fade effects, and task switching animations
echo          for maximum performance and responsiveness.
set /p DisableAnimations="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableAnimations%"=="YES" (
    echo [INFO] Disabling Windows Animation Effects...
    :: Disable window animations
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d "0" /f > nul 2>&1
    :: Disable fade animations
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f > nul 2>&1
    :: Disable taskbar animations
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f > nul 2>&1
    :: Disable listbox smooth scrolling
    reg add "HKCU\Control Panel\Desktop" /v SmoothScroll /t REG_DWORD /d 0 /f > nul 2>&1
    :: Disable combo box animation
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f > nul 2>&1
    :: Disable cursor shadow
    reg add "HKCU\Control Panel\Desktop" /v CursorShadow /t REG_SZ /d "0" /f > nul 2>&1
    :: Disable drag full windows
    reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d "0" /f > nul 2>&1
    echo [INFO] Windows Animation Effects disabled. Log off/on or restart may be needed for full effect.
) else if /i "%DisableAnimations%"=="NO" (
    echo [INFO] Skipping Windows Animation Effects disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_ANIMATIONS_PROMPT
)
echo.

:DISABLE_TRANSPARENCY_PROMPT
echo [ACTION REQUIRED] Disable Windows Transparency Effects?
echo          This removes acrylic/transparent effects from start menu, taskbar, action center, etc.
echo          Can improve performance and responsiveness, especially on less powerful hardware.
set /p DisableTransparency="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableTransparency%"=="YES" (
    echo [INFO] Disabling Transparency Effects...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f > nul 2>&1
    echo [INFO] Transparency Effects disabled. Log off/on or restart may be needed.
) else if /i "%DisableTransparency%"=="NO" (
    echo [INFO] Skipping Transparency Effects disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_TRANSPARENCY_PROMPT
)
echo.


:POWER_PLAN_PROMPT
echo [ACTION REQUIRED] Set Power Plan to High Performance?
echo          This can improve performance but uses more energy.
echo          NOT recommended for laptops on battery power for extended periods.
set /p SetHighPerf="Type 'YES' to set, or 'NO' to skip: "
echo.

if /i "%SetHighPerf%"=="YES" (
    echo [INFO] Setting Power Plan to High Performance...
    :: GUID for High Performance power scheme
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul 2>&1
    echo [INFO] Power Plan set to High Performance.
) else if /i "%SetHighPerf%"=="NO" (
    echo [INFO] Skipping Power Plan adjustment.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto POWER_PLAN_PROMPT
)
echo.
echo [INFO] Performance & Responsiveness tweaks section completed.
echo.
pause
cls

:: ============================================================================
echo SECTION 5: PRIVACY, SERVICES & LIGHTWEIGHT WINDOWS TWEAKS
:: ============================================================================
echo.
echo [INFO] Applying potential privacy adjustments and lightweight OS tweaks...
echo.

:DISABLE_TELEMETRY_PROMPT
echo [ACTION REQUIRED] Reduce Windows Telemetry (Data Collection)?
echo          This reduces background data sending to Microsoft.
set /p DisableTelemetry="Type 'YES' to reduce, or 'NO' to skip: "
echo.

if /i "%DisableTelemetry%"=="YES" (
    echo [INFO] Reducing Windows Telemetry...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > nul 2>&1
    echo [INFO] Telemetry reduced. Requires restart.
) else if /i "%DisableTelemetry%"=="NO" (
    echo [INFO] Skipping Telemetry reduction.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_TELEMETRY_PROMPT
)
echo.

:DISABLE_DIAGTRACK_PROMPT
echo [ACTION REQUIRED] Disable Connected User Experiences and Telemetry Service (DiagTrack)?
echo          This service sends diagnostic and usage data.
set /p DisableDiagTrack="Type 'YES' to disable, or 'NO' to skip: "
echo.
if /i "%DisableDiagTrack%"=="YES" (
    echo [INFO] Disabling DiagTrack service...
    sc stop "DiagTrack" > nul 2>&1
    sc config "DiagTrack" start=disabled > nul 2>&1
    echo [INFO] DiagTrack service disabled. Requires restart.
) else if /i "%DisableDiagTrack%"=="NO" (
    echo [INFO] Skipping DiagTrack disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_DIAGTRACK_PROMPT
)
echo.

:DISABLE_CEIP_PROMPT
echo [ACTION REQUIRED] Disable Customer Experience Improvement Program (CEIP) Scheduled Tasks?
echo          These tasks collect data for CEIP.
set /p DisableCEIP="Type 'YES' to disable, or 'NO' to skip: "
echo.
if /i "%DisableCEIP%"=="YES" (
    echo [INFO] Disabling CEIP scheduled tasks...
    schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE > nul 2>&1
    schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE > nul 2>&1
    schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE > nul 2>&1
    schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /DISABLE > nul 2>&1
    schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE > nul 2>&1
    echo [INFO] CEIP scheduled tasks disabled.
) else if /i "%DisableCEIP%"=="NO" (
    echo [INFO] Skipping CEIP tasks disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_CEIP_PROMPT
)
echo.

:DISABLE_ADID_PROMPT
echo [ACTION REQUIRED] Disable Advertising ID for app tracking?
echo          This prevents apps from using your Advertising ID for personalized ads.
set /p DisableAdID="Type 'YES' to disable, or 'NO' to skip: "
echo.
if /i "%DisableAdID%"=="YES" (
    echo [INFO] Disabling Advertising ID...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f > nul 2>&1
    echo [INFO] Advertising ID disabled for current user. Log off/on may be needed.
) else if /i "%DisableAdID%"=="NO" (
    echo [INFO] Skipping Advertising ID disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_ADID_PROMPT
)
echo.

:DISABLE_CORTANA_PROMPT
echo [ACTION REQUIRED] Disable Cortana?
echo          This frees up resources if you don't use the assistant.
set /p DisableCortana="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableCortana%"=="YES" (
    echo [INFO] Disabling Cortana...
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
echo          Disabling *might* help high disk usage on older systems/HDDs,
echo          but its benefits/drawbacks can vary. Often fine to leave on SSDs.
set /p DisableSysmain="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableSysmain%"=="YES" (
    echo [INFO] Disabling Superfetch / Sysmain service...
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

:DISABLE_FONTS_PREVIEW_PROMPT
echo [ACTION REQUIRED] Disable Fonts Preview?
echo          This disables the preview of fonts in File Explorer.
echo          May improve performance.
set /p DisableFontPreview="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableFontPreview%"=="YES" (
    echo [INFO] Disabling Fonts Preview...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisableFontPreview /t REG_DWORD /d 1 /f > nul 2>&1
    echo [INFO] Font Preview disabled. Requires restart.
) else if /i "%DisableFontPreview%"=="NO" (
    echo [INFO] Skipping Font Preview disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_FONTS_PREVIEW_PROMPT
)
echo.

echo [INFO] Privacy, Services & Lightweight tweaks section completed.
echo.
pause
cls

:: ============================================================================
echo SECTION 6: MEMORY & DISK PERFORMANCE BOOSTS (TWEAKS)
:: ============================================================================
echo.
echo [INFO] Applying optional registry tweaks for Memory and Disk performance.
echo        These are for advanced users and can have varied effects.
echo.

:DISABLE_PAGING_EXECUTIVE_PROMPT
echo [ACTION REQUIRED] Apply Memory Paging Tweak? (Advanced)
echo          This keeps the Windows kernel and drivers in RAM instead of paging to disk.
echo WARNING: This can improve responsiveness but requires plenty of RAM (16GB+ recommended).
echo          It can cause instability on systems with low RAM.
set /p ApplyPagingTweak="Type 'YES' to apply, or 'NO' to skip: "
echo.

if /i "%ApplyPagingTweak%"=="YES" (
    echo [INFO] Applying Memory Paging tweak...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f > nul 2>&1
    echo [INFO] Memory Paging tweak applied. Requires restart.
) else if /i "%ApplyPagingTweak%"=="NO" (
    echo [INFO] Skipping Memory Paging tweak.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_PAGING_EXECUTIVE_PROMPT
)
echo.

:DISABLE_LAST_ACCESS_PROMPT
echo [ACTION REQUIRED] Apply Disk I/O Tweak (Disable Last Access Timestamps)?
echo          This prevents the file system from updating the 'last accessed' time on files/folders.
echo          It can reduce disk I/O and slightly improve performance, especially on HDDs.
set /p ApplyLastAccessTweak="Type 'YES' to apply, or 'NO' to skip: "
echo.

if /i "%ApplyLastAccessTweak%"=="YES" (
    echo [INFO] Applying Disk I/O tweak...
    fsutil behavior set disablelastaccess 1 > nul 2>&1
    echo [INFO] Disk I/O tweak applied. Requires restart.
) else if /i "%ApplyLastAccessTweak%"=="NO" (
    echo [INFO] Skipping Disk I/O tweak.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_LAST_ACCESS_PROMPT
)
echo.

:DISABLE_HIBERNATION_PROMPT
echo [ACTION REQUIRED] Disable Hibernation?
echo          This turns off hibernation and deletes the hiberfil.sys file,
echo          freeing up several gigabytes of disk space (equal to your RAM size).
echo WARNING: This also disables the 'Hibernate' power option.
set /p DisableHibernation="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableHibernation%"=="YES" (
    echo [INFO] Disabling Hibernation...
    powercfg /hibernate off
    echo [INFO] Hibernation disabled and hiberfil.sys removed.
) else if /i "%DisableHibernation%"=="NO" (
    echo [INFO] Skipping Hibernation disable.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_HIBERNATION_PROMPT
)
echo.
echo [INFO] Memory & Disk Performance Boosts section completed.
echo.
pause
cls

:: ============================================================================
echo SECTION 7: MEMORY OPTIMIZATION GUIDANCE
:: ============================================================================
echo.
echo [INFO] Memory Optimization Guidance:
echo.
echo True "RAM Cleaning" or "Memory Optimization" by scripts is limited.
echo Windows has its own memory management. Aggressive third-party "RAM boosters"
echo can sometimes be counterproductive by forcing data out of cache that
echo Windows would have managed efficiently.
echo.
echo This script has already taken steps that can indirectly help memory usage:
echo   - Disabling optional services like Sysmain, Cortana, Search Indexing, DiagTrack
echo     (if you chose to) frees up the RAM those services were using.
echo.
echo General Best Practices for Managing Memory:
echo   1. Restart Your Computer Regularly: This is the simplest way to clear RAM.
echo   2. Close Unused Applications: Programs consume RAM even when minimized.
echo   3. Limit Startup Programs: Too many programs starting with Windows can bog down
echo      your system and consume memory from the start. (Manage via Task Manager > Startup).
echo   4. Check for Memory-Hungry Processes: Use Task Manager (Ctrl+Shift+Esc)
echo      to see which applications are using the most memory.
echo   5. Consider Hardware Upgrades: If you consistently run out of RAM, you may
echo      need to install more physical RAM.
echo.
echo Advanced Note: Tools like "EmptyStandbyList.exe" (from Sysinternals-like community tools)
echo can clear standby memory, which *might* be useful in specific scenarios for developers
echo or testers, but is generally not needed for typical users.
echo.
pause
cls

:: ============================================================================
echo SECTION 8: DRIVER & WINDOWS UPDATE MAINTENANCE
:: ============================================================================
echo.
:RESET_UPDATE_COMPONENTS_PROMPT
echo [ACTION REQUIRED] Reset Windows Update Components?
echo          This can help resolve issues with Windows Update failing to download or install.
echo          It involves stopping services, renaming cache folders, and re-registering DLLs.
set /p ResetUpdates="Type 'YES' to reset, or 'NO' to skip: "
echo.

if /i "%ResetUpdates%"=="YES" (
    echo [INFO] Resetting Windows Update Components...
    echo [INFO] Stopping services...
    net stop bits > nul 2>&1
    net stop wuauserv > nul 2>&1
    net stop appidsvc > nul 2>&1
    net stop cryptsvc > nul 2>&1

    echo [INFO] Renaming SoftwareDistribution and Catroot2 folders...
    if exist "%SystemRoot%\SoftwareDistribution.old.bak" rmdir /s /q "%SystemRoot%\SoftwareDistribution.old.bak" >nul 2>&1
    if exist "%SystemRoot%\System32\Catroot2.old.bak" rmdir /s /q "%SystemRoot%\System32\Catroot2.old.bak" >nul 2>&1

    if exist "%SystemRoot%\SoftwareDistribution.old" ren "%SystemRoot%\SoftwareDistribution.old" "SoftwareDistribution.old.bak" >nul 2>&1
    if exist "%SystemRoot%\System32\Catroot2.old" ren "%SystemRoot%\System32\Catroot2.old" "Catroot2.old.bak" >nul 2>&1

    if exist "%SystemRoot%\SoftwareDistribution" ren "%SystemRoot%\SoftwareDistribution" "SoftwareDistribution.old" >nul 2>&1
    if exist "%SystemRoot%\System32\Catroot2" ren "%SystemRoot%\System32\Catroot2" "Catroot2.old" >nul 2>&1

    echo [INFO] Resetting Winsock (can be related to update download issues)...
    netsh winsock reset > nul 2>&1

    echo [INFO] Starting services...
    net start bits > nul 2>&1
    net start wuauserv > nul 2>&1
    net start appidsvc > nul 2>&1
    net start cryptsvc > nul 2>&1

    echo [INFO] Windows Update components reset. A restart might be beneficial.
) else if /i "%ResetUpdates%"=="NO" (
    echo [INFO] Skipping Windows Update Components reset.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto RESET_UPDATE_COMPONENTS_PROMPT
)
echo.

:TRIGGER_UPDATE_SCAN_PROMPT
echo [ACTION REQUIRED] Trigger a Windows Update Scan?
echo          This will attempt to initiate a check for new updates.
set /p TriggerScan="Type 'YES' to scan, or 'NO' to skip: "
echo.
if /i "%TriggerScan%"=="YES" (
    echo [INFO] Triggering Windows Update scan...
    REM Modern method for initiating scan
    powershell.exe -Command "(New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().Search('IsInstalled=0').Updates.Count" > nul 2>&1
    usoclient StartScan > nul 2>&1
    echo [INFO] Windows Update scan initiated. Check Windows Update settings for progress.
) else if /i "%TriggerScan%"=="NO" (
    echo [INFO] Skipping Windows Update scan.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto TRIGGER_UPDATE_SCAN_PROMPT
)
echo.
echo [INFO] Driver & Windows Update Maintenance section completed.
echo.
pause
cls

:: ============================================================================
echo SECTION 9: BSOD INFORMATION AND MANUAL DIAGNOSTIC STEPS
:: ============================================================================
echo.
echo [INFO] Information and Manual Steps for BSOD Troubleshooting:
echo.
echo This script has run various fixes for common *software* causes of BSODs
echo (corrupted system files, file system errors, potentially unstable settings, update issues).
echo However, BSODs are often caused by hardware issues or problematic drivers.
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
echo    - Check manufacturer websites (e.g., Nvidia, AMD, Intel, motherboard vendor) for latest drivers.
echo    - If a recent driver update caused issues, try rolling it back via Device Manager.
echo.
echo Consider using Safe Mode to troubleshoot driver issues if BSODs prevent normal boot.
echo.
pause
cls

:: ============================================================================
echo SECTION 10: STABILITY & RESTART FIXES
:: ============================================================================
echo.
:DISABLE_AUTO_RESTART_PROMPT
echo [ACTION REQUIRED] Disable Automatic Restart on System Failure?
echo          This is a key diagnostic step for random restarts. If your PC
echo          is restarting due to a BSOD (Blue Screen), this will stop the
echo          restart and show you the error code instead.
set /p DisableAutoRestart="Type 'YES' to disable, or 'NO' to skip: "
echo.

if /i "%DisableAutoRestart%"=="YES" (
    echo [INFO] Disabling 'Automatically restart' on system failure...
    wmic recoveros set AutoReboot = False > nul 2>&1
    echo [INFO] Automatic restart on system failure has been disabled.
    echo        If a BSOD occurs, the error screen will now remain visible.
) else if /i "%DisableAutoRestart%"=="NO" (
    echo [INFO] Skipping automatic restart adjustment.
) else (
    echo Invalid input. Please type 'YES' or 'NO'.
    goto DISABLE_AUTO_RESTART_PROMPT
)
echo.
echo [INFO] Stability & Restart Fixes section completed.
echo.
pause
cls

:: ============================================================================
echo SECTION 11: NETWORK OPTIMIZATION
:: ============================================================================
echo.
echo [INFO] Optimizing Network Settings...
echo.
echo [INFO] Resetting the TCP/IP stack and Winsock catalog can sometimes improve network performance.
echo       This has already been performed in Section 1.  Consider a restart if not already done.
echo.
echo [INFO] For more advanced network optimization, consider:
echo   - Examining network adapter settings for optimal configuration (e.g., QoS settings).
echo   - Reviewing and adjusting your firewall rules for efficiency.
echo   - Running a network speed test to ensure your connection is performing as expected.
echo.
pause
cls

:: ============================================================================
echo SECTION 12: CLEAN UP DISK AND UNWANTED FILES
:: ============================================================================
echo.
echo [INFO] Cleaning up the disk and removing unwanted files...
echo.
echo [INFO] Removing temporary internet files...
del /q /f /s "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*.*" >nul 2>&1
echo.
echo [INFO] Removing old system logs...
del /q /f /s "%SystemRoot%\System32\*.log" >nul 2>&1
del /q /f /s "%SystemRoot%\*.log" >nul 2>&1
echo.
echo [INFO] Emptying the recycle bin for all drives...
powershell.exe -Command Clear-RecycleBin -Force
echo.
echo [INFO] Removing browser cache and cookies (Chrome)...
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cookies" >nul 2>&1
echo.
echo [INFO] Cleanup complete.
echo.
pause
cls

:: ============================================================================
echo SECTION 13: FINAL CHECKS AND COMPLETION
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
echo All selected network, system file repair, OS optimization, cleanup,
echo performance tweaks, memory/disk boosts, privacy adjustments, stability fixes,
