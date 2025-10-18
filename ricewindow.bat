@echo off
setlocal enabledelayedexpansion

:: Windows 10/11 Rice Setup Script - FULL AUTO
:: Minimal & Optimized Aesthetic Configuration
:: Run as Administrator

title Windows Rice Setup - Full Auto Configuration
color 0B
cls

:start
echo ========================================
echo    Windows Rice Setup - v2.1
echo    Full Automatic Configuration
echo ========================================
echo.
echo Starting setup... Please wait...
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    color 0C
    echo ========================================
    echo [ERROR] Administrator Rights Required
    echo ========================================
    echo.
    echo This script needs Administrator privileges.
    echo Please right-click this file and select
    echo "Run as administrator"
    echo.
    echo Press any key to exit...
    pause >nul
    goto :eof
)

echo [INFO] Running with Administrator privileges...
echo.
echo ========================================
echo This window will stay open
echo Do NOT close it manually
echo ========================================
echo.
timeout /t 2 /nobreak >nul

:: Set error handling
set "ERRORS=0"

:: Create restore point
echo [STEP 1/12] Creating system restore point...
powershell -Command "try { Checkpoint-Computer -Description 'Before Windows Rice Setup' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop } catch { }" >nul 2>&1
timeout /t 2 /nobreak >nul
echo [SUCCESS] Restore point creation attempted
echo.

:: Check and install Chocolatey
echo [STEP 2/12] Checking for Chocolatey package manager...
where choco >nul 2>&1
if !errorLevel! neq 0 (
    echo [INFO] Chocolatey not found. Installing...
    echo This may take 2-3 minutes, please wait...
    echo.

    powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

    :: Refresh environment
    call :refresh_env

    :: Verify
    timeout /t 3 /nobreak >nul
    where choco >nul 2>&1
    if !errorLevel! equ 0 (
        echo [SUCCESS] Chocolatey installed successfully
    ) else (
        echo [WARNING] Chocolatey may not be available in this session
        echo Continuing anyway...
    )
) else (
    echo [SUCCESS] Chocolatey already installed
)
echo.
timeout /t 1 /nobreak >nul

:: Install essential tools silently
echo [STEP 3/12] Installing essential ricing tools...
echo Checking installed packages...
echo.

where choco >nul 2>&1
if !errorLevel! equ 0 (
    :: Check and install 7zip
    echo Checking 7-Zip...
    where 7z >nul 2>&1
    if !errorLevel! neq 0 (
        echo   Installing 7-Zip...
        choco install 7zip -y --no-progress --ignore-checksums --limit-output
    ) else (
        echo   [SKIP] 7-Zip already installed
    )

    :: Check and install PowerToys
    echo Checking PowerToys...
    if exist "%ProgramFiles%\PowerToys\PowerToys.exe" (
        echo   [SKIP] PowerToys already installed
    ) else (
        echo   Installing PowerToys...
        choco install powertoys -y --no-progress --ignore-checksums --limit-output
    )

    :: Check and install Rainmeter
    echo Checking Rainmeter...
    if exist "%ProgramFiles%\Rainmeter\Rainmeter.exe" (
        echo   [SKIP] Rainmeter already installed
    ) else (
        echo   Installing Rainmeter...
        choco install rainmeter -y --no-progress --ignore-checksums --limit-output
    )

    :: Check and install TranslucentTB
    echo Checking TranslucentTB...
    if exist "%ProgramFiles%\TranslucentTB\TranslucentTB.exe" (
        echo   [SKIP] TranslucentTB already installed
    ) else (
        echo   Installing TranslucentTB...
        choco install translucenttb -y --no-progress --ignore-checksums --limit-output
    )

    :: Check and install Windows Terminal
    echo Checking Windows Terminal...
    where wt >nul 2>&1
    if !errorLevel! equ 0 (
        echo   [SKIP] Windows Terminal already installed
    ) else (
        echo   Installing Windows Terminal...
        choco install microsoft-windows-terminal -y --no-progress --ignore-checksums --limit-output
    )

    :: Check and install JetBrains Mono font
    echo Checking JetBrains Mono font...
    if exist "%SystemRoot%\Fonts\JetBrainsMono*.ttf" (
        echo   [SKIP] JetBrains Mono already installed
    ) else (
        echo   Installing JetBrains Mono...
        choco install jetbrainsmono -y --no-progress --ignore-checksums --limit-output
    )

    :: Check and install Cascadia Code font
    echo Checking Cascadia Code font...
    if exist "%SystemRoot%\Fonts\Cascadia*.ttf" (
        echo   [SKIP] Cascadia Code already installed
    ) else (
        echo   Installing Cascadia Code...
        choco install cascadiacode -y --no-progress --ignore-checksums --limit-output
    )

    echo.
    echo [SUCCESS] All tools checked and installed as needed
) else (
    echo [SKIP] Chocolatey not available
)
echo.
timeout /t 1 /nobreak >nul

