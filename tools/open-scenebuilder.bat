@echo off
set "SCENE_BUILDER=%LOCALAPPDATA%\SceneBuilder\SceneBuilder.exe"
if not exist "%SCENE_BUILDER%" set "SCENE_BUILDER=C:\Program Files\SceneBuilder\SceneBuilder.exe"

if exist "%SCENE_BUILDER%" (
    start "" "%SCENE_BUILDER%" "%~dp0..\src\com\example\MainView.fxml"
) else (
    echo [ERROR] SceneBuilder.exe not found!
    pause
)