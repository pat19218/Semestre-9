#!/bin/sh

# Mac Shell Script
# Sucht den CD-ROM-Pfad und startet die Installation von der CD-ROM aus
# CD muss den String LOGOCOMFORT im CD-Namen enthalten

echo "Startscript!"

cd_path=$(mount | grep "LOGOCOMFORT" | awk '{ print $3; }')

currversion=$(sw_vers -productVersion)
echo "current os version: "$currversion

firstPoint=$(echo "$currversion" | awk '{print index('$currversion',".")}')
rightVersion=$(echo ${currversion: firstPoint})
secondPoint=$(echo "$currversion" | awk '{print index('$rightVersion',".")}')
midVersion=$(echo ${currversion: firstPoint: secondPoint-1})
leftVersion=$(echo ${currversion: 0: firstPoint-1})

if [ "$leftVersion" -eq 10 ] && [ "$midVersion" -gt 4 ] || [ "$leftVersion" -gt 10 ]
then
  echo $cd_path/CDROM_Installers/Disk1/InstData/MacOSX/Setup.app
  $cd_path/CDROM_Installers/Disk1/InstData/MacOSX/Setup.app/Contents/MacOS/Setup
else
  echo $cd_path/CDROM_Installers/Disk1/InstData/MacOSX10.4/Disk1/InstData/Setup.app
  $cd_path/CDROM_Installers/Disk1/InstData/MacOSX10.4/Disk1/InstData/Setup.app/Contents/MacOS/Setup
fi