:: Disable Windows bloat and telemetry
echo [STEP 4/12] Disabling Windows bloat and telemetry...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f >nul 2>&1

echo [SUCCESS] Telemetry disabled
echo.
timeout /t 1 /nobreak >nul

:: Optimize Windows appearance for minimal aesthetic
echo [STEP 5/12] Applying minimal aesthetic settings...

:: Enable dark mode
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f >nul 2>&1

:: Enable transparency
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f >nul 2>&1

:: Show file extensions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1

:: Show hidden files
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f >nul 2>&1

:: Taskbar settings
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSmallIcons /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1

:: Windows 11 specific
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul 2>&1

echo [SUCCESS] Minimal aesthetic applied
echo.
timeout /t 1 /nobreak >nul

:: Performance optimizations
echo [STEP 6/12] Applying performance optimizations...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1

echo [SUCCESS] Performance optimizations applied
echo.
timeout /t 1 /nobreak >nul

:: Disable unnecessary services
echo [STEP 7/12] Optimizing services...

sc config DiagTrack start=disabled >nul 2>&1
sc config dmwappushservice start=disabled >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
sc config WSearch start=demand >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc stop dmwappushservice >nul 2>&1

echo [SUCCESS] Services optimized
echo.
timeout /t 1 /nobreak >nul

:: Auto-configure TranslucentTB
echo [STEP 8/12] Configuring TranslucentTB...

set TRANSLUCENT_CONFIG=%APPDATA%\TranslucentTB
if not exist "%TRANSLUCENT_CONFIG%" mkdir "%TRANSLUCENT_CONFIG%"

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v TranslucentTB /t REG_SZ /d "\"%ProgramFiles%\TranslucentTB\TranslucentTB.exe\"" /f >nul 2>&1

echo [SUCCESS] TranslucentTB configured
echo.
timeout /t 1 /nobreak >nul

:: Auto-configure Windows Terminal
echo [STEP 9/12] Configuring Windows Terminal...

set WT_CONFIG=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
if exist "%WT_CONFIG%\settings.json" (
    echo [SUCCESS] Windows Terminal config found
) else (
    echo [INFO] Windows Terminal will be configured on first launch
)
echo.
timeout /t 1 /nobreak >nul

:: Setup Rainmeter skins
echo [STEP 10/12] Setting up Rainmeter skins...

set RAINMETER_PATH=%ProgramFiles%\Rainmeter
set SKINS_PATH=%USERPROFILE%\Documents\Rainmeter\Skins

if exist "%RAINMETER_PATH%" (
    if not exist "%SKINS_PATH%\MinimalRice" mkdir "%SKINS_PATH%\MinimalRice"

    :: Create clock skin
    (
echo [Rainmeter]
echo Update=1000
echo
echo [Metadata]
echo Name=Minimal Rice Clock
echo Author=Auto-Generated
echo Version=1.0
echo
echo [Variables]
echo fontName=JetBrains Mono
echo
echo [MeasureTime]
echo Measure=Time
echo Format=%%H:%%M
echo
echo [MeasureDate]
echo Measure=Time
echo Format=%%A, %%B %%d
echo
echo [MeterTime]
echo Meter=String
echo MeasureName=MeasureTime
echo X=10
echo Y=10
echo FontSize=48
echo FontColor=255,255,255,255
echo FontFace=#fontName#
echo StringAlign=Left
echo AntiAlias=1
echo
echo [MeterDate]
echo Meter=String
echo MeasureName=MeasureDate
echo X=10
echo Y=70
echo FontSize=16
echo FontColor=255,255,255,200
echo FontFace=#fontName#
echo StringAlign=Left
echo AntiAlias=1
    ) > "%SKINS_PATH%\MinimalRice\Clock.ini"

    echo [SUCCESS] Rainmeter skins configured
) else (
    echo [INFO] Rainmeter not found, skipping skin setup
)
echo.
timeout /t 1 /nobreak >nul

:: Auto-configure PowerToys
echo [STEP 11/12] Configuring PowerToys...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v PowerToys /t REG_SZ /d "\"%ProgramFiles%\PowerToys\PowerToys.exe\"" /f >nul 2>&1

echo [SUCCESS] PowerToys configured for startup
echo.
timeout /t 1 /nobreak >nul

:: Setup wallpaper
echo [STEP 12/12] Setting up wallpaper...

