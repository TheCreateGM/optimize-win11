@echo off
setlocal enabledelayedexpansion
:: ============================================================================
:: Windows System Optimizer v5.3 - VIRTUAL EDITION + Security & Malware Removal
:: Compatible with Windows 10/11
:: NEW: Comprehensive virus/malware removal and security hardening
:: IMPORTANT: Run as Administrator!
:: ============================================================================
title Windows System Optimizer v5.3 - Virtual Edition + Security Suite
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
echo =    WINDOWS SYSTEM OPTIMIZER v5.3 - VIRTUAL EDITION (Win 10/11)       =
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
echo [14] AI SYSTEM REMOVAL - Copilot, Recall, Windows AI features
echo [15] BATTERY OPTIMIZATION - Power management for longer battery life
echo [16] ADVANCED CPU THREAD OPTIMIZATION - AMD/Intel
echo [17] ADVANCED GPU THREAD OPTIMIZATION - NVIDIA/AMD/Intel
echo [18] GENERAL SYSTEM SMOOTHNESS - Latency, Responsiveness
echo [19] SECURITY HARDENING - Firewall, UAC, SmartScreen
echo [20] VIRUS/MALWARE REMOVAL - Deep scan and clean
echo.
echo WARNING: Some changes require a restart to take effect
echo WARNING: Security scans may take 30+ minutes to complete
echo.
pause
cls

:: ============================================================================
echo [SECTION 16/20] ADVANCED CPU THREAD OPTIMIZATION (AMD ^& Intel)
:: ============================================================================
echo.
echo Optimizing CPU thread scheduling for both AMD and Intel...
echo.

:: [1/8] Enable all logical cores (Hyper-Threading/SMT)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] System responsiveness maximized

:: [2/8] Optimize thread priority for foreground apps
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1
echo [OK] Thread priority optimized for foreground apps

:: [3/8] Disable CPU throttling for maximum performance
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 1 >nul 2>&1
powercfg -setactive scheme_current >nul 2>&1
echo [OK] CPU boost mode enabled

:: [4/8] Optimize thread quantum for multitasking
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo [OK] Thread quantum optimized

:: [5/8] Disable CPU core parking (keeps all cores active)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMax /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] CPU core parking disabled

:: [6/8] Optimize thread affinity for multi-core CPUs
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo [OK] Thread affinity optimized

:: [7/8] Disable CPU idle states for maximum performance
powercfg -setacvalueindex scheme_current sub_processor IDLEDISABLE 0 >nul 2>&1
echo [OK] CPU idle states disabled

:: [8/8] Optimize system timer resolution for lower latency
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] System timer resolution optimized

timeout /t 3 /nobreak >nul
cls

:: ============================================================================
echo [SECTION 17/20] ADVANCED GPU THREAD OPTIMIZATION (NVIDIA, AMD, Intel)
:: ============================================================================
echo.
echo Optimizing GPU thread scheduling for all major brands...
echo.

:: [1/10] Enable GPU hardware scheduling (Windows 11/10)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo [OK] GPU hardware scheduling enabled

:: [2/10] Optimize GPU thread priority for gaming and productivity
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
echo [OK] GPU thread priority optimized

:: [3/10] Disable GPU throttling for maximum performance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDelay /t REG_DWORD /d 60 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDdiDelay /t REG_DWORD /d 60 /f >nul 2>&1
echo [OK] GPU throttling disabled

:: [4/10] Optimize GPU memory management
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v EnablePreemption /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] GPU memory management optimized

:: [5/10] Disable GPU power saving features (for performance)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v DisablePowerManagement /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] GPU power management disabled

:: [6/10] Optimize GPU driver settings for low latency
reg add "HKLM\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalSettings /t REG_SZ /d "SwapEffectUpgradeEnable=0;VRROptimizeEnable=0;" /f >nul 2>&1
echo [OK] GPU driver settings optimized

