#!/bin/sh

SUCCESS=0
    

# CD-ROM-Pfad ueber den Befehl mount ermitteln
#cd_path=$(mount | grep "iso9660" | awk '{ print $3; }')

#echo $cd_path

#$cd_path/Linux/Setup.bin


cd_path=$(mount | grep "cdfss" | awk '{ print $3; }')
if ["$cd_path" = ""]
then
cd_path=$(mount | grep "LOGOCOMFORT" | awk '{ print $3; }')
fi
echo $cd_path/CDROM_Installers/Disk1/InstData/Linux/VM/Setup.bin
os_bit=$(uname -a | awk '{print $14}')
echo $os_bit|grep "86\$"
if [ $? -eq 0 ]
then
	echo "the os version is 32 bit"
	chmod 777 $cd_path/CDROM_Installers/Disk1/InstData/Linux32/VM/Setup.bin
	$cd_path/CDROM_Installers/Disk1/InstData/Linux32/VM/Setup.bin
else
	echo "the os version is 64 bit"
	echo "`pwd`"
	chmod 777 $cd_path/CDROM_Installers/Disk1/InstData/Linux64/VM/Setup.bin
	$cd_path/CDROM_Installers/Disk1/InstData/Linux64/VM/Setup.bin
fi
# Installer starten
