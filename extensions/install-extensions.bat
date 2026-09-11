@echo off
setlocal enabledelayedexpansion

set "EXT_DIR=%~dp0"
cd /d "%EXT_DIR%.."

echo ========================================================
echo   Installing Java and JavaFX extensions for VSCodium
echo ========================================================

set "CLI_CMD="
where codium >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set "CLI_CMD=codium"
) else (
    where code >nul 2>&1
    if %ERRORLEVEL% EQU 0 set "CLI_CMD=code"
)

if "%CLI_CMD%"=="" (
    echo [WARNING] Neither codium nor code found in PATH.
    echo Install extensions manually via Extensions (Ctrl+Shift+X) -^> ... -^> Install from VSIX...
    pause
    exit /b 1
)

echo [INFO] Using command: %CLI_CMD%
echo.
echo [1/4] Installing Java Extension Pack (Language Server, Debugger)...
call %CLI_CMD% --install-extension vscjava.vscode-java-pack

echo.
echo [2/4] Installing JavaFX Scene Builder Extension...
if exist "extensions\vscode-javafx-scenebuilder-1.0.0.vsix" (
    call %CLI_CMD% --install-extension "extensions\vscode-javafx-scenebuilder-1.0.0.vsix"
) else (
    call %CLI_CMD% --install-extension gluon-community.vscode-javafx-scenebuilder
)

echo [3/4] Installing JavaFX Scene Builder & Controller Syncer Pro Extension...
if exist "extensions\vscode-javafx-sync-1.1.0.vsix" (
    call %CLI_CMD% --install-extension "extensions\vscode-javafx-sync-1.1.0.vsix" --force
) else if exist "extensions\vscode-javafx-sync-1.0.0.vsix" (
    call %CLI_CMD% --install-extension "extensions\vscode-javafx-sync-1.0.0.vsix" --force
)

echo.
echo ========================================================
echo   All extensions installed successfully!
echo   Restart VSCodium and open the workspace:
echo   javafx-project.code-workspace
echo ========================================================
pause