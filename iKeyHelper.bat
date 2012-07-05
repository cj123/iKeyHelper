:: iKeyHelper v1.3	  	
:: Copyright (C) 2012 Callum Jones
:: See attached license

:: if you get all the tools, pop them in a tools.zip and place it at %appdata%\iKeyHelper\tools.zip
:: copy device_definitions.bat and iKeyHelper.settings.bat to %UserProfile%\iKeyHelper\

@ECHO OFF

title iKeyHelper

::------------------------------------------------------------------------------------

SETLOCAL EnableDelayedExpansion
setlocal

:: set some vars
:: version
set version=1.3.0

:beginning

set tools=%appdata%\iKeyHelper\bin
set logdir=%appdata%\iKeyHelper\logs
set tempdir=%temp%\iKeyHelper

:: still ignore this ;)
set uuid=iKeyHelper~git

title iKeyHelper v%version% - (c) 2012 cj 
cls

if not exist %UserProfile%\iKeyHelper mkdir %UserProfile%\iKeyHelper >NUL
if not exist "%UserProfile%\iKeyHelper\iKeyHelper.settings.bat" (
	echo Not found settings file...
)

:: parse the settings
call %UserProfile%\iKeyHelper\iKeyHelper.settings.bat this-is-meant-to-be-run

if not exist %tempdir% mkdir %tempdir% >NUL

:: Run on startup
color 0%fontcolour%
cd %tempdir% 

:: delete me some stuffs

if exist * del * /S /Q >NUL
if exist dlipsw rmdir dlipsw /S /Q >NUL
if exist IPSW rmdir IPSW /S /Q >NUL
if exist tools rmdir tools /S /Q >NUL
if exist decrypted rmdir decrypted /S /Q >NUL
if exist *.txt del *.txt /S /Q >NUL

cls
cd %tools%
if not exist %appdata%\iKeyHelper\bin\genpass.exe (
	echo Extracting Files... 
	:: Extract the tools
	if not exist %tempdir% mkdir %tempdir% >nul
	if not exist %tools% mkdir %tools% >nul
	copy %MYFILES%\7za.exe %tools%\7za.exe >nul
	call 7za.exe x -y -mmt %appdata%\iKeyHelper\tools.zip >nul
)


cls
echo Generating log file...
:: create error log file

set timestamp=iKeyHelper_%version%.log

if "%viewlog%"=="yes" (
	taskkill /F /IM "baretail.exe" 2>NUL >NUL
	start "" %tools%\baretail "%logdir%\%timestamp%"
)


CALL :log info -----------------------------------------------------------------------------

CALL :log info Starting iKeyHelper v%version%

CALL :log info -----------------------------------------------------------------------------

:: check for old files and remove them
CALL :log info Clearing existing files
if exist %tempdir%\kbags rmdir /S /Q %tempdir%\kbags >nul
if exist %tempdir%\IPSW rmdir /S /Q %tempdir%\IPSW >nul
if exist %tempdir%\ipad-bb rmdir /S /Q %tempdir%\ipad-bb >nul
if exist %tempdir%\dlipsw rmdir /S /Q %tempdir%\dlipsw >nul
if exist %tempdir%\keys.txt del /S /Q if exist %tempdir%\keys.txt >nul
if exist %tempdir%\all.txt del /S /Q %tempdir%\all.txt >nul
cls	

goto top

:top


cd %tempdir%

cls

set tehinfile= >NUL
set IPSW=  >NUL
echo [v=%version%]
echo.
echo                                   iKeyHelper    
echo                                 --------------
echo ________________________________________________________________________________
echo  Drag in an...
echo.
echo                    $$$$$$\ $$$$$$$\   $$$$$$\  $$\      $$\ 
echo                    \_$$  _^|$$  __$$\ $$  __$$\ $$ ^| $\  $$ ^|
echo                      $$ ^|  $$ ^|  $$ ^|$$ /  \__^|$$ ^|$$$\ $$ ^|
echo                      $$ ^|  $$$$$$$  ^|\$$$$$$\  $$ $$ $$\$$ ^|
echo                      $$ ^|  $$  ____/  \____$$\ $$$$  _$$$$ ^|
echo                      $$ ^|  $$ ^|      $$\   $$ ^|$$$  / \$$$ ^|
echo                    $$$$$$\ $$ ^|      \$$$$$$  ^|$$  /   \$$ ^|
echo                    \______^|\__^|       \______/ \__/     \__^|
echo.
echo.
echo                                          ...or type "x" to download from Apple.
if not exist "\Windows\System32\libusb0.dll" (
echo ^|______________________________________________________________________________^|
echo ^|     Error: You do not have libusb. Please take care when installing it.      ^|
CALL :log error Unable to find LibUSB. Please install it.
) 
if not exist "%ProgramFiles%\iTunes\" (
echo ^|______________________________________________________________________________^|
echo ^|     Error: You do not have iTunes. Please install from apple.com/itunes      ^|
CALL :log error Unable to find iTunes. Please install it.
) 
echo.
echo ________________________________________________________________________________

:: open readme (once)

if not exist %appdata%\iKeyHelper\read.me (
	CALL :log info Opening ReadMe
	start http://www.icj.me/iKeyHelper
	echo read >%appdata%\iKeyHelper\read.me
)

setlocal enableextensions enabledelayedexpansion
setlocal
set /P tehinfile=- File: %=%

:: Remove quotes from infile if they exist, then put them back ;)
CALL :dequote tehinfile
set IPSW="%tehinfile%"

if %IPSW%=="x" ( 
	call :log info Opening IPSW downloader...
	goto downloadme
) else if %IPSW%=="dl" (
	call :log info Opening IPSW downloader...
	goto downloadme
)


goto checkloop 

:downloadme
cls 
echo.
echo  Download an...
echo.
echo                    $$$$$$\ $$$$$$$\   $$$$$$\  $$\      $$\ 
echo                    \_$$  _^|$$  __$$\ $$  __$$\ $$ ^| $\  $$ ^|
echo                      $$ ^|  $$ ^|  $$ ^|$$ /  \__^|$$ ^|$$$\ $$ ^|
echo                      $$ ^|  $$$$$$$  ^|\$$$$$$\  $$ $$ $$\$$ ^|
echo                      $$ ^|  $$  ____/  \____$$\ $$$$  _$$$$ ^|
echo                      $$ ^|  $$ ^|      $$\   $$ ^|$$$  / \$$$ ^|
echo                    $$$$$$\ $$ ^|      \$$$$$$  ^|$$  /   \$$ ^|
echo                    \______^|\__^|       \______/ \__/     \__^|
echo.
echo --------------------------------------------------------------------------------
echo - You have chosen to download an IPSW file. 
echo - Which device are you downloading for? (e.g. iPhone3,1)

set /P dldevice=- Device: %=%

echo - Which firmware do you wish to download? (e.g. 5.0.1)

set /P dlfw=- Firmware: %=%

:: echo - What is the BuildID of this firmware? (e.g. 9A405)

:: set /P dlid=- BuildID: %=%

if exist %tempdir%\dlipsw rmdir %tempdir%\dlipsw >NUL
if not exist %tempdir%\dlipsw mkdir %tempdir%\dlipsw >NUL

cd %tempdir%\dlipsw

if exist url.txt del url.txt /S /Q >NUL
echo - Fetching Link...

%tools%\curl -A "iKeyHelper - %uuid% - %version%" --silent http://api.ios.icj.me/v2/%dldevice%/%dlfw%/url -I>response.txt

