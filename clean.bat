@echo off
setlocal

set "ROOT=%~dp0"
cd /d "%ROOT%"

if exist "bin" (
    echo [CLEAN] Cleaning bin folder...
    rmdir /s /q "bin"
    echo [CLEAN] Done.
) else (
    echo [CLEAN] Directory bin is already clean.
)