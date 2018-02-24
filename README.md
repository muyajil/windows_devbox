# Linux Devbox for Team Darwin

## How to start

1. Install Docker for Windows: https://docs.docker.com/docker-for-windows/install/
2. Copy Dockerfile.in to Dockerfile and replace all stuff in [] with your info/preference
3. .\build.bat
4. Copy run.bat.in to run.bat and replace stuff in [] with your info/preference and choose one of the possibilities for the stuff in {}
5. .\run.bat
6. .\attach.bat

## Start on startup

1. Make a shortcut of start.bat
2. Start > Run
3. Execute shell:startup
4. Move the shortcut of start.bat here

## Make it practical

1. Install cmder: http://cmder.net/
2. Open cmder
    2.1. Open Settings (Windows + Alt + P)
        2.1.1 Startup
        2.2.2 Specified named Task: Choose Powershell
6. Copy attach.ps1 to cmder/config/profile.d/
7. Restart cmder
8. Now you should directly be connected to the linux shell

## Make it awesome

1. Install Powerline Fonts:
    1.1 Open Powershell
        1.1.2 `git clone https://github.com/powerline/fonts.git`
        1.1.3 `cd fonts`
        1.1.4 `.\install.ps1`
2. Open Cmder
    2.1 Open Settings (Windows + Alt + P)
    2.2 Main
        2.2.1 Main Console Font: Choose one from the new ones
        2.2.2 Alternative Font: Choose the same one as above