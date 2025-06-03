@echo off
setlocal enabledelayedexpansion

echo ========== StarDrive1 Combined Arms  Mod Extractor ==============
echo This will combine any chunked files you downloaded to a single
echo zip file, delete the current mod folder, extract the new version
echo and delete leftover files.
echo Note - this batch file should be copied to the Mods folder along
echo with all the files you downloaded from the release page in github
echo =================================================================
pause

REM === Check Windows version - need 10 or above for powershell
for /f "tokens=4-5 delims=. " %%i in ('ver') do (
    set "major=%%i"
    set "minor=%%j"
)

if not defined major (
    echo [ERROR] Could not detect Windows version.
    pause
    exit /b 1
)

if %major% LSS 10 (
    echo [ERROR] This extractor requires Windows 10 or higher.
    pause
    exit /b 1
)

REM === Check batch is in the Mods dir ===
for %%A in ("%cd%") do set CurrentFolder=%%~nxA
if /I not "!CurrentFolder!"=="Mods" (
    echo.
    echo [ERROR] This extractor must be run from inside the "Mods" folder.
    echo Please move all the files chuncks and this batch file to your game's Mods folder and run this script again.
    pause
    exit /b 1
)

REM === Set base name ===
set "BATCH_FILENAME=extract_combined_arms.bat"
set "BASE_CHUNK_NAME=CombinedArms"
set "MOD_NAME=Combined Arms"
set "OUTPUT_ZIP=Combined Arms.zip"

REM === Combine all chunks into a single zip file ===
echo Combining zip chunks into "%OUTPUT_ZIP%"...
copy /b ???-%BASE_CHUNK_NAME%*.zip "%OUTPUT_ZIP%" >nul

if errorlevel 1 (
    echo Failed to combine chunks.
    pause
    exit /b 1
)

REM === Delete old folder if it exists ===
if exist "%MOD_NAME%" (
    echo Deleting existing "%MOD_NAME%" folder...
    rmdir /s /q "%MOD_NAME%"
)

REM === Extract the combined zip ===
echo Extracting "%OUTPUT_ZIP%"...
powershell -command "Expand-Archive -LiteralPath '%OUTPUT_ZIP%' -DestinationPath . -Force"

if errorlevel 1 (
    echo Extraction failed.
    pause
    exit /b 1
)

REM === Delete the combined zip ===
echo Cleaning up temporary files...
del "%OUTPUT_ZIP%"
for %%F in (???-%BASE_CHUNK_NAME% *.zip) do (
    del "%%F"
)

echo Extraction complete.
pause

REM === Delete extraction batch ===
del %BATCH_FILENAME%