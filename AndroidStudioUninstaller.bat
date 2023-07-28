@echo off
REM This script will completely remove Android Studio from Windows
REM It will ask for admin privilege before running

REM Check for admin privilege
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run
) else (
    goto :getadmin
)

:getadmin
REM Get admin privilege
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B

:run

:menu
REM Clear the screen
cls

REM Display menu options
echo Choose an option:
echo [1] Clean Uninstall - Uninstalls Android Studio and deletes all files.
echo [2] Delete Projects - Deletes project files in the default location.
echo [3] Delete AVDs - Deletes AVD images.
echo [4] Support Developer - Opens a link to support the developer.
set /p option=Enter your choice: 

if %option%==1 goto :clean_uninstall
if %option%==2 goto :delete_projects_only
if %option%==3 goto :delete_avds
if %option%==4 goto :support_developer

:clean_uninstall
REM Run the uninstaller
echo Uninstalling Android Studio...
wmic product where "name like 'Android Studio%%'" call uninstall /nointeractive

REM Remove the Android Studio files
echo Removing Android Studio files...
del /f /s /q "%USERPROFILE%\.android"
del /f /s /q "%USERPROFILE%\.AndroidStudio*"
del /f /s /q "%USERPROFILE%\.gradle"
del /f /s /q "%USERPROFILE%\.m2"
rd /s /q "%USERPROFILE%\.android"
rd /s /q "%USERPROFILE%\.AndroidStudio*"
rd /s /q "%USERPROFILE%\.gradle"
rd /s /q "%USERPROFILE%\.m2"

del /f /s /q "%APPDATA%\JetBrains"
rd /s /q "%APPDATA%\JetBrains"

del /f /s /q "%LOCALAPPDATA%\Google\AndroidStudio*"
del /f /s /q "%APPDATA%\Google\AndroidStudio*"
rd /s /q "%LOCALAPPDATA%\Google\AndroidStudio*"
rd /s /q "%APPDATA%\Google\AndroidStudio*"

del /f /s /q "C:\Program Files\Android"
rd /s /q "C:\Program Files\Android"

REM Remove SDK
echo Removing SDK files...
del /f /s /q "%LOCALAPPDATA%\Android"
rd /s /q "%LOCALAPPDATA%\Android"

REM Delete Android Studio projects
echo Do you want to delete your Android Studio projects? [Y/N]
set /p choice=
if /i "%choice%"=="Y" (
    echo Deleting Android Studio projects...
    del /f /s /q "%USERPROFILE%\AndroidStudioProjects"
    rd /s /q "%USERPROFILE%\AndroidStudioProjects"
) else (
    echo Skipping Android Studio projects deletion...
)

echo Android Studio has been completely removed from your system.
pause

goto :end

:delete_projects_only
REM Delete Android Studio projects only
echo Deleting Android Studio projects...
del /f /s /q "%USERPROFILE%\AndroidStudioProjects"
rd /s /q "%USERPROFILE%\AndroidStudioProjects"

goto :menu

:delete_avds
REM Delete AVD images only
echo Deleting AVD images...
del /f /s /q "%USERPROFILE%\.android\avd"
echo AVD images deleted.
timeout /t 2 >nul

goto :menu

:support_developer
REM Open link in default browser to support developer
start "" "https://www.example.com/support-developer"

:end

