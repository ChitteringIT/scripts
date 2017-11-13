@echo off
rem setup script to copy synergy account to backup location daily. 
rem Modified to copy to one folder "daily" to allow for 1 day retention so as not to use too much disk space
rem DDP 27/10/2017
rem Modified to mirror live account to daily folder (using /purge), thereby removing excess files from the destination.
rem DDP 10/11/2017

for /f "Tokens=1-4 Delims=/ " %%i in ('date /t') do  set dt=%%i-%%j-%%k-%%l
for /f "Tokens=1 Delims=/ " %%i in ('date /t') do  set dtd=%%i
for /f "Tokens=1" %%i in ('time /t') do set tm=-%%i
set tm=%tm::=-%
set dtt=%dt%%tm%

set srcpath = s:\ITvision\Accounts\CHT\
set destpath = W:\SynergyBackup\daily\

rem Stop universe services to prevent locked files
net stop uvtelnet
net stop universe
net stop unirpc

rem Run main copy to backup folder
robocopy %srcpath% %destpath% /E /purge /NP /w:0 /r:0 /log:%destpath%%dtd%.log

rem Check difference between live and backup files
robocopy %srcpath% %destpath% /e /l /ns /njs /njh /ndl /fp /log:%destpath%reconcile-%dtd%.txt

rem Start universe services after copy
net start uvtelnet
net start universe
net start unirpc
