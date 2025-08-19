@echo off
set FAILED_ARK_BUILD=0
"%~dp0dependencies/wit/wit" extract "%~dp0\iso" "%~dp0\_build\wii"
copy "%~dp0\dependencies\patch\main.dol" "%~dp0\_build\wii\sys"
copy "%~dp0\dependencies\patch\setup.txt" "%~dp0\_build\wii"

echo:
echo:Temporarily moving Xbox and PS3 files out of the ark path to reduce final ARK size
@%SystemRoot%\System32\robocopy.exe "%~dp0_ark" "%~dp0_temp\_ark" *.milo_xbox /S /MOVE /XD "%~dp0_temp\_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_ark" "%~dp0_temp\_ark" *.png_xbox /S /MOVE /XD "%~dp0_temp\_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_ark" "%~dp0_temp\_ark" *.bmp_xbox /S /MOVE /XD "%~dp0_temp\_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_ark" "%~dp0_temp\_ark" *.milo_ps3 /S /MOVE /XD "%~dp0_temp\_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_ark" "%~dp0_temp\_ark" *.png_ps3 /S /MOVE /XD "%~dp0_temp\_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_ark" "%~dp0_temp\_ark" *.bmp_ps3 /S /MOVE /XD "%~dp0_temp\_ark" /NDL /NFL /NJH /NJS /R:0 >nul

rem Move the folder "songs_wii" into "_ark" and rename it to "songs"
echo Temporarily moving Wii songs folder into ark
move "%~dp0\_songs\songs_wii" "%~dp0\_ark\songs"

copy "%~dp0\_build\wii_rebuild_file\main_wii.hdr" "%~dp0\_build\wii\files\gen"
del  "%~dp0\_build\wii\files\gen\main_wii_2.ark"
"%~dp0dependencies/arkhelper" patchcreator -a "%~dp0\_ark" -o "%~dp0\_build\wii\files\gen" "%~dp0\_build\wii\files\gen\main_wii.hdr" "%~dp0\dependencies\patch\main.dol" 
move "%~dp0\_build\wii\files\gen\gen\main_wii.hdr" "%~dp0\_build\wii\files\gen"
move "%~dp0\_build\wii\files\gen\gen\main_wii_2.ark" "%~dp0\_build\wii\files\gen"
rmdir "%~dp0\_build\wii\files\gen\gen"

echo:
echo:Moving back Xbox and PS3 files
@%SystemRoot%\System32\robocopy.exe "%~dp0_temp\_ark" "%~dp0_ark" *.milo_xbox /S /MOVE /XD "%~dp0_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_temp\_ark" "%~dp0_ark" *.png_xbox /S /MOVE /XD "%~dp0_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_temp\_ark" "%~dp0_ark" *.bmp_xbox /S /MOVE /XD "%~dp0_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_temp\_ark" "%~dp0_ark" *.milo_ps3 /S /MOVE /XD "%~dp0_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_temp\_ark" "%~dp0_ark" *.png_ps3 /S /MOVE /XD "%~dp0_ark" /NDL /NFL /NJH /NJS /R:0 >nul
@%SystemRoot%\System32\robocopy.exe "%~dp0_temp\_ark" "%~dp0_ark" *.bmp_ps3 /S /MOVE /XD "%~dp0_ark" /NDL /NFL /NJH /NJS /R:0 >nul
rd _temp

rem Move the folder "songs" back to the original directory and rename it to "songs_wii"
echo Moving back Wii song folder
move "%~dp0\_ark\songs" "%~dp0\_songs\songs_wii"

echo:
if %FAILED_ARK_BUILD% neq 1 (echo:Successfully built LEGO Rock Band Ultimate ARK files. Make sure to add _build/wii as a game path in Dolphin and enable search subfolders so it will show up.)
if %FAILED_ARK_BUILD% neq 0 (echo:Error building ARK. Download the repo again or some dta file is bad p.s turn echo on to see what arkhelper says.)
echo:
pause