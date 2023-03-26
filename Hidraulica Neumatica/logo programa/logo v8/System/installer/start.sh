#!/bin/sh

SUCCESS=0
    

# CD-ROM-Pfad ueber den Befehl mount ermitteln
#cd_path=$(mount | grep "iso9660" | awk '{ print $3; }')

#echo $cd_path

#$cd_path/Linux/Setup.bin


cd_path=$(mount | grep "cdfss" | awk '{ print $3; }')

echo $cd_path/CDROM_Installers/Disk1/InstData/Linux/VM/Setup.bin

# Installer starten
$cd_path/CDROM_Installers/Disk1/InstData/Linux/VM/Setup.bin