findstr "300 Multiple Choices" response.txt > nul

if errorlevel 1 (
	set downloadlink=http://api.ios.icj.me/v2/%dldevice%/%dlfw%
	goto downloadipsw
)



<nul set /p "= - Multiple Buildid's Found: "
%tools%\curl -A "iKeyHelper - %uuid% - %version%" --silent http://api.ios.icj.me/v2/%dldevice%/%dlfw%/buildid>choices.txt

:: remove some stuff, make it more prettier

%tools%\ssr.exe 0 "[{''buildid'':''" "" choices.txt >NUL
%tools%\ssr.exe 0 "''}" "" choices.txt >NUL
%tools%\ssr.exe 0 "{''buildid'':''" " " choices.txt >NUL
%tools%\ssr.exe 0 "]" "" choices.txt >NUL

type choices.txt

set /P dlid=- Choose one BuildID: %=%

set downloadlink=http://api.ios.icj.me/v2/%dldevice%/%dlid%


goto downloadipsw
	
:downloadipsw


%tools%\curl -A "iKeyHelper - %uuid% - %version%" --silent %downloadlink%/url -I>response.txt

findstr "202 Accepted" response.txt > nul

if errorlevel 1 (
	echo - Error: Link not found.
	echo - Press any key to return to the IPSW downloader.
	pause >NUL
	goto downloadme
)


%tools%\curl -A "iKeyHelper - %uuid% - %version%" --silent %downloadlink%/filename>ipsw_name.txt

%tools%\curl -A "iKeyHelper - %uuid% - %version%" --silent %downloadlink%/url>url.txt
%tools%\curl -A "iKeyHelper - %uuid% - %version%" --silent %downloadlink%/filesize>filesize.txt
set /p ipswName=<ipsw_name.txt
set /p downloadlink=<url.txt
set /p filesize=<filesize.txt

echo - Downloading %ipswName%... [%filesize%MB]
CALL :log info downloading IPSW from %downloadlink%


echo --------------------------------------------------------------------------------
call %tools%\curl -LO %downloadlink% --progress-bar



call :log info IPSW Name: %ipswName%
:: check for my HDD for IPSWs :P
if exist "G:\Apple Firmware" (
	call :log info moving %ipswName% to "%UserProfile%\Desktop\%ipswName%"
	if not exist "G:\Apple Firmware\%dldevice%" mkdir "G:\Apple Firmware\%dldevice%" >NUL
	if not exist "G:\Apple Firmware\%dldevice%\Official" mkdir "G:\Apple Firmware\%dldevice%\Official" >NUL
	move /y "%ipswName%" "G:\Apple Firmware\%dldevice%\Official\%ipswName%" >NUL

	if not exist "G:\Apple Firmware\%dldevice%\Official\%ipswName%" (
		call :log error IPSW move failed
	) else (
		call :log info IPSW move succeeded
	)

	set tehinfile="G:\Apple Firmware\%dldevice%\Official\%ipswName%"
	cls
	echo - IPSW download finished^^! Saved to "G:\Apple Firmware\%dldevice%\Official\%ipswName%"

) else (
	call :log info moving %ipswName% to "%UserProfile%\Desktop\%ipswName%"
	move /y "%ipswName%" "%UserProfile%\Desktop\%ipswName%" >NUL

	if not exist "%UserProfile%\Desktop\%ipswName%" (
		call :log error IPSW move failed
	) else (
		call :log info IPSW move succeeded
	)

	set tehinfile="%UserProfile%\Desktop\%ipswName%"
	cls
	echo - IPSW download finished^^! Saved to "%UserProfile%\Desktop\%ipswName%"
)


echo - Press any key to continue...
pause >NUL

:checkloop

echo.
echo --------------------------------------------------------------------------------
echo.
cls
echo [v=%version%]
echo                                Running iKeyHelper
echo                              ----------------------
echo.
echo.


:: Remove quotes from infile if they exist, then put them back ;)
CALL :dequote tehinfile
set IPSW="%tehinfile%"
call :log Detected input file as %IPSW%
:: start the timer

set starttime=%time%

:: create userside directory

if not exist "%bundledir%" (
	mkdir "%bundledir%" >NUL
	CALL :log info Making directory: %bundledir%
)

:: check whether this is infact an IPSW...

echo %IPSW% | findstr ".ipsw" >NUL


if not "%ERRORLEVEL%"=="0" (
	CALL :log error This isn't an IPSW.
	echo -^^!- Error^^! This is not an IPSW. Try again, but use some brain cells next time?
	echo -^^!- Press any key to go back to the menu...
	pause >NUL
	goto beginning
)

:: get the short file name of the IPSW.
call :sfn %IPSW%

:: clear boardid
set boardid=

<nul set /p "= - Extracting Files... "

cd %tempdir%

if exist %tempdir%\temp.txt del %tempdir%\temp.txt /S /Q >NUL
if exist %tempdir%\sha1.txt del %tempdir%\sha1.txt /S /Q >NUL

:: extract ipsw..... 

