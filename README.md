# Linux Devbox for

## How to start

* Install Docker for Windows: https://docs.docker.com/docker-for-windows/install/
* Run `install.ps1` to install devbox_manager
* Run `devbox help` in Powershell

## Make it awesome

* Install Powerline Fonts:
    * Open Powershell
        * `git clone https://github.com/powerline/fonts.git`
        * `cd fonts`
        * `.\install.ps1`
* Open Cmder
    * Open Settings (Windows + Alt + P)
    * Main
        * Main Console Font: Choose one from the new ones
        * Alternative Font: Choose the same one as above

## Troubleshooting:

* My repositories are not mounted:
    * In the Docker settings check if the drive is shared with docker
    * If you changed your password you need to reauthenticate
