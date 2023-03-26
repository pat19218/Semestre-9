@echo off
if /i "%PROCESSOR_IDENTIFIER:~0,3%"=="x86" (..\CDROM_Installers\Disk1\InstData\Win32\VM\setup.exe) ELSE (..\CDROM_Installers\Disk1\InstData\Win64\VM\setup.exe)