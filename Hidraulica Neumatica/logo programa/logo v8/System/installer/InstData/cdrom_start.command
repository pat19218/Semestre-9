#!/bin/sh

# Mac Shell Script
# Sucht den CD-ROM-Pfad und startet die Anwendung von der CD-ROM aus
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
  $cd_path/Mac/Application\(Mac\ 10.5\ or\ later\)/LOGOComfort.app/Contents/MacOS/LOGOComfort
else
  $cd_path/Mac/Application\(Mac\ 10.4\ or\ earlier\)/LOGOComfort.app/Contents/MacOS/LOGOComfort
fi
 