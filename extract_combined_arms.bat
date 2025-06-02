@echo off
setlocal enabledelayedexpansion

REM === Check batch is in the Mods dir ===
for %%A in ("%cd%") do set CurrentFolder=%%~nx
if /I not "!CurrentFolder!"=="Mods" (
    echo.
    echo [ERROR] This installer must be run from inside the "Mods" folder.
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

REM === Delete the chunked zip parts ===
for %%F in (???-%BASE_CHUNK_NAME% *.zip) do (
    del "%%F"
)

REM === Delete extraction batch ===
del %BATCH_FILENAME%

echo Extraction complete.
pause