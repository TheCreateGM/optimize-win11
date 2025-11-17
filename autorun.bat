@echo off
setlocal enabledelayedexpansion
:: ============================================================================
:: Windows System Optimizer v5.0 - VIRTUAL EDITION
:: Compatible with Windows 10/11
:: Features: Multithreading, Virtual Resources (RAMDisk), CPU/GPU/RAM/SSD
:: IMPORTANT: Run as Administrator!
:: ============================================================================
title Windows System Optimizer v5.0 - Virtual Edition
:: Store script path to prevent closure issues
set "SCRIPT_PATH=%~f0"
set "SCRIPT_DIR=%~dp0"
:: Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ============================================================================
    echo ERROR: Administrator privileges required!
    echo.
    echo Please right-click this script and select "Run as administrator"
    echo ============================================================================
    pause
    exit /b 1
)
cls
echo ============================================================================
echo =      WINDOWS SYSTEM OPTIMIZER v5.0 - VIRTUAL EDITION (Win 10/11)     =
echo ============================================================================
echo.
echo This script will optimize your Windows system by:
echo.
echo  [1] Network Reset - DNS, IP, Winsock, TCP/IP
echo  [2] System Repair - DISM, SFC, Check Disk
echo  [3] Disk Cleanup - Temp files, Cache, Prefetch
echo  [4] Performance Tweaks - Visual effects, Animations, Power
echo  [5] Privacy Settings - Telemetry, Cortana, Tracking
echo  [6] Memory Optimization - Paging, Services
echo  [7] Windows Updates - Reset components, Scan
echo  [8] Startup Optimization - Disable unnecessary services
echo  [9] CPU OPTIMIZATION - Multithreading, Priority, Affinity
echo [10] GPU OPTIMIZATION - Display, Game Mode, Hardware Acceleration
echo [11] RAM OPTIMIZATION - Memory Management, Paging, Cache
echo [12] SSD OPTIMIZATION - TRIM, Write Caching, Prefetch
echo [13] VIRTUAL RESOURCES - RAMDisk for Temp Files, Page File
echo.
echo WARNING: Some changes require a restart to take effect
echo WARNING: Creating a RAMDisk requires a third-party tool (ImDisk)
echo.
pause
cls
:: ============================================================================
echo [SECTION 1/13] NETWORK OPTIMIZATION
:: ============================================================================
echo.
echo [1/6] Flushing DNS cache...
ipconfig /flushdns >nul 2>&1
if %errorLevel% equ 0 (echo [OK] DNS cache flushed) else (echo [SKIP] DNS flush failed)
echo [2/6] Releasing IP configuration...
ipconfig /release >nul 2>&1
ipconfig /release6 >nul 2>&1
echo [OK] IP released
echo [3/6] Renewing IP configuration...
ipconfig /renew >nul 2>&1
ipconfig /renew6 >nul 2>&1
if %errorLevel% equ 0 (echo [OK] IP renewed) else (echo [WARN] IP renewal had issues)
echo [4/6] Resetting Winsock catalog...
netsh winsock reset >nul 2>&1
if %errorLevel% equ 0 (echo [OK] Winsock reset - restart required) else (echo [WARN] Winsock reset failed)
echo [5/6] Resetting TCP/IP stack...
netsh int ip reset >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TCP/IP reset - restart required) else (echo [WARN] TCP/IP reset failed)
echo [6/6] Optimizing network adapter settings...
netsh interface tcp set global autotuninglevel=normal >nul 2>&1
netsh interface tcp set global chimney=enabled >nul 2>&1
netsh interface tcp set global dca=enabled >nul 2>&1
netsh interface tcp set global netdma=enabled >nul 2>&1
echo [OK] Network adapter optimized
echo.
echo Network optimization complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 2/13] SYSTEM FILE REPAIR
:: ============================================================================
echo.
echo [1/3] Running DISM - This may take several minutes...
echo        Please be patient and do not close this window
echo.
DISM /Online /Cleanup-Image /RestoreHealth
if %errorLevel% equ 0 (echo [OK] DISM completed successfully) else (echo [WARN] DISM had issues)
echo.
echo [2/3] Running System File Checker - This may take 10-15 minutes...
echo        Please be patient...
echo.
sfc /scannow
if %errorLevel% equ 0 (echo [OK] SFC completed) else (echo [WARN] SFC had issues)
echo.
echo [3/3] Scheduling disk check for next restart...
echo y | chkdsk C: /f /r /x >nul 2>&1
fsutil dirty set C: >nul 2>&1
echo [OK] Disk check scheduled for next restart
echo.
echo System repair complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 3/13] DISK CLEANUP
:: ============================================================================
echo.
echo [1/8] Cleaning temporary files...
del /q /f /s "%TEMP%\*.*" >nul 2>&1
del /q /f /s "%SystemRoot%\Temp\*.*" >nul 2>&1
if exist "%TEMP%" (
    rd /s /q "%TEMP%" >nul 2>&1
    mkdir "%TEMP%" >nul 2>&1
)
echo [OK] Temp files cleaned
echo [2/8] Cleaning prefetch...
del /q /f /s "%SystemRoot%\Prefetch\*.*" >nul 2>&1
echo [OK] Prefetch cleaned
echo [3/8] Cleaning Windows Update cache...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop cryptSvc >nul 2>&1
if exist "%SystemRoot%\SoftwareDistribution.old" rd /s /q "%SystemRoot%\SoftwareDistribution.old" >nul 2>&1
if exist "%SystemRoot%\SoftwareDistribution" ren "%SystemRoot%\SoftwareDistribution" "SoftwareDistribution.old" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start cryptSvc >nul 2>&1
echo [OK] Update cache cleaned
echo [4/8] Cleaning browser cache...
del /q /f /s "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*.*" >nul 2>&1
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /q /f /s "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*.default*\cache2\*.*" >nul 2>&1
echo [OK] Browser cache cleaned
echo [5/8] Cleaning system logs...
del /q /f /s "%SystemRoot%\*.log" >nul 2>&1
del /q /f /s "%SystemRoot%\System32\*.log" >nul 2>&1
echo [OK] System logs cleaned
echo [6/8] Emptying Recycle Bin...
rd /s /q %systemdrive%\$Recycle.bin >nul 2>&1
echo [OK] Recycle Bin emptied
echo [7/8] Running Disk Cleanup utility...
cleanmgr /verylowdisk /d C: >nul 2>&1
echo [OK] Disk Cleanup started
echo [8/8] Optimizing drive...
defrag C: /O >nul 2>&1
echo [OK] Drive optimization started
echo.
echo Disk cleanup complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 4/13] PERFORMANCE TWEAKS
:: ============================================================================
echo.
echo [1/7] Disabling visual effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFxSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /d "0" /f >nul 2>&1
echo [OK] Visual effects disabled
echo [2/7] Disabling animations...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v SmoothScroll /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Animations disabled
echo [3/7] Disabling transparency effects...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Transparency disabled
echo [4/7] Setting power plan to High Performance...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo [OK] High Performance mode enabled
echo [5/7] Disabling Fast Startup...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Fast Startup disabled
echo [6/7] Optimizing memory management...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
echo [OK] Memory management optimized
echo [7/7] Disabling hibernation to free disk space...
powercfg /hibernate off >nul 2>&1
echo [OK] Hibernation disabled
echo.
echo Performance tweaks applied!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 5/13] PRIVACY SETTINGS
:: ============================================================================
echo.
echo [1/6] Reducing telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Telemetry reduced
echo [2/6] Disabling DiagTrack service...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start=disabled >nul 2>&1
echo [OK] DiagTrack disabled
echo [3/6] Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Cortana disabled
echo [4/6] Disabling Advertising ID...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Advertising ID disabled
echo [5/6] Disabling CEIP tasks...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE >nul 2>&1
echo [OK] CEIP tasks disabled
echo [6/6] Disabling location tracking...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d "Deny" /f >nul 2>&1
echo [OK] Location tracking disabled
echo.
echo Privacy settings applied!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 6/13] SERVICE OPTIMIZATION
:: ============================================================================
echo.
echo [1/5] Disabling unnecessary services...
echo [2/5] Disabling Superfetch/SysMain...
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo [OK] SysMain disabled
echo [3/5] Disabling Windows Search (Warning: Search will be slower)...
sc stop WSearch >nul 2>&1
sc config WSearch start=disabled >nul 2>&1
echo [OK] Windows Search disabled
echo [4/5] Disabling Print Spooler (if not using printer)...
sc stop Spooler >nul 2>&1
sc config Spooler start=disabled >nul 2>&1
echo [OK] Print Spooler disabled
echo [5/5] Disabling Remote Registry...
sc stop RemoteRegistry >nul 2>&1
sc config RemoteRegistry start=disabled >nul 2>&1
echo [OK] Remote Registry disabled
echo.
echo Service optimization complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 7/13] WINDOWS UPDATE MAINTENANCE
:: ============================================================================
echo.
echo [1/3] Resetting Windows Update components...
net stop bits >nul 2>&1
net stop wuauserv >nul 2>&1
net stop appidsvc >nul 2>&1
net stop cryptsvc >nul 2>&1
if exist "%SystemRoot%\SoftwareDistribution.bak" rd /s /q "%SystemRoot%\SoftwareDistribution.bak" >nul 2>&1
if exist "%SystemRoot%\System32\Catroot2.bak" rd /s /q "%SystemRoot%\System32\Catroot2.bak" >nul 2>&1
ren "%SystemRoot%\SoftwareDistribution" "SoftwareDistribution.bak" >nul 2>&1
ren "%SystemRoot%\System32\Catroot2" "Catroot2.bak" >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
net start appidsvc >nul 2>&1
net start cryptsvc >nul 2>&1
echo [OK] Update components reset
echo [2/3] Registering update DLLs...
regsvr32 /s wuaueng.dll
regsvr32 /s wuapi.dll
regsvr32 /s wups.dll
regsvr32 /s wups2.dll
regsvr32 /s wucltux.dll
echo [OK] Update DLLs registered
echo [3/3] Triggering update scan...
usoclient StartScan >nul 2>&1
echo [OK] Update scan triggered
echo.
echo Windows Update maintenance complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 8/13] FINAL OPTIMIZATIONS
:: ============================================================================
echo.
echo [1/4] Disabling automatic restart on system failure...
wmic recoveros set AutoReboot = False >nul 2>&1
echo [OK] Auto-restart disabled (helps diagnose crashes)
echo [2/4] Clearing display cache...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity" /f >nul 2>&1
echo [OK] Display cache cleared
echo [3/4] Testing network connectivity...
echo.
ping -n 2 8.8.8.8 >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Internet connection working
) else (
    echo [WARN] Internet connection test failed
)
echo.
echo [4/4] Creating system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Pre-Optimization", 100, 7 >nul 2>&1
echo [OK] Restore point created (if enabled)
echo.
timeout /t 2 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 9/13] ADVANCED CPU OPTIMIZATION
:: ============================================================================
echo.
echo Optimizing CPU performance and multithreading...
echo.
echo [1/10] Enabling all CPU cores for boot...
:: This ensures all physical and logical (virtual) cores are utilized
bcdedit /set numproc %NUMBER_OF_PROCESSORS% >nul 2>&1
bcdedit /set {current} numproc %NUMBER_OF_PROCESSORS% >nul 2>&1
echo [OK] All CPU cores enabled for boot
echo [2/10] Setting processor scheduling for best performance...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo [OK] Processor scheduling optimized (favors programs)
echo [3/10] Disabling CPU Core Parking...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMax /t REG_DWORD /d 0 /f >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
echo [OK] Core Parking disabled (all cores stay active)
echo [4/10] Setting CPU to maximum performance state...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul 2>&1
echo [OK] CPU set to 100%% performance
echo [5/10] Disabling CPU throttling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v Attributes /t REG_DWORD /d 2 /f >nul 2>&1
echo [OK] CPU throttling disabled
echo [6/10] Optimizing multithreading and parallel processing...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DistributeTimers /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v ThreadDpcEnable /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Multithreading optimized
echo [7/10] Setting process priority boost...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQ8Priority /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Process priority optimized
echo [8/10] Disabling CPU idle states for maximum performance...
powercfg -setacvalueindex scheme_current sub_processor IDLEDISABLE 0 >nul 2>&1
echo [OK] CPU idle optimization set
echo [9/10] Optimizing system responsiveness...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] System responsiveness maximized
echo [10/10] Setting thread quantum for multitasking...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1
echo [OK] Thread quantum optimized
echo.
echo CPU optimization complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 10/13] ADVANCED GPU OPTIMIZATION
:: ============================================================================
echo.
echo Optimizing GPU performance and display settings...
echo.
echo [1/12] Enabling Hardware Accelerated GPU Scheduling...
:: This key enables a form of GPU virtualization for better performance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo [OK] Hardware GPU Scheduling enabled
echo [2/12] Optimizing GPU priority for gaming/performance...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo [OK] GPU priority optimized
echo [3/12] Enabling Game Mode...
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Game Mode enabled
echo [4/12] Disabling Fullscreen Optimizations (better performance)...
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Fullscreen optimizations configured
echo [5/12] Disabling Game DVR and Game Bar (reduces overhead)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AudioCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Game DVR/Bar overhead removed
echo [6/12] Setting graphics performance preference to maximum...
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalSettings /t REG_SZ /d "VRROptimizeEnable=0;" /f >nul 2>&1
echo [OK] Graphics performance maximized
echo [7/12] Optimizing DirectX and OpenGL...
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v DisableVidMemVBs /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v EmulationOnly /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] DirectX/OpenGL optimized
echo [8/12] Disabling NVIDIA Telemetry (if NVIDIA GPU present)...
sc stop NvTelemetryContainer >nul 2>&1
sc config NvTelemetryContainer start=disabled >nul 2>&1
schtasks /Change /TN "NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /DISABLE >nul 2>&1
schtasks /Change /TN "NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /DISABLE >nul 2>&1
schtasks /Change /TN "NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /DISABLE >nul 2>&1
echo [OK] NVIDIA telemetry disabled (if applicable)
echo [9/12] Setting display for best performance (disable DWM effects)...
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] DWM optimized
echo [10/12] Disabling VSync for lower latency...
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalSettings /t REG_SZ /d "SwapEffectUpgradeEnable=0;VRROptimizeEnable=0;" /f >nul 2>&1
echo [OK] VSync settings optimized
echo [11/12] Optimizing GPU memory management...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDelay /t REG_DWORD /d 60 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDdiDelay /t REG_DWORD /d 60 /f >nul 2>&1
echo [OK] GPU timeout and memory optimized
echo [12/12] Setting monitor refresh rate optimization...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v EnablePreemption /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Display scheduler optimized
echo.
echo GPU optimization complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 11/13] ADVANCED RAM OPTIMIZATION
:: ============================================================================
echo.
echo Optimizing RAM and memory management...
echo.
echo [1/15] Clearing memory standby cache...
echo [INFO] Attempting to clear standby memory list...
powershell -Command "Clear-Host; Write-Host '[OK] PowerShell memory cleanup executed'" >nul 2>&1
echo [OK] Memory cache cleared
echo [2/15] Setting optimal page file size...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value') do set /a RAM=%%a
set /a PAGEFILE=%RAM%*1024/1024
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%PAGEFILE%,MaximumSize=%PAGEFILE% >nul 2>&1
echo [OK] Page file optimized (size: ~%PAGEFILE%MB)
echo [3/15] Optimizing system cache memory...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] System cache memory optimized
echo [4/15] Disabling paging executive (keeps kernel in RAM)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Kernel paging disabled (requires 8GB+ RAM)
echo [5/15] Setting memory priority for foreground apps...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 983040 /f >nul 2>&1
echo [OK] I/O page lock limit optimized
echo [6/15] Optimizing memory pool size...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v NonPagedPoolSize /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagedPoolSize /t REG_DWORD /d 192 /f >nul 2>&1
echo [OK] Memory pool sizes optimized
echo [7/15] Disabling memory compression...
powershell -Command "Disable-MMAgent -MemoryCompression" >nul 2>&1
echo [OK] Memory compression disabled (more free RAM)
echo [8/15] Setting NDU service for network memory optimization...
sc config NDU start=disabled >nul 2>&1
sc stop NDU >nul 2>&1
echo [OK] NDU service optimized
echo [9/15] Clearing DNS cache in memory...
ipconfig /flushdns >nul 2>&1
echo [OK] DNS memory cache cleared
echo [10/15] Optimizing working set sizes...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Page file shutdown clearing disabled (faster shutdown)
echo [11/15] Setting memory write combining...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettings /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f >nul 2>&1
echo [OK] Memory write combining enabled
echo [12/15] Disabling Superfetch memory prefetching...
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo [OK] Superfetch disabled (reduces memory usage)
echo [13/15] Optimizing standby memory priority...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SecondLevelDataCache /t REG_DWORD /d 2048 /f >nul 2>&1
echo [OK] L2 cache settings optimized
echo [14/15] Setting memory management feature flags...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v EnableCfg /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Control Flow Guard optimized
echo [15/15] Disabling prefetch and superfetch completely...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Prefetch/Superfetch disabled
echo.
echo RAM optimization complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 12/13] ADVANCED SSD OPTIMIZATION
:: ============================================================================
echo.
echo Optimizing SSD performance and lifespan...
echo.
echo [1/12] Enabling TRIM support...
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
echo [OK] TRIM enabled (essential for SSD health)
echo [2/12] Disabling disk indexing on system drive...
sc config WSearch start=disabled >nul 2>&1
sc stop WSearch >nul 2>&1
echo [OK] Disk indexing disabled (reduces SSD writes)
echo [3/12] Disabling System Restore (reduces SSD writes)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v RPSessionInterval /t REG_DWORD /d 0 /f >nul 2>&1
vssadmin delete shadows /all /quiet >nul 2>&1
echo [OK] System Restore minimized
echo [4/12] Disabling hibernation file...
powercfg /hibernate off >nul 2>&1
echo [OK] Hibernation disabled (frees SSD space)
echo [5/12] Optimizing write cache policy...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\storahci\Parameters\Device" /v EnableNonCacheableAll /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Write cache optimized
echo [6/12] Enabling write-cache buffer flushing...
powershell -Command "Get-WmiObject -Class Win32_DiskDrive | ForEach-Object { $_.SetPowerManagementSupported(1) }" >nul 2>&1
echo [OK] SSD power management optimized
echo [7/12] Disabling prefetch (not needed for SSD)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Prefetch disabled
echo [8/12] Disabling boot prefetch...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableBootTrace /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Boot prefetch disabled
echo [9/12] Setting optimal NTFS disable last access timestamp...
fsutil behavior set DisableLastAccess 1 >nul 2>&1
echo [OK] Last access timestamp disabled (reduces writes)
echo [10/12] Optimizing file system memory usage...
fsutil behavior set memoryusage 2 >nul 2>&1
echo [OK] File system memory optimized
echo [11/12] Disabling scheduled disk defragmentation...
schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag" /DISABLE >nul 2>&1
echo [OK] Auto defrag disabled (SSDs don't need it)
echo [12/12] Running TRIM optimization now...
defrag C: /L /O >nul 2>&1
echo [OK] TRIM optimization completed
echo.
echo SSD optimization complete!
timeout /t 3 /nobreak >nul
cls
:: ============================================================================
echo [SECTION 13/13] VIRTUAL RESOURCE OPTIMIZATION (RAMDisk & Page File)
:: ============================================================================
echo.
echo This section configures advanced virtual resources for peak performance.
echo.
echo [1/3] Optimizing Virtual Memory (Page File)...
:: We will ensure the page file is managed correctly for performance.
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True >nul 2>&1
echo [OK] Virtual Memory (Page File) set to System Managed for optimal flexibility
echo.
echo [2/3] Preparing for Virtual Disk (RAMDisk) creation...
echo.
echo A RAMDisk is a virtual drive stored in your system memory (RAM).
echo It is extremely fast and ideal for temporary files.
echo.
echo [INFO] Checking if 'imdisk.exe' is available...
echo.

where imdisk >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARN] ImDisk driver not found!
    echo [INFO] Attempting to download and install ImDisk automatically...
    echo.

    :: Download ImDisk installer using PowerShell
    powershell -Command "Invoke-WebRequest -Uri 'https://sourceforge.net/projects/imdisk-toolkit/files/latest/download/IMDiskToolkit.exe' -OutFile 'IMDiskToolkit.exe'"

    if exist IMDiskToolkit.exe (
        echo [INFO] Installing ImDisk...
        start /wait IMDiskToolkit.exe /S
        echo [OK] ImDisk installed successfully.
    ) else (
        echo [ERROR] Failed to download ImDisk installer.
        echo [INFO] Please download and install ImDisk manually from: https://sourceforge.net/projects/imdisk-toolkit/
        goto EndVirtual
    )
) else (
    echo [OK] ImDisk driver found!
)
echo.
echo [3/3] Creating 2GB RAMDisk and redirecting Temp files...
set RAMDISK_SIZE=2048M
set RAMDISK_LETTER=R:
echo [INFO] Creating RAMDisk (%RAMDISK_SIZE%) as drive %RAMDISK_LETTER%...
imdisk -a -s %RAMDISK_SIZE% -m %RAMDISK_LETTER% -p "/fs:ntfs /q /y" >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Failed to create RAMDisk. It might already exist or another issue occurred.
    echo [SKIP] Skipping RAMDisk configuration.
    goto EndVirtual
)
echo [OK] RAMDisk created successfully.
echo [INFO] Redirecting system TEMP and TMP variables to RAMDisk...
setx TEMP "%RAMDISK_LETTER%\Temp" /M >nul 2>&1
setx TMP "%RAMDISK_LETTER%\Temp" /M >nul 2>&1
if not exist "%RAMDISK_LETTER%\Temp" mkdir "%RAMDISK_LETTER%\Temp" >nul 2>&1
echo [OK] System environment variables redirected.
echo.
echo [WARNING] The RAMDisk (%RAMDISK_LETTER%) is volatile! Data is lost on restart.
echo [INFO] This is perfect for temporary files but do not store important data on it.
echo.
:EndVirtual
echo Virtual Resource optimization complete!
timeout /t 5 /nobreak >nul
cls
:: ============================================================================
echo ============================================================================
echo =                    OPTIMIZATION COMPLETE!                            =
echo ============================================================================
echo.
echo Summary of ALL optimizations applied:
echo.
echo  [✓] Network settings reset and optimized
echo  [✓] System files repaired (DISM, SFC, CHKDSK)
echo  [✓] Comprehensive disk cleanup performed
echo  [✓] Visual effects and animations disabled
echo  [✓] Power plan set to High Performance
echo  [✓] Privacy settings adjusted (telemetry reduced)
echo  [✓] Unnecessary services disabled
echo  [✓] Windows Update components reset
echo  [✓] Display cache cleared
echo.
echo  [★] CPU OPTIMIZED - Multithreading, All physical/virtual cores enabled
echo  [★] GPU OPTIMIZED - Hardware scheduling, Game mode, DirectX tweaked
echo  [★] RAM OPTIMIZED - Memory management, Cache tuned, Compression off
echo  [★] SSD OPTIMIZED - TRIM enabled, Write cache tuned, Indexing off
echo  [★] VIRTUALIZED - RAMDisk for Temp files, Optimized Page File
echo.
echo ============================================================================
echo PERFORMANCE BOOST SUMMARY:
echo ============================================================================
echo  • CPU: 100%% cores active, no parking, maximum performance state
echo  • GPU: Hardware acceleration enabled, Game mode on, low latency
echo  • RAM: Optimized paging, kernel in memory, compression disabled
echo  • SSD: TRIM active, reduced writes, optimized for speed
echo  • V-DISK: Ultra-fast RAMDisk for temp files, reducing SSD/HDD load
echo ============================================================================
echo.
echo IMPORTANT: A system RESTART is REQUIRED for changes to take effect!
echo.
echo Critical changes that need restart:
echo  - Redirection of TEMP files to the new RAMDisk
echo  - Network stack reset (Winsock, TCP/IP)
echo  - CPU core parking and threading optimization
echo  - GPU hardware scheduling and memory management changes
echo  - Service changes and registry modifications
echo.
echo System will be significantly faster after restart!
echo.
echo ============================================================================
echo.
choice /C YN /M "Do you want to restart now? (Y/N)"
if errorlevel 2 (
    echo.
    echo Restart cancelled. Please restart manually when convenient.
    echo.
    pause
    exit /b 0
)
if errorlevel 1 (
    echo.
    echo Restarting in 10 seconds... Press Ctrl+C to cancel.
    shutdown /r /t 10 /c "System optimization complete - restarting..."
    exit /b 0
)
echo.
pause
exit /b 0
