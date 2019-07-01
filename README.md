# kali_setup
Kali Setup script

Update and upgrade Kali before running the script.  On fresh installs there are a few programs that have post install scripts that don't work well with unattended upgrades.

```
apt update && apt upgrade -y

curl -L --silent https://bit.ly/320yIij | bash
```