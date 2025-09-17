@echo off
setlocal enabledelayedexpansion
title UnattendedWinstall v1.2.0 By Project
echo ============================================
echo UnattendedWinstall v1.2.0 By Project
echo ============================================

:: Ensure admin rights
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo This script must be run as administrator.
    pause
    exit /b
)

:: Define temp file path
set "TEMPFILE=%TEMP%\thorium_installer.exe"
set "FTA_EXE=%TEMP%\SetUserFTA.exe"

:: Use PowerShell ONLY to get the latest Thorium GitHub release URL
for /f "tokens=* usebackq" %%i in (`powershell -NoProfile -Command ^
    "$releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/Alex313031/Thorium-Win/releases/latest'; ^
    $asset = $releases.assets | Where-Object { $_.name -like '*AVX2_mini_installer.exe' } | Select-Object -First 1; ^
    $asset.browser_download_url"`) do (
    set "DLURL=%%i"
)

:: Check if URL was obtained
if not defined DLURL (
    echo Failed to get Thorium download URL.
    pause
    exit /b
)

echo Downloading latest Thorium AVX2 installer...
powershell -NoProfile -Command "Invoke-WebRequest -Uri '%DLURL%' -OutFile '%TEMPFILE%'"

:: Install silently
echo Installing Thorium...
start /wait "" "%TEMPFILE%" --silent --do-not-launch-chrome

:: Cleanup Thorium installer
del /f /q "%TEMPFILE%"

:: Download SetUserFTA tool to set default browser silently
echo Downloading SetUserFTA tool...
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/clechasseur/setuserfta/releases/latest/download/SetUserFTA.exe' -OutFile '%FTA_EXE%'"

if exist "%FTA_EXE%" (
    echo Setting Thorium as the default browser...
    :: Note: Confirm these ProgIDs if needed, common ones for Chromium-based browsers:
    "%FTA_EXE%" .html ThoriumHTML
    "%FTA_EXE%" .htm ThoriumHTML
    "%FTA_EXE%" http ThoriumURL
    "%FTA_EXE%" https ThoriumURL

    :: Cleanup SetUserFTA
    del /f /q "%FTA_EXE%"
) else (
    echo Failed to download SetUserFTA.exe, skipping default browser setting.
)

:: Install Nilesoft Shell using winget
echo Installing Nilesoft Shell using winget...
winget install nilesoft.shell --silent --accept-source-agreements --accept-package-agreements

:: Open Default Apps settings just in case
echo Opening default apps settings...
start "" "ms-settings:defaultapps"

:: Reboot prompt
echo.
set /p userinput=Do you want to reboot the system now? (Y/N): 
if /i "%userinput%"=="Y" (
    echo Rebooting...
    shutdown /r /t 5
) else (
    echo Reboot skipped. Restart manually later.
)

:: Done message
echo.
echo ====================================================
echo ============== UNATTENDEDWINSTALL v1.2.0 ===========
echo ==================== BY PROJECT ====================
echo ====================================================
pause
exit /b
