REM Windows 11 Optimization Script - Remove Animations, AI Features, and Improve Performance

REM Disable Transparency Effects
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f

REM Disable Animations in Windows (System-wide)
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f

REM Disable Taskbar Animations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f

REM Disable Minimize/Maximize Animations
reg add "HKCU\Control Panel\Desktop" /v MinAnimate /t REG_SZ /d 0 /f

REM Set Visual Effects to "Best performance"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

REM Further disable specific animation/visual effects
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v MenuAnimation /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v ComboBoxAnimation /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v ListBoxSmoothScrolling /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v CursorShadow /t REG_SZ /d 0 /f

REM Disable Aero Peek
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f

REM Disable Window Shadows
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableWindowShadow /t REG_DWORD /d 0 /f

REM Optimize Processor Scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f

REM Disable background apps by removing all UWP apps that are not frameworks.
echo Disabling background apps by removing UWP packages. This may take a while.
powershell -Command "Get-AppxPackage | Where-Object {$_.IsFramework -eq $false -and $_.Name -notlike 'Microsoft.WindowsStore'} | Remove-AppxPackage"

REM Disable AI-related features
echo Disabling AI-related features.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

REM Restart Explorer to apply all changes
echo Applying changes by restarting Windows Explorer.
taskkill /f /im explorer.exe
start explorer.exe

echo Windows 11 has been optimized. All animations, visual effects, and AI features have been disabled for maximum performance.
pause
