@echo off
setlocal enabledelayedexpansion

set "ROOT=%~dp0"
cd /d "%ROOT%"

echo [BUILD] Compiling JavaFX project...

set "JAVAC_CMD=javac"
if defined JAVA_HOME (
    if exist "%JAVA_HOME%\bin\javac.exe" set "JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"
)

where %JAVAC_CMD% >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compiler javac not found!
    echo Please make sure JDK 17 or higher is installed and in PATH or JAVA_HOME.
    exit /b 1
)

if not exist "bin" mkdir "bin"
if not exist "bin\com\example" mkdir "bin\com\example"
if not exist "bin\assets" mkdir "bin\assets"

dir /s /b "%ROOT%src\*.java" > "%ROOT%sources.txt"

echo [BUILD] Compiling Java source files...
"%JAVAC_CMD%" -encoding UTF-8 --module-path "%ROOT%lib\javafx-sdk\lib" --add-modules javafx.controls,javafx.fxml -d "%ROOT%bin" @"%ROOT%sources.txt"
set "COMPILE_ERR=%ERRORLEVEL%"
if exist "%ROOT%sources.txt" del "%ROOT%sources.txt"

if %COMPILE_ERR% NEQ 0 (
    echo [ERROR] Java compilation failed!
    exit /b %COMPILE_ERR%
)

echo [BUILD] Copying FXML, CSS and assets to bin...
copy /y "%ROOT%src\com\example\*.fxml" "%ROOT%bin\com\example\" >nul
copy /y "%ROOT%src\com\example\*.css" "%ROOT%bin\com\example\" >nul
if exist "%ROOT%src\assets\*" (
    copy /y "%ROOT%src\assets\*" "%ROOT%bin\assets\" >nul
)

echo [BUILD] Success! Output placed in bin directory.
exit /b 0