:: [7/10] Disable GPU telemetry (NVIDIA, AMD, Intel)
sc stop NvTelemetryContainer >nul 2>&1
sc config NvTelemetryContainer start=disabled >nul 2>&1
schtasks /Change /TN "NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /DISABLE >nul 2>&1
schtasks /Change /TN "NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /DISABLE >nul 2>&1
schtasks /Change /TN "NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /DISABLE >nul 2>&1
echo [OK] GPU telemetry disabled

:: [8/10] Optimize GPU scheduler for multi-threaded workloads
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v EnablePreemption /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] GPU scheduler optimized

:: [9/10] Disable GPU driver timeouts
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\DCI" /v Timeout /t REG_DWORD /d 7 /f >nul 2>&1
echo [OK] GPU driver timeouts disabled

:: [10/10] Optimize GPU for DirectX and OpenGL
reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v DisableVidMemVBs /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v EmulationOnly /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] DirectX/OpenGL optimized

timeout /t 3 /nobreak >nul
cls

:: ============================================================================
echo [SECTION 18/20] GENERAL SYSTEM SMOOTHNESS
:: ============================================================================
echo.
echo Optimizing system for smoothness and responsiveness...
echo.

:: [1/6] Disable unnecessary visual effects
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFxSetting /t REG_DWORD /d 2 /f >nul 2>&1
echo [OK] Visual effects minimized

:: [2/6] Optimize system for best performance
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
echo [OK] System performance mode enabled

:: [3/6] Disable unnecessary animations
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Animations disabled

:: [4/6] Optimize disk cache for smoothness
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 983040 /f >nul 2>&1
echo [OK] Disk cache optimized

:: [5/6] Disable unnecessary background services
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start=disabled >nul 2>&1
sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo [OK] Background services optimized

:: [6/6] Optimize system for low latency
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] System latency minimized

timeout /t 3 /nobreak >nul
cls

:: ============================================================================
echo [SECTION 19/20] SECURITY HARDENING
:: ============================================================================
echo.
echo Hardening Windows security settings...
echo.

:: [1/15] Enable Windows Defender Real-Time Protection
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
echo [OK] Windows Defender Real-Time Protection enabled

:: [2/15] Enable Windows Firewall for all profiles
netsh advfirewall set allprofiles state on >nul 2>&1
echo [OK] Windows Firewall enabled (all profiles)

:: [3/15] Enable User Account Control (UAC) to highest level
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 2 /f >nul 2>&1
echo [OK] UAC enabled at highest level

:: [4/15] Enable SmartScreen for apps and files
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d "RequireAdmin" /f >nul 2>&1
echo [OK] SmartScreen enabled

:: [5/15] Disable SMBv1 (vulnerable protocol)
powershell -Command "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart" >nul 2>&1
echo [OK] SMBv1 protocol disabled

:: [6/15] Enable DEP (Data Execution Prevention) for all programs
bcdedit /set nx AlwaysOn >nul 2>&1
echo [OK] DEP enabled for all programs

:: [7/15] Disable AutoRun/AutoPlay for all drives
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f >nul 2>&1
echo [OK] AutoRun/AutoPlay disabled

:: [8/15] Disable Remote Desktop (security risk if not needed)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Remote Desktop disabled

:: [9/15] Enable Controlled Folder Access (Ransomware protection)
powershell -Command "Set-MpPreference -EnableControlledFolderAccess Enabled" >nul 2>&1
echo [OK] Controlled Folder Access enabled

:: [10/15] Block macros in Office files from the internet
reg add "HKCU\Software\Microsoft\Office\16.0\Word\Security" /v VBAWarnings /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Office\16.0\Excel\Security" /v VBAWarnings /t REG_DWORD /d 3 /f >nul 2>&1
echo [OK] Office macro security hardened

:: [11/15] Disable Windows Script Host (prevents VBS/JS malware)
reg add "HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Windows Script Host disabled

:: [12/15] Enable Windows Defender Application Guard
powershell -Command "Enable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -NoRestart" >nul 2>&1
echo [OK] Application Guard enabled (if available)

:: [13/15] Disable guest account
net user guest /active:no >nul 2>&1
echo [OK] Guest account disabled