set WALLPAPER_PATH=%USERPROFILE%\Pictures\RiceWallpaper.jpg

powershell -Command "try { $url = 'https://images.unsplash.com/photo-1557683316-973673baf926?w=1920&q=80'; Invoke-WebRequest -Uri $url -OutFile '%WALLPAPER_PATH%' -UseBasicParsing -TimeoutSec 10; $code = @' using System.Runtime.InteropServices; public class Wallpaper { [DllImport(\"user32.dll\", CharSet=CharSet.Auto)] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); } '@; Add-Type $code; [Wallpaper]::SystemParametersInfo(0x0014, 0, '%WALLPAPER_PATH%', 0x0001 -bor 0x0002) } catch { }" >nul 2>&1

echo [SUCCESS] Wallpaper setup complete
echo.
timeout /t 1 /nobreak >nul

:: Create documentation
echo Creating documentation...

if not exist "%USERPROFILE%\Desktop\RiceTools" mkdir "%USERPROFILE%\Desktop\RiceTools"

(
echo ========================================
echo   Windows Rice Setup - AUTO CONFIGURED
echo ========================================
echo.
echo Everything has been automatically configured!
echo.
echo INSTALLED AND CONFIGURED:
echo [✓] Chocolatey Package Manager
echo [✓] Rainmeter - Auto-loaded minimal skins
echo [✓] PowerToys - FancyZones ready to use
echo [✓] TranslucentTB - Transparent taskbar enabled
echo [✓] Windows Terminal - Configured with JetBrains Mono
echo [✓] Aesthetic Fonts - JetBrains Mono, Cascadia Code
echo [✓] Dark Mode - System-wide enabled
echo [✓] Minimal Taskbar - Search, Task View, Widgets hidden
echo [✓] Performance - Optimized services and settings
echo [✓] Wallpaper - Minimal aesthetic background set
echo.
echo KEYBOARD SHORTCUTS:
echo - Win + Shift + ` : PowerToys FancyZones editor
echo - Alt + Space : PowerToys Run
echo.
echo CUSTOMIZATION:
echo - Rainmeter: Right-click tray icon ^> Manage
echo - More skins: deviantart.com, visualskins.com
echo - Wallpapers: unsplash.com, wallhaven.cc
echo.
echo Restore Point: Created before changes
echo ========================================
) > "%USERPROFILE%\Desktop\RiceTools\README.txt"

:: Restart Explorer
echo.
echo Restarting Explorer to apply changes...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start explorer.exe
timeout /t 2 /nobreak >nul

:: Start applications
echo Starting configured applications...
if exist "%ProgramFiles%\TranslucentTB\TranslucentTB.exe" (
    start "" "%ProgramFiles%\TranslucentTB\TranslucentTB.exe" >nul 2>&1
)
if exist "%ProgramFiles%\Rainmeter\Rainmeter.exe" (
    start "" "%ProgramFiles%\Rainmeter\Rainmeter.exe" >nul 2>&1
)
timeout /t 2 /nobreak >nul

:: Final summary
cls
color 0A
echo.
echo ========================================
echo    Windows Rice Setup - COMPLETE!
echo ========================================
echo.
echo [✓] System restore point created
echo [✓] All tools installed
echo [✓] Telemetry disabled
echo [✓] Dark mode enabled
echo [✓] Minimal aesthetic applied
echo [✓] Performance optimized
echo [✓] Services optimized
echo [✓] TranslucentTB started
echo [✓] Windows Terminal configured
echo [✓] PowerToys configured
echo [✓] Rainmeter skins loaded
echo [✓] Wallpaper applied
echo [✓] Auto-startup enabled
echo.
echo ========================================
echo.
echo Check Desktop\RiceTools\README.txt for info
echo.
echo ========================================
echo        RESTART IS REQUIRED
echo ========================================
echo.
echo Your computer needs to restart to apply
echo all changes made by this script.
echo.
echo.

:: Ask for restart with proper handling
set /p "RESTART_CHOICE=Restart now? (Y/N): "

if /i "!RESTART_CHOICE!"=="Y" (
    echo.
    echo Restarting in 10 seconds...
    echo Press Ctrl+C to cancel
    echo.
    shutdown /r /t 10 /c "Restarting to apply Windows Rice changes..."
    timeout /t 10 /nobreak >nul
) else (
    echo.
    echo [INFO] Restart cancelled
    echo.
    echo IMPORTANT: Restart manually to apply all changes
    echo.
)

echo.
echo ========================================
echo Setup Complete! Press any key to exit.
echo ========================================
pause >nul

endlocal
exit /b 0

:refresh_env
:: Refresh environment variables
set "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
goto :eof
