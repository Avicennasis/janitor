#!/bin/bash

#Echo what we are doing
echo "Getting file sizes real quick"

#Get the file size of everything older than 30 days and strip the filenames, then dump that to a file
find /cygdrive/d/Mil-Main/TEMP/* -mtime +30 -exec du -bs {} \; | sed s/"\/cygdrive.*"// > /cygdrive/d/Mil-Main/TEMP/TEMPSIZE 

#Math to add all the filesizes into a new total
awk '{x+=$0}END{print x}' /cygdrive/d/Mil-Main/TEMP/TEMPSIZE > /cygdrive/d/Mil-Main/TEMP/TEMPSIZETOTAL 

#Make the directory for janitor logs if it doesn't exist yet
if [ ! -d "${HOME}/logs/janitor" ]; then
	echo "Janitor directory not found! Creating it now."
	mkdir -p "${HOME}/logs/janitor"
fi

#And make a dummy file for math to avoid first-run errors
if [ ! -f "${HOME}/logs/janitor/tempsizeinbytes.txt" ]; then
	echo "Janitor log file not found! Creating a dummy file real quick"
	echo 0 > "${HOME}/logs/janitor/tempsizeinbytes.txt"
fi

#Combine that total with our logs total
cat /cygdrive/d/Mil-Main/TEMP/TEMPSIZETOTAL "${HOME}/logs/janitor/tempsizeinbytes.txt" > /cygdrive/d/Mil-Main/TEMP/TEMPSIZEFINALTOTAL 

#Copy the complete total (logs + current operation) to the log file
awk '{x+=$0}END{print x}' /cygdrive/d/Mil-Main/TEMP/TEMPSIZEFINALTOTAL > "${HOME}/logs/janitor/tempsizeinbytes.txt"

#Remove our temp files
rm /cygdrive/d/Mil-Main/TEMP/TEMPSIZE
rm /cygdrive/d/Mil-Main/TEMP/TEMPSIZETOTAL
rm /cygdrive/d/Mil-Main/TEMP/TEMPSIZEFINALTOTAL

#Make the directory for janitor logs if it doesn't exist yet
if [ ! -d "${HOME}/logs/janitor/$(date -u +%Y/%m/)" ]; then
	echo "Janitor current year/month folder not found! Creating it now"
	mkdir -p "${HOME}/logs/janitor/$(date -u +%Y/%m/)"
fi

#Echo what we are doing
echo "Logging files to be deleted"

#Save deleted filenames to log file
find /cygdrive/d/Mil-Main/TEMP/* -mtime +30 -exec du -bs {} \; | sed s/".*\/cygdrive\/d\/Mil-Main\/TEMP\/"/""/g >> "${HOME}/logs/janitor/$(date -u +%Y/%m/)/deleted.txt"

#Echo what we are doing
echo "Deleting files older than 30 days"

#Finally, delete the selected old files
find /cygdrive/d/Mil-Main/TEMP/* -mtime +30 -exec rm {} \;

#Echo what we are doing
echo "Done!"