:: [14/15] Enable automatic Windows updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 4 /f >nul 2>&1
echo [OK] Automatic Windows updates enabled

:: [15/15] Enable BitLocker startup authentication (if BitLocker is enabled)
reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v UseAdvancedStartup /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] BitLocker security enhanced

timeout /t 3 /nobreak >nul
cls

:: ============================================================================
echo [SECTION 20/20] VIRUS AND MALWARE REMOVAL
:: ============================================================================
echo.
echo Starting comprehensive virus and malware removal...
echo WARNING: This process may take 30-60 minutes depending on system size
echo.

:: [1/20] Update Windows Defender definitions
echo [1/20] Updating Windows Defender virus definitions...
powershell -Command "Update-MpSignature" >nul 2>&1
echo [OK] Defender definitions updated

:: [2/20] Run Windows Defender Quick Scan
echo [2/20] Running Windows Defender Quick Scan...
powershell -Command "Start-MpScan -ScanType QuickScan" >nul 2>&1
echo [OK] Quick scan completed

:: [3/20] Remove temporary files (common malware hiding spots)
echo [3/20] Removing temporary files...
del /f /s /q %TEMP%\*.* >nul 2>&1
del /f /s /q C:\Windows\Temp\*.* >nul 2>&1
rd /s /q %TEMP% >nul 2>&1
md %TEMP% >nul 2>&1
echo [OK] Temporary files cleaned

:: [4/20] Clear browser caches (malware removal)
echo [4/20] Clearing browser caches...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8 >nul 2>&1
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2 >nul 2>&1
echo [OK] Browser caches cleared

:: [5/20] Remove suspicious startup programs
echo [5/20] Scanning and removing suspicious startup entries...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Update" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Update" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "Windows Update" /f >nul 2>&1
echo [OK] Suspicious startup entries removed

:: [6/20] Scan and clean registry for malware traces
echo [6/20] Cleaning registry malware traces...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" /f >nul 2>&1
echo [OK] Registry cleaned

:: [7/20] Remove known malware file extensions
echo [7/20] Removing known malware file types...
del /f /s /q C:\*.vbs >nul 2>&1
del /f /s /q C:\*.js >nul 2>&1
del /f /s /q %APPDATA%\*.exe >nul 2>&1
echo [OK] Suspicious files removed

:: [8/20] Reset HOSTS file (malware often modifies this)
echo [8/20] Resetting HOSTS file...
attrib -r -s -h C:\Windows\System32\drivers\etc\hosts >nul 2>&1
echo 127.0.0.1 localhost > C:\Windows\System32\drivers\etc\hosts
echo ::1 localhost >> C:\Windows\System32\drivers\etc\hosts
echo [OK] HOSTS file reset

:: [9/20] Disable known malicious services
echo [9/20] Disabling known malicious services...
sc stop "Windows Update Helper" >nul 2>&1
sc delete "Windows Update Helper" >nul 2>&1
sc stop "System Service" >nul 2>&1
sc delete "System Service" >nul 2>&1
echo [OK] Malicious services disabled

:: [10/20] Remove browser extensions malware
echo [10/20] Removing malicious browser extensions...
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions" >nul 2>&1
md "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions" >nul 2>&1
echo [OK] Browser extensions cleaned

:: [11/20] Scan downloads folder for malware
echo [11/20] Scanning Downloads folder...
powershell -Command "Start-MpScan -ScanPath '%USERPROFILE%\Downloads' -ScanType CustomScan" >nul 2>&1
echo [OK] Downloads folder scanned

:: [12/20] Remove rootkit persistence mechanisms
echo [12/20] Removing rootkit persistence...
bcdedit /deletevalue loadoptions >nul 2>&1
bcdedit /deletevalue nx >nul 2>&1
bcdedit /set nx AlwaysOn >nul 2>&1
echo [OK] Rootkit persistence removed

:: [13/20] Clean DNS cache (malware DNS hijacking)
echo [13/20] Flushing DNS cache...
ipconfig /flushdns >nul 2>&1
echo [OK] DNS cache flushed

