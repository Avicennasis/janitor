# janitor

Janitor is a simple script that deletes everything in a given temp directory that is older than X days. 

It also keeps a running log of the total bytes deleted, and a month-by-month log of the filenames deleted.

The default directory is "/cygdrive/d/Mil-Main/TEMP/*" which of course should be updated to whatever directory you want to clean. 
The default time to delete after is 30 days (specified by "-mtime +30") 
The default filesize log is at "${HOME}/logs/janitor/tempsizeinbytes.txt"
The default filename log folders are at "${HOME}/logs/janitor/$(date -u +%Y/%m/)" (e.g. for June 2016 it will create ~/logs/janitor/2016/06)
The default filename log file is at "${HOME}/logs/janitor/$(date -u +%Y/%m/)/deleted.txt"