CALL :log info Unzipping %IPSW%...
call %tools%\7za.exe e -oIPSW -mmt %IPSW% kernel* Firmware/* *.plist >> %logdir%\%timestamp%  

echo Done^^!

<nul set /p "= - IPSW Info: " 


call :parse %tempdir%\IPSW\Restore.plist ProductVersion >productversion.txt
for /f "tokens=* delims= " %%a in (productversion.txt) do set ipswversion=%%a

call :parse %tempdir%\IPSW\Restore.plist MarketingVersion >MarketingVersion.txt
for /f "tokens=* delims= " %%a in (MarketingVersion.txt) do set MarketingVersion=%%a

if not %errorlevel%==1 (
	set marketingversionexists=yes
	for /f "tokens=* delims= " %%a in (MarketingVersion.txt) do set MarketingVersiontitle= [%%a]
) else (
	set marketingversionexists=no
)

<nul set /p "= iOS %ipswversion%%MarketingVersiontitle% "

:: get Platform

call :parse %tempdir%\IPSW\Restore.plist Platform >Platform.txt

for /f "tokens=* delims= " %%a in (Platform.txt) do set platform=%%a

:: do some more parsing because epic.

call :parse %tempdir%\IPSW\BuildManifest.plist BuildTrain >BuildTrain.txt
for /f "tokens=* delims= " %%a in (BuildTrain.txt) do set BuildTrain=%%a

call :parse %tempdir%\IPSW\BuildManifest.plist BuildNumber >BuildNumber.txt
for /f "tokens=* delims= " %%a in (BuildNumber.txt) do set BuildNumber=%%a

<nul set /p "= (%BuildNumber%) "

if exist %tempdir%\temp.txt del %tempdir%\temp.txt /S /Q >NUL
if exist %tempdir%\sha1.txt del %tempdir%\sha1.txt /S /Q >NUL

for %%a in (%IPSW%) do (
	set /a sizeofipsw=%%~za / 1048576
)

CALL :log info %shortipsw% size: %sizeofipsw%MB

:: Boardid verification

set boardid=
set bdid=

call :parse %tempdir%\IPSW\Restore.plist ProductVersion >productversion.txt
for /f "tokens=* delims= " %%a in (productversion.txt) do set ipswversion=%%a

:: find ProductType in the restore.plist

call :parse %tempdir%\IPSW\Restore.plist ProductType >producttype.txt
for /f "tokens=* delims= " %%a in (producttype.txt) do set ProductType=%%a
:: remove commas (2c)

%tools%\binmay.exe -i "producttype.txt" -o "producttype-1.txt" -s "2c" 2>NUL

for /f "tokens=* delims= " %%a in (producttype-1.txt) do set bdid=%%a

:: device IDs

CALL :log info Getting Device Definitions...

call %UserProfile%\iKeyHelper\device_definitions.bat %bdid%

<nul set /p "= for %deviceid% "




if exist %tempdir%\boardid rmdir %tempdir%\boardid /S /Q >NUL

CALL :log info Device recognized as %deviceid%

title iKeyHelper v%version% running %deviceid%, iOS %ipswversion%%MarketingVersiontitle% (%BuildNumber%) - (c) %year% cj 

:: fuck manifest reading. lets do this cj style.
:: rofl iH8sn0w's one 'suggestion' down the drain. baahahahahahaha
:: yea ik its messy

:: ipsw name check.
if exist checkme.txt del checkme.txt /S /Q >NUL
if exist temp.txt del temp.txt /S /Q >NUL
echo %shortipsw% >checkme.txt
%tools%\ssr.exe 0 "_Restore.ipsw" "" checkme.txt >NUL
move checkme.txt temp.txt >NUL
%tools%\binmay.exe -i temp.txt -o checkme.txt -s 20 0D 0A 2>NUL
if exist temp.txt del temp.txt /S /Q >NUL
set /P ipswname=<checkme.txt
if exist checkme.txt del checkme.txt

:: baseband version detection
:: i'm gonna hate this.

call :log info Detecting Baseband version 

pushd %tempdir%\IPSW

if exist baseband.txt del baseband.txt /S /Q >NUL

if %boardid%==n90 (
	dir /B /OS *.Release.bbfw >>baseband.txt
	%tools%\ssr.exe 0 "ICE3_" "Baseband:" baseband.txt
	%tools%\ssr.exe 0 "_BOOT_" /SSR_NL/ baseband.txt
	:: yay a fun bit
	FOR /F "tokens=2 delims=:" %%a IN ('find "Baseband" ^<baseband.txt') DO SET baseband=%%a 
) else if %boardid%==n94 (
	dir /B /OS Trek-*.Release.bbfw >>baseband.txt
	%tools%\ssr.exe 0 "Trek-" "Baseband:" baseband.txt
	%tools%\ssr.exe 0 ".Release.bbfw" /SSR_NL/ baseband.txt
	:: yay a fun bit
	FOR /F "tokens=2 delims=:" %%a IN ('find "Baseband" ^<baseband.txt') DO SET baseband=%%a 
) else if %boardid%==n92 (
	:: should be Phoenix-VE.RS.ION.Release.bbfw ?
	::del Phoenix* /S /Q >NUL 2>NUL
	dir /B /OS *.Release.bbfw >>baseband.txt
	%tools%\ssr.exe 0 "Phoenix-" "Baseband:" baseband.txt
	%tools%\ssr.exe 0 ".Release" /SSR_NL/ baseband.txt
	:: yay a fun bit
	FOR /F "tokens=2 delims=:" %%a IN ('find "Baseband" ^<baseband.txt') DO SET baseband=%%a 
) else (
	call :log info This device does not have a baseband^^! [or-baseband-detection-is-not-supported]
	set baseband=
)


if "%boardid%"=="n90" ( 
	echo - Baseband %baseband%
) else if "%boardid%"=="n92" ( 
	echo - Baseband %baseband%
) else (
	echo.
)
if "%requiresdevice%"=="yes" (
	echo - This firmware requires you to be using an %deviceid% to get keys.
	<nul set /p "= - Please plug in your %deviceid% in NORMAL mode... "
	goto devicecheck
) else (
	echo - Use any A4 device to get keys for this firmware.
	goto nodevicecheck
)

:devicecheck

set detectedDevice=
for /F "tokens=2 delims=: " %%t in ('%tools%\ideviceinfo.exe ^| findstr "HardwareModel"') do set detectedDevice=%%t
set detectedID=
for /F "tokens=2 delims=: " %%v in ('%tools%\ideviceinfo.exe ^| findstr "ProductType"') do set detectedID=%%v

%tools%\ideviceinfo.exe | find /I /N "No device found">NUL
if "%ERRORLEVEL%"=="1" (
	echo Found device^^!
	CALL :log info Device found in NORMAL mode.
) else (
	ping localhost -n 6 >nul
	CALL :log error No NORMAL device found. Rechecking...
	goto devicecheck
)
call :log info Device is %detectedDevice%
if not "%detectedDevice%"=="%boardid%ap" (
	echo -^^!- Error: You have not plugged in a %deviceid%^^! This is an %detectedID%.
	echo - Press any key to return to main screen...
	pause >NUL
	goto beginning
)

:nodevicecheck

popd 

:: get the file names from manifest

for /f "tokens=*" %%a IN ('find "applelogo" ^<%tempdir%\IPSW\manifest') do set applelogo=%%a
for /f "tokens=*" %%a IN ('find "batterylow0" ^<%tempdir%\IPSW\manifest') do set batterylow0=%%a
for /f "tokens=*" %%a IN ('find "batterylow1" ^<%tempdir%\IPSW\manifest') do set batterylow1=%%a
for /f "tokens=*" %%a IN ('find "glyphcharging" ^<%tempdir%\IPSW\manifest') do set glyphcharging=%%a
for /f "tokens=*" %%a IN ('find "batterycharging0" ^<%tempdir%\IPSW\manifest') do set batterycharging0=%%a
for /f "tokens=*" %%a IN ('find "batterycharging1" ^<%tempdir%\IPSW\manifest') do set batterycharging1=%%a
for /f "tokens=*" %%a IN ('find "glyphplugin" ^<%tempdir%\IPSW\manifest') do set glyphplugin=%%a
for /f "tokens=*" %%a IN ('find "batteryfull" ^<%tempdir%\IPSW\manifest') do set batteryfull=%%a
for /f "tokens=*" %%a IN ('find "LLB" ^<%tempdir%\IPSW\manifest') do set LLB=%%a
for /f "tokens=*" %%a IN ('find "iBoot" ^<%tempdir%\IPSW\manifest') do set iBoot=%%a
for /f "tokens=*" %%a IN ('find "DeviceTree" ^<%tempdir%\IPSW\manifest') do set DeviceTree=%%a
for /f "tokens=*" %%a IN ('find "recoverymode" ^<%tempdir%\IPSW\manifest') do set RecoveryMode=%%a
set iBSS=iBSS.%boardid%ap.RELEASE.dfu
set iBEC=iBEC.%boardid%ap.RELEASE.dfu
set kernel=kernelcache.RELEASE.%boardid%

cd IPSW

<nul set /p "= - Getting Ramdisk Information... "

if exist %tempdir%\IPSW\oldstyle.txt del %tempdir%\IPSW\oldstyle.txt /S /Q >NUL

:: Ramdisk identification, Done properly :)

:: edit out un-needed strings using hex.
%tools%\binmay.exe -i %tempdir%\IPSW\Restore.plist -o %tempdir%\Restore.txt -s 0A 09 09 2>NUL
%tools%\binmay.exe -i %tempdir%\Restore.txt -o %tempdir%\Restore1.txt -s 09 09 09 2>NUL

:: then add a space before + after </string>

%tools%\ssr.exe 0 "</string>" " </string> " %tempdir%\Restore1.txt >NUL

:: then add a space after <key>Update</key><string>

%tools%\ssr.exe 0 "<key>Update</key><string>" "/SSR_NL/Update:" %tempdir%\Restore1.txt >NUL

:: and after <key>User</key><string>

%tools%\ssr.exe 0 "<key>User</key><string>" "/SSR_NL/User:" %tempdir%\Restore1.txt >NUL

:: remove 3C 2F 73 74 72 69 6E 67 3E (</string>) -- yes, i know, couldve just Done this above, who cares --- it works 

%tools%\binmay.exe -i %tempdir%\Restore1.txt -o %tempdir%\Restore2.txt -s "3C 2F 73 74 72 69 6E 67 3E" 2>NUL

REM :: remove top 3 lines (all the crap)
REM for /f "skip=3" %%A in (%tempdir%\Restore2.txt) do ( echo %%A >> # )
REM del "%tempdir%\Restore2.txt" 
REM for /f %%A in (#) do ( echo %%A >> %tempdir%\Restore2.txt)
REM del #

:: replace User with restore, for easier identification

%tools%\ssr.exe 1 "User" "Restore" %tempdir%\Restore2.txt
%tools%\ssr.exe 1 "User" "NotherRD" %tempdir%\Restore2.txt
%tools%\ssr.exe 1 "User" "RootFS" %tempdir%\Restore2.txt

%tools%\binmay.exe -i %tempdir%\Restore2.txt -o %tempdir%\Restore4.txt -s 20 20 20 2>NUL

%tools%\ssr.exe 0 ".dmg" ".dmg/SSR_NL/" %tempdir%\Restore4.txt >NUL

:: set restore as the word after Restore:
FOR /F "tokens=2 delims=:" %%a IN ('find "Restore" ^<%tempdir%\Restore4.txt') DO SET restore=%%a 
FOR /F "tokens=2 delims=:" %%a IN ('find "NotherRD" ^<%tempdir%\Restore4.txt') DO SET notherRD=%%a 

if "%notherRD%"=="%restore%" (
	FOR /F "tokens=2 delims=:" %%a IN ('find "RootFS" ^<%tempdir%\Restore4.txt') DO SET rootfilesystem=%%a 

) else (
	SET rootfilesystem=%notherRD%

)

:: same as above but for update
FOR /F "tokens=2 delims=:" %%a IN ('find "Update" ^<%tempdir%\Restore4.txt') DO SET update=%%a 

FOR /F "tokens=2 delims=:" %%a IN ('find "Update" ^<%tempdir%\Restore4.txt') DO SET updateishere=yes

:: checking ramdisk numbers!!!

if "%updateishere%"=="yes" (
	echo %update% > dmgs.txt
	set updateishere=yes
)

echo %restore% >> dmgs.txt
echo %rootfilesystem% >> dmgs.txt

%tools%\binmay.exe -i %tempdir%\IPSW\dmgs.txt -o %tempdir%\IPSW\dmgs-f.txt -s 20 20 20 2>NUL
ping -n 3 localhost >NUL
for /f "tokens=* delims= " %%a in (%tempdir%\IPSW\dmgs-f.txt) do (
	set /a n+=1
	set ramdisk!n!=%%a
)

if not "%updateishere%"=="yes" (
	CALL :log error No Update Ramdisk. Continuing...
	set restore=%ramdisk1%
	set rootfilesystem=%ramdisk2%
) else (
    :: assume all 3 ramdisks are there. 
	set update=%ramdisk1%
	set restore=%ramdisk2%
	set rootfilesystem=%ramdisk3%
)
echo Done^^!

CALL :log info Ramdisks-Update-%update%-Restore-%restore%-Rootfs-%rootfilesystem%

%tools%\7za.exe e -o%tempdir%\IPSW -mmt %IPSW% %update% %restore% >> %logdir%\%timestamp%


echo bgcolor 0 0 0 >>%tempdir%\all.txt 
:: speed it up for me


echo go fbecho iKeyHelper v%version% by Callum Jones ^<cj@icj.me^> >>%tempdir%\all.txt
echo go fbecho ========================================>>%tempdir%\all.txt
echo go fbecho - Loading iOS %ipswversion%%MarketingVersiontitle% (%BuildNumber%) >>%tempdir%\all.txt 
echo go fbecho ^> for %ProductType% (%url_parsing_device%) >>%tempdir%\all.txt 
echo go fbecho ========================================>>%tempdir%\all.txt

if exist *.txt del *.txt /S /Q >NUL
if exist asr* del asr* /S /Q >NUL

CALL :log info Getting KBAGs...
:: delete the files

:: if exist %tempdir%\Restore.txt del %tempdir%\Restore.txt /S /Q >NUL
:: if exist %tempdir%\Restore1.txt del %tempdir%\Restore1.txt /S /Q >NUL
:: if exist %tempdir%\Restore2.txt del %tempdir%\Restore2.txt /S /Q >NUL

:kbags

<nul set /p "= - Grabbing KBAGs... "

call :grabkbag %LLB% >>%tempdir%\all.txt
call :grabkbag %iBoot% >>%tempdir%\all.txt 
call :grabkbag %devicetree% >>%tempdir%\all.txt 
call :grabkbag %applelogo% >>%tempdir%\all.txt 
call :grabkbag %recoverymode% >>%tempdir%\all.txt 
call :grabkbag %batterylow0% >>%tempdir%\all.txt 
call :grabkbag %batterylow1% >>%tempdir%\all.txt 
call :grabkbag %glyphcharging% >>%tempdir%\all.txt 
call :grabkbag %glyphplugin% >>%tempdir%\all.txt 
call :grabkbag %batterycharging0% >>%tempdir%\all.txt 
call :grabkbag %batterycharging1% >>%tempdir%\all.txt 
call :grabkbag %batteryfull% >>%tempdir%\all.txt 
call :grabkbag %ibss% >>%tempdir%\all.txt 
call :grabkbag %ibec% >>%tempdir%\all.txt 
call :grabkbag %kernel% >>%tempdir%\all.txt 


pushd %tempdir%\IPSW\
:: run this TWICE.
if exist %tempdir%\IPSW\%restore% (
	%tools%\xpwntool.exe %tempdir%\IPSW\%restore% %tempdir%\IPSW\%restore%-1.dmg >NUL 2>NUL
	%tools%\hfsplus %tempdir%\IPSW\%restore%-1.dmg extract /usr/sbin/asr asr-test2 >NUL 2>NUL
	if not exist asr-test2 ( 
		::echo doing RESTORE
		set restoreenc=y
		call :grabkbag %restore% >>%tempdir%\all.txt
	) else (
		set restoreenc=n
		echo go echo %restore% >>%tempdir%\all.txt
		echo go echo *Not_Encrypted >>%tempdir%\all.txt
	)
)

if "%updateishere%"=="yes" (
	%tools%\xpwntool.exe %tempdir%\IPSW\%update% %tempdir%\IPSW\%update%-1.dmg >NUL 2>NUL
	%tools%\hfsplus %tempdir%\IPSW\%update%-1.dmg extract /usr/sbin/asr asr-test1 >NUL 2>NUL
	if not exist asr-test1 (
		::echo DOING UPDATE
		set updateenc=y
		call :grabkbag %update% >>%tempdir%\all.txt
	) else (
		set updateenc=n
		echo go echo %update% >>%tempdir%\all.txt
		echo go echo *Not_Encrypted >>%tempdir%\all.txt
	)
)

popd

echo go fbecho ===================================>>%tempdir%\all.txt
echo go fbecho - Done>>%tempdir%\all.txt 
echo go fbecho - Rebooting...>>%tempdir%\all.txt
echo go fbecho ===================================>>%tempdir%\all.txt

echo Done^^!
echo /exit >>%tempdir%\all.txt

:: close open iTunes windows (if they exist)
tasklist /FI "IMAGENAME eq iTunes.exe" 2>NUL | find /I /N "iTunes.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo - Closing iTunes
	taskkill /F /IM "iTunes.exe" >nul
)
:: close open iTunesHelper (if it is open)
tasklist /FI "IMAGENAME eq iTunesHelper.exe" 2>NUL | find /I /N "iTunesHelper.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo - Closing iTunesHelper
	taskkill /F /IM "iTunesHelper.exe" >nul
)


::checking for dfu - an even better way. :)
<nul set /p "= - Please Enter DFU mode... "
goto dfucheck
:dfucheck
%tools%\irecovery.exe -c | find /I /N "DFU">NUL

if "%ERRORLEVEL%"=="0" (
	echo Found device^^!
	CALL :log info Device found in DFU mode.
) else (
	ping localhost -n 6 >nul
	CALL :log error No DFU device found. Rechecking...
	goto dfucheck
)

:found-recovery
call %tools%\irecovery.exe -c "setenv boot-args 2" >nul
call %tools%\irecovery.exe -c "saveenv" >nul


call :log info Extracting RootFS

start /B "" %tools%\7za.exe e -o%tempdir%\IPSW -mmt %IPSW% %rootfilesystem% >NUL

cd %tempdir%

:: injectpois0n
CALL :log info Starting Injectpois0n.
<nul set /p "= - Running injectpois0n... "
call %tools%\injectpois0n.exe -2 >> %logdir%\%timestamp% 2>NUL
CALL :log info Injectpois0n finished.
if exist %tempdir%\iBSS* del %tempdir%\iBSS* /S /Q >NUL
echo Done^^!

goto elsewhere

:elsewhere

:: run irecovery -s to get rid of unneeded junk :)

start /B %tools%\irecovery -s >nul
ping localhost -n 5 >nul
taskkill /F /IM "irecovery.exe" 2>NUL >nul
cd %tempdir%\IPSW\
:: call %tools%\irecovery -c "bgcolor 0 100 100" >nul

:: close open irecovery windows (if they exist)

tasklist /FI "IMAGENAME eq irecovery.exe" 2>NUL | find /I /N "irecovery.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo - Closing any open iRecovery command windows
	taskkill /F /IM "irecovery.exe" >nul
)

cd %tempdir%

<nul set /p "= - Getting keys... "
%tools%\irecovery -s gp-keys.txt < all.txt >> %logdir%\%timestamp%

cd %tempdir%\IPSW\

goto loop1

:loop1
tasklist /FI "IMAGENAME eq irecovery.exe" 2>NUL | find /I /N "irecovery.exe">NUL

if "%ERRORLEVEL%"=="0" (
	goto loop1
) 

:: reboot 

CALL :log info Rebooting Device. 
<nul set /p "= Rebooting... "
%tools%\irecovery -c "setenv auto-boot true" >nul
%tools%\irecovery -c "saveenv" >nul
%tools%\irecovery -c "reboot" >nul


echo Done^^!

CALL :log info formatting text file.
pushd %tempdir%

%tools%\binmay.exe -i gp-keys.txt -o keys.txt -s 00 2>NUL
%tools%\ssr.exe 0 """ "'" keys.txt
%tools%\ssr.exe 0 " " "" keys.txt
%tools%\ssr.exe 0 "-iv" "* /SSR_QUOTE//SSR_QUOTE//SSR_QUOTE/IV/SSR_QUOTE//SSR_QUOTE//SSR_QUOTE/: " keys.txt
%tools%\ssr.exe 0 "-k" "/SSR_NL/* /SSR_QUOTE//SSR_QUOTE//SSR_QUOTE/Key/SSR_QUOTE//SSR_QUOTE//SSR_QUOTE/: " keys.txt

%tools%\ssr.exe 0 "Not_Encrypted" "Not Encrypted" keys.txt

:: rootfs key grabbing

:: parse all iv's to ivs.txt
echo 1 >ivs.txt
echo 2 >>ivs.txt
for %%a in ("%tempdir%\keys.txt") do (
	for /f "tokens=3" %%B in ('find "'''IV''': " ^< %%a') do (
		echo %%B >>ivs.txt
	)
)

if exist temp.txt del temp.txt /S /Q >NUL
move ivs.txt temp.txt >NUL
%tools%\binmay.exe -i temp.txt -o ivs.txt -s 20 0D 0A 2>NUL
if exist temp.txt del temp.txt /S /Q >NUL
for /f "tokens=* delims= " %%a in (ivs.txt) do (
	set /a ivz+=1
	set iv!ivz!=%%a
)

:: parse all keys to key.txt 
echo 1 >key.txt
echo 2 >>key.txt
for %%a in ("%tempdir%\keys.txt") do (
	for /f "tokens=3" %%B in ('find "'''Key''': " ^< %%a') do (
		echo %%B >>key.txt
	)
)

if exist temp.txt del temp.txt /S /Q >NUL
move key.txt temp.txt >NUL
%tools%\binmay.exe -i temp.txt -o key.txt -s 20 0D 0A 2>NUL
if exist temp.txt del temp.txt /S /Q >NUL
for /f "tokens=* delims= " %%a in (key.txt) do (
	set /a keyz+=1
	set key!keyz!=%%a
)

goto back-to-me

:back-to-me

if %boardid%==n94 (
	echo - Extracting RootFS...
	%tools%\7za.exe e -o%tempdir%\IPSW -mmt %IPSW% %rootfilesystem% >NUL
)

if not exist %tempdir%\decrypted mkdir %tempdir%\decrypted\ >NUL

cd %tempdir%

if exist %tempdir%\decrypted\%update%.dec del %tempdir%\decrypted\%update%.dec /S /Q >NUL
if exist %tempdir%\decrypted\%restore%.dec del %tempdir%\decrypted\%restore%.dec /S /Q >NUL

CALL :log info Update Ramdisk Shiz
if not "%update%"=="" (
	if not "%updateenc%"=="n" (
		%tools%\xpwntool %tempdir%\IPSW\%update% %tempdir%\decrypted\%update%.dec -iv %iv19% -k %key19% >NUL
	) else (
		%tools%\xpwntool %tempdir%\IPSW\%update% %tempdir%\decrypted\%update%.dec >NUL
	)
)
CALL :log info Restore Ramdisk Shiz
if not "%restore%"=="" (
	if not "%restoreenc%"=="n" (
		%tools%\xpwntool %tempdir%\IPSW\%restore% %tempdir%\decrypted\%restore%.dec -iv %iv18% -k %key18% >NUL
	) else (
		%tools%\xpwntool %tempdir%\IPSW\%restore% %tempdir%\decrypted\%restore%.dec >NUL
	)
)

goto rootfs-check

:rootfs-check

if not exist %tempdir%\IPSW\%rootfilesystem% (
	call :log error No RootFS extracted!
	goto rootfs-check
) else (
	call :log info Found extracted RootFS
)

<nul set /p "= - Getting RootFS Key... "
CALL :log info Getting RootFS Key using restore
%tools%\genpass.exe -p %platform% -r decrypted/%restore%.dec -f IPSW/%rootfilesystem% >%tempdir%\IPSW\genpass.txt 2>NUL

findstr /C:"vfdecrypt key" %tempdir%\IPSW\genpass.txt >NUL

if not "%ERRORLEVEL%"=="0" (
	CALL :log error RootFS key not found -trying update
	%tools%\genpass.exe -p %platform% -r decrypted/%update%.dec -f IPSW/%rootfilesystem% >%tempdir%\IPSW\genpass.txt 2>NUL
)

CALL :log info Decrypting RootFS TEST
%tools%\dmg.exe extract %tempdir%\IPSW\%rootfilesystem% %tempdir%\decrypted\%rootfilesystem%.dec -k %rtkey% 2>decryptedcheck.txt

findstr /C:"readUDIFResourceFile - signature incorrect" decryptedcheck.txt >NUL

if "%errorlevel%"=="0" (
	call :log error Genpass and vfdecrypt key failed-tryingupdate
	%tools%\genpass.exe -p %platform% -r decrypted/%update%.dec -f IPSW/%rootfilesystem% >%tempdir%\IPSW\genpass.txt 2>NUL
)

findstr /C:"vfdecrypt key" %tempdir%\IPSW\genpass.txt >NUL
if "%errorlevel%"=="0" (
	for %%a in ("%tempdir%\IPSW\genpass.txt") do (
		for /f "tokens=3" %%B in ('find "vfdecrypt key: " ^< %%a') do (
			echo %%B >>pass.txt
			move pass.txt temp.txt >NUL
			%tools%\binmay.exe -i temp.txt -o pass.txt -s 20 0D 0A 2>NUL
			if exist temp.txt del temp.txt /S /Q >NUL
		)
	)
	for /f "tokens=* delims= " %%a in (pass.txt) do set rtkey=%%a
	echo Done^^!
) else (
	call :log error Genpass and vfdecrypt key failed
	echo FAILED^^!
)


:: Get the baseband for iPad from ramdisk
if "%bdid%"=="ipad11" goto ipadbb
if "%bdid%"=="iphone21" goto ipadbb
:: else go somewhere nicer.

goto noipadbb

:ipadbb
if exist %tempdir%\ipad-bb rmdir %tempdir%\ipad-bb /S /Q >NUL
CALL :log info Getting iPad/3G[S] Baseband
if not exist %tempdir%\ipad-bb mkdir %tempdir%\ipad-bb

pushd %tempdir%\ipad-bb
	:: hfsplus to the rescue! (lol)
	%tools%\hfsplus "%tempdir%\decrypted\%restore%.dec" extractall /usr/local/standalone/firmware/ >NUL 2>NUL
	:: check if its wrapped in a BBFW file
	if exist ICE2.Release.bbfw (
		CALL :log info BBFW EXISTS
		%tools%\7za x -y -mmt ICE2.Release.bbfw >NUL
	) else (
		CALL :log info BBFW NO EXISTY
	)
	
	dir /OS /B %tempdir%\ipad-bb\*.eep > %tempdir%\bb.txt 2>&1
	%tools%\ssr 0 "ICE2_" "" %tempdir%\bb.txt
	%tools%\ssr 0 ".eep" "" %tempdir%\bb.txt
	if "%bdid%"=="ipad11" (
		set /p baseband=< %tempdir%\bb.txt
	) 
	if "%bdid%"=="iphone21" (
		for /f "tokens=* delims= " %%a in (%tempdir%\bb.txt) do (
			set /a v+=1
			if "!v!"=="2" (
				set baseband=%%a
			)
		)
	)
	call :log info iPad/3G[S]Baseband: %baseband%
popd

goto noipadbb

:noipadbb
 
:: i'm sure there's a reason behind this but at the moment it looks absolutely stupid.
echo . >NUL

:: get url for firmware
pushd %temp%\iKeyHelper

%tools%\curl -A "iKeyHelper - %uuid% - %version%" --silent http://api.ios.icj.me/v2/%boardid%ap/%BuildNumber%/url >url.txt


set /p downloadurl=<url.txt

popd

echo iKeyHelper %version% by cj>iphonewikikeys.txt
if "%username%"=="Callum" (
	echo %ipswname% Keys and IV's Grabbed by cj ^<cj@icj.me^> on %date%>>iphonewikikeys.txt
) else (
	echo %ipswname% Keys and IV's Grabbed by %username% on %date%>>iphonewikikeys.txt
)

echo.>>iphonewikikeys.txt
echo ------------------------------------------- KEYS ------------------------------------------->>iphonewikikeys.txt
echo.>>iphonewikikeys.txt

echo {{keys>>iphonewikikeys.txt

if not "%marketingversion%"=="" (
	if not "%downloadurl%"=="" (
		echo  ^| version             = %ipswversion% ^(%MarketingVersion%^)>>iphonewikikeys.txt
	) else (
		echo  ^| version             = %ipswversion% ^(%MarketingVersion%^) b[number]>>iphonewikikeys.txt
	)
	
) else (
	if not "%downloadurl%"=="" (
		echo  ^| version             = %ipswversion%>>iphonewikikeys.txt
	) else (
		echo  ^| version             = %ipswversion%b[number]>>iphonewikikeys.txt
	)
)

echo  ^| build               = %BuildNumber%>>iphonewikikeys.txt
echo  ^| device              = %bdid%>>iphonewikikeys.txt
echo  ^| codename            = %BuildTrain%>>iphonewikikeys.txt

if not "%baseband%"=="" (
	echo  ^| baseband            = %baseband%>>iphonewikikeys.txt
)

if not "%downloadurl%"=="" (
	echo  ^| downloadurl         = %downloadurl%>>iphonewikikeys.txt
)
echo. >>iphonewikikeys.txt
echo  ^| rootfsdmg           = %rootfilesystem:~0,-4%>>iphonewikikeys.txt
echo  ^| rootfskey           = %rtkey%>>iphonewikikeys.txt

if "%update%"=="" (
	echo. >>iphonewikikeys.txt
	echo  ^| noupdateramdisk     = true>>iphonewikikeys.txt
) 

if "%restoreenc%"=="n" (
	echo. >>iphonewikikeys.txt
	echo  ^| ramdisknotencrypted = true>>iphonewikikeys.txt
) 

if not "%update%"=="" (
	echo. >>iphonewikikeys.txt
	echo  ^| updatedmg           = %update:~0,-4%>>iphonewikikeys.txt
	if not "%updateenc%"=="n" (
		echo  ^| updateiv            = %iv19%>>iphonewikikeys.txt
		echo  ^| updatekey           = %key19%>>iphonewikikeys.txt
	)
) 
echo. >>iphonewikikeys.txt
	echo  ^| restoredmg          = %restore:~0,-4%>>iphonewikikeys.txt
   
if not "%restoreenc%"=="n" (
	echo  ^| restoreiv           = %iv18%>>iphonewikikeys.txt
	echo  ^| restorekey          = %key18%>>iphonewikikeys.txt
)
echo. >>iphonewikikeys.txt
	echo  ^| AppleLogoIV         = %iv6%>>iphonewikikeys.txt
	echo  ^| AppleLogoKey        = %key6%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt
	echo  ^| BatteryCharging0IV  = %iv12%>>iphonewikikeys.txt
	echo  ^| BatteryCharging0Key = %key12%>>iphonewikikeys.txt	
echo. >>iphonewikikeys.txt	
	echo  ^| BatteryCharging1IV  = %iv13%>>iphonewikikeys.txt
	echo  ^| BatteryCharging1Key = %key13%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt	
	echo  ^| BatteryFullIV       = %iv14%>>iphonewikikeys.txt
	echo  ^| BatteryFullKey      = %key14%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt	
	echo  ^| BatteryLow0IV       = %iv8%>>iphonewikikeys.txt
	echo  ^| BatteryLow0Key      = %key8%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt
	echo  ^| BatteryLow1IV       = %iv9%>>iphonewikikeys.txt
	echo  ^| BatteryLow1Key      = %key9%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt
	echo  ^| DeviceTreeIV        = %iv5%>>iphonewikikeys.txt
	echo  ^| DeviceTreeKey       = %key5%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt	
	echo  ^| GlyphChargingIV     = %iv10%>>iphonewikikeys.txt
	echo  ^| GlyphChargingKey    = %key10%>>iphonewikikeys.txt	
echo. >>iphonewikikeys.txt	
	echo  ^| GlyphPluginIV       = %iv11%>>iphonewikikeys.txt
	echo  ^| GlyphPluginKey      = %key11%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt	
	echo  ^| iBECIV              = %iv16%>>iphonewikikeys.txt
	echo  ^| iBECKey             = %key16%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt	
	echo  ^| iBootIV             = %iv4%>>iphonewikikeys.txt
	echo  ^| iBootKey            = %key4%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt
	echo  ^| iBSSIV              = %iv15%>>iphonewikikeys.txt
	echo  ^| iBSSKey             = %key15%>>iphonewikikeys.txt	
echo. >>iphonewikikeys.txt
	echo  ^| KernelcacheIV       = %iv17%>>iphonewikikeys.txt
	echo  ^| KernelcacheKey      = %key17%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt	
	echo  ^| LLBIV               = %iv3%>>iphonewikikeys.txt
	echo  ^| LLBKey              = %key3%>>iphonewikikeys.txt
echo. >>iphonewikikeys.txt
	echo  ^| RecoveryModeIV      = %iv7%>>iphonewikikeys.txt
	echo  ^| RecoveryModeKey     = %key7%>>iphonewikikeys.txt

echo }}>>iphonewikikeys.txt

if not exist "%bundledir%\%url_parsing_device%" mkdir "%bundledir%\%url_parsing_device%"

copy iphonewikikeys.txt "%bundledir%\%url_parsing_device%\%ipswname%.txt" >nul
echo - Saved File to iKeyHelper bundle directory

if exist "%bundledir%\iPod Touch 4th Gen" move /y "%bundledir%\iPod Touch 4th Gen" "%bundledir%\iPod Touch 4" >NUL


start "" notepad "%bundledir%\%url_parsing_device%\%ipswname%.txt"

echo - Opening theiphonewiki page for %BuildTrain% %BuildNumber% (%url_parsing_device%)...
CALL :log info Opening theiphonewiki page for %BuildTrain%_%BuildNumber% ...
start http://theiphonewiki.com/wiki/index.php?title=%BuildTrain%_%BuildNumber%_(%deviceidw%)^&action=edit



cd %tempdir%

if not "%rtkey%"=="" (

	<nul set /p "= - Decrypting Root Filesystem... "

	if exist "%tempdir%\decrypted\%rootfilesystem%.dec" del "%tempdir%\decrypted\%rootfilesystem%.dec" /S /Q >NUL

	%tools%\dmg.exe extract %tempdir%\IPSW\%rootfilesystem% %tempdir%\decrypted\%rootfilesystem%.dec -k %rtkey% >NUL

	echo Done^^!

) else (
	echo - Unable to decrypt Root Filesystem :(
)

pushd %tempdir%\decrypted 

:: you idiot. why did you do this you numpty?!
:: 'derp why it no worky'
:: if exist %restore%.dec del %restore%.dec /S /Q >NUL
:: if exist %update%.dec del %update%.dec /S /Q >NUL

<nul set /p "= - Decrypting other files... "

CALL :log info Decrypting %applelogo%
%tools%\xpwntool.exe %tempdir%\IPSW\%applelogo% %applelogo%.dec -iv %iv6% -k %key6% >> %logdir%\%timestamp% 

CALL :log info Decrypting %LLB%
%tools%\xpwntool.exe %tempdir%\IPSW\%LLB% %LLB%.dec -iv %iv3% -k %key3% >> %logdir%\%timestamp%

CALL :log info Decrypting %iBoot%
%tools%\xpwntool.exe %tempdir%\IPSW\%iBoot% %iBoot%.dec -iv %iv4% -k %key4% >> %logdir%\%timestamp%

CALL :log info Decrypting %devicetree%
%tools%\xpwntool.exe %tempdir%\IPSW\%devicetree% %devicetree%.dec -iv %iv5% -k %key5% >> %logdir%\%timestamp%

CALL :log info Decrypting %recoverymode%
%tools%\xpwntool.exe %tempdir%\IPSW\%recoverymode% %recoverymode%.dec -iv %iv7% -k %key7% >> %logdir%\%timestamp%

CALL :log info Decrypting %batterylow0%
%tools%\xpwntool.exe %tempdir%\IPSW\%batterylow0% %batterylow0%.dec -iv %iv8% -k %key8% >> %logdir%\%timestamp%

CALL :log info Decrypting %batterylow1%
%tools%\xpwntool.exe %tempdir%\IPSW\%batterylow1% %batterylow1%.dec -iv %iv9% -k %key9% >> %logdir%\%timestamp%

CALL :log info Decrypting %glyphcharging%
%tools%\xpwntool.exe %tempdir%\IPSW\%glyphcharging% %glyphcharging%.dec -iv %iv10% -k %key10% >> %logdir%\%timestamp%

CALL :log info Decrypting %glyphplugin%
%tools%\xpwntool.exe %tempdir%\IPSW\%glyphplugin% %glyphplugin%.dec -iv %iv11% -k %key11% >> %logdir%\%timestamp%

CALL :log info Decrypting %batterycharging0%
%tools%\xpwntool.exe %tempdir%\IPSW\%batterycharging0% %batterycharging0%.dec -iv %iv12% -k %key12% >> %logdir%\%timestamp%

CALL :log info Decrypting %batterycharging1%
%tools%\xpwntool.exe %tempdir%\IPSW\%batterycharging1% %batterycharging1%.dec -iv %iv13% -k %key13% >> %logdir%\%timestamp%

CALL :log info NOT Decrypting %batteryfull%

:: This doesn't work, and I don't care why.
:: %tools%\xpwntool.exe %tempdir%\IPSW\%batteryfull% %batteryfull%.dec -iv %iv14% -k %key14% >> %logdir%\%timestamp%

CALL :log info Decrypting %ibss%
%tools%\xpwntool.exe %tempdir%\IPSW\%ibss% %ibss%.dec -iv %iv15% -k %key15% >> %logdir%\%timestamp%

CALL :log info Decrypting %ibec%
%tools%\xpwntool.exe %tempdir%\IPSW\%ibec% %ibec%.dec -iv %iv16% -k %key16% >> %logdir%\%timestamp%

CALL :log info Decrypting %kernel%
%tools%\xpwntool.exe %tempdir%\IPSW\%kernel% %kernel%.dec -iv %iv17% -k %key17% >> %logdir%\%timestamp%

echo Done^^!

popd

<nul set /p "= - Extracting files from dmg's... "
CALL :log info Extracting files from the dmg's
if not "%rtkey%"=="" (
	%tools%\hfsplus %tempdir%\decrypted\%rootfilesystem%.dec extract /etc/fstab %tempdir%\decrypted\fstab >NUL
	CALL :log info - fstab
	%tools%\hfsplus %tempdir%\decrypted\%rootfilesystem%.dec extract /System/Library/Lockdown/Services.plist %tempdir%\decrypted\Services.plist >NUL
	CALL :log info - Services.plist
	%tools%\hfsplus %tempdir%\decrypted\%rootfilesystem%.dec extract /usr/libexec/lockdownd %tempdir%\decrypted\lockdownd
	CALL :log info - lockdownd
)
%tools%\hfsplus %tempdir%\decrypted\%restore%.dec extract /usr/sbin/asr %tempdir%\decrypted\asr >NUL
CALL :log info - asr
echo Done^^!


cd %tempdir%
if exist *.bundle rmdir *.bundle /S /Q >NUL
mkdir "%ipswname%.bundle" >NUL
mkdir "%ipswname%.bundle\to-patch" >NUL
if exist decrypted\Info.plist move /y decrypted\Info.plist "%ipswname%.bundle\Info.plist" >NUL
if exist decrypted\asr move /y decrypted\asr "%ipswname%.bundle\to-patch\asr" >NUL
if exist decrypted\Services.plist move /y decrypted\Services.plist "%ipswname%.bundle\to-patch\Services.plist" >NUL
if exist decrypted\fstab move /y decrypted\fstab "%ipswname%.bundle\to-patch\fstab" >NUL
if exist decrypted\%ibss%.dec move /y decrypted\%ibss%.dec "%ipswname%.bundle\to-patch\%ibss%.dec" >NUL
if exist decrypted\%kernel%.dec move /y decrypted\%kernel%.dec "%ipswname%.bundle\to-patch\%kernel%.dec" >NUL 
if exist IPSW\%kernel% move /y IPSW\%kernel% "%ipswname%.bundle\to-patch\%kernel%.orig" >NUL 
if exist IPSW\%ibss% move /y IPSW\iBSS.%boardid%ap.RELEASE.dfu "%ipswname%.bundle\to-patch\%ibss%.orig" >NUL
if exist decrypted\lockdownd move /y decrypted\lockdownd "%ipswname%.bundle\to-patch\lockdownd" >NUL
if exist "%bundledir%\%ipswname%.bundle" rmdir "%bundledir%\%ipswname%.bundle" /S /Q >NUL
move "%ipswname%.bundle" "%bundledir%\%url_parsing_device%\%ipswname%.bundle" >nul

goto tehend

:tehend
::stop timer
set endtime=%time% 

set /a hrs=%endtime:~0,2% >NUL 2>NUL
set /a hrs=%hrs%-%starttime:~0,2% >NUL 2>NUL

set /a mins=%endtime:~3,2% >NUL 2>NUL
set /a mins=%mins%-%starttime:~3,2% >NUL 2>NUL

set /a secs=%endtime:~6,2% >NUL 2>NUL
set /a secs=%secs%-%starttime:~6,2% >NUL 2>NUL

if %secs% lss 0 ( 
    set /a secs=!secs!+60 >NUL 2>NUL
    set /a mins=!mins!-1 >NUL 2>NUL
)
if %mins% lss 0 (
    set /a mins=!mins!+60 >NUL 2>NUL
    set /a hrs=!hrs!-1 >NUL 2>NUL
)
if %hrs% lss 0 (
    set /a hrs=!hrs!+24 >NUL 2>NUL
)
set /a tot=%secs%+%mins%cmdln%60+%hrs%cmdln%3600 >NUL 2>NUL

echo - Took %hrs% hours, %mins% mins and %secs% seconds to complete^^! 

CALL :log info Finished.
CALL :log info ----------------------------------------------------------------------------------------------

echo - Press any key to exit..
echo ran > %tempdir%\finished.Done
pause >nul
goto end

:clean
cls
echo - Deleting un-needed files
cd %tempdir%
rmdir IPSW /S /Q >nul
rmdir kbags /S /Q >nul
del tools\iBSS* /S /Q >nul
del %tempdir%\*.txt /S /Q
echo - Cleaned - press any key to return to menu
pause >nul
goto both

:end
cls
cd %tempdir%
if exist IPSW\ rmdir IPSW /S /Q >nul
if exist rmdir kbags /S /Q >nul
del %tempdir%\*.txt /S /Q >NUL

exit

::---------------------------------------------------------------------------
:: down here are the large spammy bits that aren't changed often but take up
:: lots of space.
::---------------------------------------------------------------------------


:grabkbag

set filename=%~f1

for /F "tokens=5 delims=: " %%z in ('%tools%\xpwntool.exe %filename% %temp%\iKeyHelper\#') do set kbag=%%z 2>NUL >NUL

echo go fbecho - %~n1%~x1
echo go echo %~n1%~x1
echo go aes dec %kbag%

goto :EOF


:DeQuote
SET _DeQuoteVar=%1
CALL SET _DeQuoteString=%%!_DeQuoteVar!%%
IF [!_DeQuoteString:~0^,1!]==[^"] (
IF [!_DeQuoteString:~-1!]==[^"] (
SET _DeQuoteString=!_DeQuoteString:~1,-1!
) ELSE (GOTO :EOF)
) ELSE (GOTO :EOF)
SET !_DeQuoteVar!=!_DeQuoteString!
SET _DeQuoteVar=
SET _DeQuoteString=
GOTO :EOF

:sfn
set bundlename=%~n1.bundle
set shortipsw=%~n1.ipsw
goto :eof


:log

:: log messages

if not exist %logdir% mkdir %logdir% >NUL

if not .%1.==.. (
	if %1==error (
		echo [%time:~0,8%] [ERROR] %2 %3 %4 %5 %6 %7 %8 %9  >> %logdir%\%timestamp%
	) else if %1==info (
		echo [%time:~0,8%] [INFO] %2 %3 %4 %5 %6 %7 %8 %9 >> %logdir%\%timestamp%
	)
) else (
	echo Usage: log ^<info/error^>
)

goto eof

:: parse.bat - pretty epic really.

:parse
setlocal
set plist=
set string=
set data=
set data1=
set thedata=

if %1.==. goto plistparseusage
if %2.==. goto plistparseusage

set plist=%~f1
set string=%2

:: delete temp files

if exist %temp%\plistparse\ rmdir %temp%\plistparse /S /Q >NUL
if not exist %temp%\plistparse\ mkdir %temp%\plistparse >NUL

%tools%\binmay.exe -i %plist% -o %temp%\plistparse\tmp1 -s 0A 09 09 2>NUL
%tools%\binmay.exe -i %temp%\plistparse\tmp1 -o %temp%\plistparse\tmp2 -s 09 09 09 2>NUL

%tools%\ssr.exe 0 "</string>" "/SSR_NL/</string> " %temp%\plistparse\tmp2 >NUL

%tools%\ssr.exe 0 "<key>%string%</key><string>" "/SSR_NL/%string%:" %temp%\plistparse\tmp2 >NUL

FOR /F "tokens=2 delims=:" %%a IN ('find "%string%" ^<%temp%\plistparse\tmp2') DO SET data1=%%a 

echo %data1% >%temp%\plistparse\tmp3

set thedata1=

set data=

%tools%\binmay.exe -i %temp%\plistparse\tmp3 -o %temp%\plistparse\tmp4 -s 20 20 20 2>NUL

for /f "tokens=* delims= " %%a in (%temp%\plistparse\tmp4) do (

	set /a e+=1
	set thedata!e!=%%a

)

set data=%thedata1%

if "%data%"=="ECHOisoff." (
	set errorlevel=1
) else (


echo %data%
)
if exist %temp%\plistparse\ rmdir %temp%\plistparse /S /Q >NUL
endlocal
goto eof

:plistparseusage

echo usage: %0 ^<plist file^> ^<string^>
echo.
goto eof

:eof

endlocal