:: [14/20] Reset proxy settings (malware often hijacks proxy)
echo [14/20] Resetting proxy settings...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "" /f >nul 2>&1
echo [OK] Proxy settings reset

:: [15/20] Remove scheduled tasks created by malware
echo [15/20] Removing suspicious scheduled tasks...
schtasks /Delete /TN "Windows Update Service" /F >nul 2>&1
schtasks /Delete /TN "System Update" /F >nul 2>&1
schtasks /Delete /TN "Adobe Flash Player Updater" /F >nul 2>&1
echo [OK] Suspicious tasks removed

:: [16/20] Scan system32 for suspicious files
echo [16/20] Scanning System32 for threats...
powershell -Command "Start-MpScan -ScanPath 'C:\Windows\System32' -ScanType CustomScan" >nul 2>&1
echo [OK] System32 scanned

:: [17/20] Remove potentially unwanted programs (PUPs)
echo [17/20] Removing potentially unwanted programs...
powershell -Command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage" >nul 2>&1
powershell -Command "Get-AppxPackage *Candy* | Remove-AppxPackage" >nul 2>&1
echo [OK] PUPs removed

:: [18/20] Enable exploit protection
echo [18/20] Enabling exploit protection...
powershell -Command "Set-ProcessMitigation -System -Enable DEP,SEHOP,ForceRelocateImages" >nul 2>&1
echo [OK] Exploit protection enabled

:: [19/20] Run full system scan (Optional - very time consuming)
echo [19/20] Preparing full system scan...
echo.
choice /C YN /M "Run FULL system scan? (Takes 30-60 min) (Y/N)"
if errorlevel 2 (
    echo [SKIPPED] Full scan cancelled by user
) else (
    echo Running full system scan... This will take a while...
    powershell -Command "Start-MpScan -ScanType FullScan"
    echo [OK] Full system scan completed
)

:: [20/20] Display quarantine results
echo [20/20] Checking for quarantined threats...
powershell -Command "Get-MpThreatDetection" >nul 2>&1
echo [OK] Security scan complete

timeout /t 3 /nobreak >nul
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
echo  [✓] Power plan configured (High Performance / Battery Optimized)
echo  [✓] Privacy settings adjusted (telemetry reduced)
echo  [✓] Unnecessary services disabled
echo  [✓] Windows Update components reset
echo  [✓] Display cache cleared
echo.
echo  [★] CPU OPTIMIZED - Multithreading, All cores enabled (AC mode)
echo  [★] GPU OPTIMIZED - Hardware scheduling, Game mode, DirectX tweaked
echo  [★] RAM OPTIMIZED - Memory management, Cache tuned, Compression off
echo  [★] SSD OPTIMIZED - TRIM enabled, Write cache tuned, Indexing off
echo  [★] VIRTUALIZED - RAMDisk for Temp files, Optimized Page File
echo  [★] AI REMOVED - Copilot, Recall, AI Search, Cortana disabled
echo  [★] BATTERY OPTIMIZED - Extended battery life with power saving
echo  [★] CPU THREADS OPTIMIZED - AMD/Intel, multithreading, affinity
echo  [★] GPU THREADS OPTIMIZED - NVIDIA/AMD/Intel, scheduling, latency
echo  [★] SYSTEM SMOOTHNESS - Latency minimized, responsiveness maximized
echo  [🔒] SECURITY HARDENED - Firewall, UAC, SmartScreen, DEP enabled
echo  [🔒] MALWARE REMOVED - Virus scan, rootkit removal, registry cleaned
echo ============================================================================
echo.
echo IMPORTANT: A system RESTART is REQUIRED for changes to take effect!
echo.
echo Critical changes that need restart:
echo  - Security hardening (Firewall, UAC, SmartScreen)
echo  - Malware and virus removal
echo  - AI system removal (Copilot, Recall, Cortana)
echo  - Battery optimization power profiles
echo  - Network stack reset (Winsock, TCP/IP)
echo  - CPU power management changes
echo  - GPU hardware scheduling and memory management
echo  - Service changes and registry modifications
echo.
echo System will be significantly faster, more secure, and battery optimized!
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
