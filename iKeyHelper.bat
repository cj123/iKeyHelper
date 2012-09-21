:: iKeyHelper
:: Copyright (C) 2012 Callum Jones
:: See attached license

:: if you get all the tools, pop them in resources\tools\

@ECHO OFF

title iKeyHelper

::------------------------------------------------------------------------------------

setlocal enableextensions enabledelayedexpansion


:beginning

set tools=%appdata%\iKeyHelper\bin
set logdir=%appdata%\iKeyHelper\logs
set tempdir=%temp%\iKeyHelper

if not exist %appdata%\iKeyHelper mkdir %appdata%\iKeyHelper >NUL
if not exist %tools% mkdir %tools% >NUL
if not exist %tempdir% mkdir %tempdir% >NUL
if not exist %logdir% mkdir %logdir% >NUL

if "%uuid%"=="" (
	set uuid=iKeyHelper~git
)

call :log #############################################################################
call :log Starting iKeyHelper v%version%
call :log #############################################################################


if "%uuid%"=="iKeyHelper~git" (
	REM check for tools
	call :toolcheck 7za.exe
	call :toolcheck binmay.exe
	call :toolcheck curl.exe
	call :toolcheck dmg.exe
	call :toolcheck genpass.exe
	call :toolcheck hfsplus.exe
	call :toolcheck iconv.dll
	call :toolcheck ideviceinfo.exe
	call :toolcheck injectpois0n.exe
	call :toolcheck intl.dll
	call :toolcheck irecovery.exe
	call :toolcheck libcurl.dll
	call :toolcheck libeay32.dll
	call :toolcheck libglib-2.0-0.dll
	call :toolcheck libpng12.dll
	call :toolcheck libssl32.dll
	call :toolcheck libxml2.dll
	call :toolcheck readline5.dll
	call :toolcheck ssr.exe
	call :toolcheck xpwntool.exe
	call :toolcheck zlib1.dll
)


title iKeyHelper v%version% - (c) 2012 cj 
cls

if not exist %UserProfile%\iKeyHelper mkdir %UserProfile%\iKeyHelper >NUL
if not exist "%UserProfile%\iKeyHelper\iKeyHelper.settings.bat" (
	echo Cannot find settings file.
	echo Downloading new settings file.
	pushd %UserProfile%\iKeyHelper
		call %tools%\curl -LO https://github.com/cj123/iKeyHelper/raw/master/resources/iKeyHelper.settings.bat --progress-bar
	popd
)


:: parse the settings
call %UserProfile%\iKeyHelper\iKeyHelper.settings.bat this-is-meant-to-be-run

if not exist %tempdir% mkdir %tempdir% >NUL

:: Run on startup
color 0%fontcolour%
cd %tempdir% 

:: delete me some stuffs

if exist * del * /S /Q >> %logme%
if exist dlipsw rmdir dlipsw /S /Q >> %logme%
if exist IPSW rmdir IPSW /S /Q >> %logme%
if exist tools rmdir tools /S /Q >> %logme%
if exist decrypted rmdir decrypted /S /Q >> %logme%
if exist *.txt del *.txt /S /Q >> %logme%

cls
cd %tools%
if not exist %appdata%\iKeyHelper\bin\genpass.exe (
	echo Extracting Files... 
	:: Extract the tools
	if not exist %tempdir% mkdir %tempdir% >nul
	if not exist %tools% mkdir %tools% >nul
	copy %MYFILES%\7za.exe %tools%\7za.exe >nul
	call 7za.exe x -y -mmt %appdata%\iKeyHelper\tools.zip >> %logme%
)

if "%viewlog%"=="yes" (
	if exist %tools%\baretail.exe (
		taskkill /F /IM "baretail.exe" 2>NUL >NUL
		start "" %tools%\baretail "%logme%"
	)
)

:: check for old files and remove them
call :log Clearing existing files
if exist %tempdir%\kbags rmdir /S /Q %tempdir%\kbags >> %logme%
if exist %tempdir%\IPSW rmdir /S /Q %tempdir%\IPSW >> %logme%
if exist %tempdir%\ipad-bb rmdir /S /Q %tempdir%\ipad-bb >> %logme%
if exist %tempdir%\dlipsw rmdir /S /Q %tempdir%\dlipsw >> %logme%
if exist %tempdir%\keys.txt del /S /Q if exist %tempdir%\keys.txt >> %logme%
if exist %tempdir%\kbags.txt del /S /Q %tempdir%\kbags.txt >> %logme%
cls	

goto top

:top

cd %tempdir%
cls

set IPSW=
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

if not exist %appdata%\iKeyHelper\readme.txt (
	call :log Opening ReadMe
	start 'http://www.icj.me/iKeyHelper'
	echo read >%appdata%\iKeyHelper\readme.txt
)

set /P quotedinfile=- File: %=%

:: Remove quotes from infile if they exist, then put them back ;)
CALL :dequote quotedinfile
set IPSW="%quotedinfile%"

if %IPSW%=="x" ( 
	goto downloadme
) else if %IPSW%=="dl" (
	goto downloadme
)

goto checkloop 

:downloadme
call :log Opening IPSW downloader...

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


if exist %tempdir%\dlipsw rmdir %tempdir%\dlipsw >NUL
if not exist %tempdir%\dlipsw mkdir %tempdir%\dlipsw >NUL

cd %tempdir%\dlipsw

if exist url.txt del url.txt /S /Q >NUL
echo - Fetching Link...

%tools%\curl -A "iKeyHelper - %uuid% - %version%" --silent http://api.ios.icj.me/v2/%dldevice%/%dlfw%/url -I>response.txt

:: check for multiple buildids
findstr "300 Multiple Choices" response.txt > nul

if errorlevel 1 (
	set downloadlink=http://api.ios.icj.me/v2/%dldevice%/%dlfw%
	goto downloadipsw
)

<nul set /p "= - Multiple BuildIDs Found: "
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

findstr "200 OK" response.txt > nul

if errorlevel 1 (
	echo - Error: Link not found.
	echo - Press any key to return to the IPSW downloader.
	call :log error Unable to find IPSW link
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
call :log downloading IPSW from %downloadlink%


echo --------------------------------------------------------------------------------
call %tools%\curl -LO %downloadlink% --progress-bar



call :log IPSW Name: %ipswName%
:: check for my HDD for IPSWs :P
if exist "G:\Apple Firmware" (
	call :log moving %ipswName% to "%UserProfile%\Desktop\%ipswName%"
	if not exist "G:\Apple Firmware\%dldevice%" mkdir "G:\Apple Firmware\%dldevice%" >NUL
	if not exist "G:\Apple Firmware\%dldevice%\Official" mkdir "G:\Apple Firmware\%dldevice%\Official" >NUL
	move /y "%ipswName%" "G:\Apple Firmware\%dldevice%\Official\%ipswName%" >> %logme%

	if not exist "G:\Apple Firmware\%dldevice%\Official\%ipswName%" (
		call :log error IPSW move failed
	) else (
		call :log IPSW move succeeded
	)

	set IPSW="G:\Apple Firmware\%dldevice%\Official\%ipswName%"
	cls
	echo - IPSW download finished^^! Saved to "G:\Apple Firmware\%dldevice%\Official\%ipswName%"

) else (
	call :log moving %ipswName% to "%UserProfile%\Desktop\%ipswName%"
	move /y "%ipswName%" "%UserProfile%\Desktop\%ipswName%" >> %logme%

	if not exist "%UserProfile%\Desktop\%ipswName%" (
		call :log error IPSW move failed
	) else (
		call :log IPSW move succeeded
	)

	set IPSW="%UserProfile%\Desktop\%ipswName%"
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

call :log Detected input file as %IPSW%

:: start the timer
set starttime=%time%

:: create userside directory
if not exist "%bundledir%" (
	mkdir "%bundledir%" >NUL
	call :log Making directory: %bundledir%
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

<nul set /p "= - Extracting Files... "

cd %tempdir%

:: extract ipsw except RootFS and Ramdisks
call :log Unzipping %IPSW%...
call %tools%\7za.exe e -oIPSW -mmt %IPSW% kernel* Firmware/* *.plist >> %logme%

echo Done^^!

<nul set /p "= - IPSW Info: " 

call :parse %tempdir%\IPSW\Restore.plist ProductVersion
call :parse %tempdir%\IPSW\Restore.plist MarketingVersion

if not %ProductVersion%==%MarketingVersion% (
	set marketingversionexists=yes
	set MarketingVersiontitle= [%MarketingVersion%]
) else (
	set marketingversionexists=no
)

<nul set /p "= iOS %ProductVersion%%MarketingVersiontitle% "

call :parse %tempdir%\IPSW\Restore.plist Platform
call :parse %tempdir%\IPSW\BuildManifest.plist BuildTrain
call :parse %tempdir%\IPSW\Restore.plist ProductType 
call :parse %tempdir%\IPSW\BuildManifest.plist BuildNumber

<nul set /p "= (%BuildNumber%) "

if exist %tempdir%\temp.txt del %tempdir%\temp.txt /S /Q >> %logme%
if exist %tempdir%\sha1.txt del %tempdir%\sha1.txt /S /Q >> %logme%

for %%a in (%IPSW%) do (
	set /a sizeofipsw=%%~za / 1048576
)

call :log %shortipsw% size: %sizeofipsw%MB

set bdid=%ProductType:,=%
call :tolowercase %bdid%

call :log Getting Device Definitions...

pushd %UserProfile%\iKeyHelper
	call %tools%\curl -LO --silent https://github.com/cj123/iKeyHelper/raw/master/resources/device_definitions.bat >> %logme%
popd
call %UserProfile%\iKeyHelper\device_definitions.bat %bdid%

<nul set /p "= for %deviceid% "

if exist %tempdir%\boardid rmdir %tempdir%\boardid /S /Q >NUL

call :log Device recognized as %deviceid%

title iKeyHelper v%version% running %deviceid%, iOS %ProductVersion%%MarketingVersiontitle% (%BuildNumber%) - (c) 2012 cj 

:: ipsw name
set ipswname=%shortipsw:_Restore.ipsw=%
set ipswname=%ipswname: =%

:: baseband version detection
call :log Detecting Baseband version 

pushd %tempdir%\IPSW

if exist baseband.txt del baseband.txt /S /Q >NUL

if "%boardid%"=="n90" (
	dir /B /OS *.Release.bbfw >>baseband.txt
	%tools%\ssr.exe 0 "ICE3_" "Baseband:" baseband.txt
	%tools%\ssr.exe 0 "_BOOT_" /SSR_NL/ baseband.txt
	:: yay a fun bit
	FOR /F "tokens=2 delims=:" %%a IN ('find "Baseband" ^<baseband.txt') DO set baseband=%%a 
) else if "%boardid%"=="n90b" (
	dir /B /OS *.Release.bbfw >>baseband.txt
	%tools%\ssr.exe 0 "ICE3_" "Baseband:" baseband.txt
	%tools%\ssr.exe 0 "_BOOT_" /SSR_NL/ baseband.txt
	:: yay a fun bit
	FOR /F "tokens=2 delims=:" %%a IN ('find "Baseband" ^<baseband.txt') DO set baseband=%%a 
) else if "%boardid%"=="n94" (
	dir /B /OS Trek-*.Release.bbfw >>baseband.txt
	%tools%\ssr.exe 0 "Trek-" "Baseband:" baseband.txt
	%tools%\ssr.exe 0 ".Release.bbfw" /SSR_NL/ baseband.txt
	:: yay a fun bit
	FOR /F "tokens=2 delims=:" %%a IN ('find "Baseband" ^<baseband.txt') DO set baseband=%%a 
) else if "%boardid%"=="n92" (
	:: should be Phoenix-VE.RS.ION.Release.bbfw ?
	::del Phoenix* /S /Q >NUL 2>NUL
	dir /B /OS *.Release.bbfw >>baseband.txt
	%tools%\ssr.exe 0 "Phoenix-" "Baseband:" baseband.txt
	%tools%\ssr.exe 0 ".Release" /SSR_NL/ baseband.txt
	:: yay a fun bit
	FOR /F "tokens=2 delims=:" %%a IN ('find "Baseband" ^<baseband.txt') DO set baseband=%%a 
) else (
	call :log This device does not have a baseband^^! [or-baseband-detection-is-not-supported]
	set baseband=
)
popd 
if "%boardid%"=="n90" ( 
	echo - Baseband %baseband%
) else if "%boardid%"=="n92" ( 
	echo - Baseband %baseband%
) else if "%boardid%"=="n90b" ( 
	echo - Baseband %baseband%
) else (
	REM yes this is important
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
set detectedDevice=%detectedDevice: =%

set detectedID=
for /F "tokens=2 delims=: " %%v in ('%tools%\ideviceinfo.exe ^| findstr "ProductType"') do set detectedID=%%v
%tools%\ideviceinfo.exe | find /I /N "No device found">NUL
	
if "%ERRORLEVEL%"=="1" (
	echo Found device^^!
	call :log Device found in NORMAL mode.
) else (
	ping localhost -n 6 >nul
	CALL :log error No NORMAL device found. Rechecking...
	goto devicecheck
)
call :log if not "%detectedDevice%"=="%boardid%ap"
call :log Device is %detectedDevice%.
if /I not "%detectedDevice%"=="%boardid%ap" (
	echo -^^!- Error: You have not plugged in a %deviceid%^^! This is an %detectedID%.
	echo - Press any key to return to main screen...
	pause >NUL
	goto beginning
)

goto nodevicecheck

:nodevicecheck

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

if exist %tempdir%\IPSW\oldstyle.txt del %tempdir%\IPSW\oldstyle.txt /S /Q >> %logme%

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

:: replace User with restore, for easier identification

%tools%\ssr.exe 1 "User" "Restore" %tempdir%\Restore2.txt
%tools%\ssr.exe 1 "User" "NotherRD" %tempdir%\Restore2.txt
%tools%\ssr.exe 1 "User" "RootFS" %tempdir%\Restore2.txt

%tools%\binmay.exe -i %tempdir%\Restore2.txt -o %tempdir%\Restore4.txt -s 20 20 20 2>NUL

%tools%\ssr.exe 0 ".dmg" ".dmg/SSR_NL/" %tempdir%\Restore4.txt >NUL

:: set restore as the word after Restore:
FOR /F "tokens=2 delims=:" %%a IN ('find "Restore" ^<%tempdir%\Restore4.txt') DO set restore=%%a 
FOR /F "tokens=2 delims=:" %%a IN ('find "NotherRD" ^<%tempdir%\Restore4.txt') DO set notherRD=%%a 

if "%notherRD%"=="%restore%" (
	FOR /F "tokens=2 delims=:" %%a IN ('find "RootFS" ^<%tempdir%\Restore4.txt') DO set rootfilesystem=%%a 
) else (
	set rootfilesystem=%notherRD%
)

:: same as above but for update
FOR /F "tokens=2 delims=:" %%a IN ('find "Update" ^<%tempdir%\Restore4.txt') DO set update=%%a 

FOR /F "tokens=2 delims=:" %%a IN ('find "Update" ^<%tempdir%\Restore4.txt') DO set updateishere=yes

if exist %tempdir%\Restore4.txt del %tempdir%\Restore4.txt /S /Q >NUL

:: checking ramdisk numbers!!!
set update=%update: =%
set restore=%restore: =%
set rootfilesystem=%rootfilesystem: =%

if "%updateishere%"=="yes" (
	echo %update%> dmgs.txt
	set updateishere=yes
)

echo %restore%>> dmgs.txt
echo %rootfilesystem%>> dmgs.txt

::%tools%\binmay.exe -i %tempdir%\IPSW\dmgs.txt -o %tempdir%\IPSW\dmgs-f.txt -s 20 20 20 2>NUL
::ping -n 3 localhost >NUL
REM for /f "tokens=* delims= " %%a in (%tempdir%\IPSW\dmgs.txt) do (
	REM set /a n+=1
	REM set ramdisk!n!=%%a
REM )

REM if not "%updateishere%"=="yes" (
	REM CALL :log error No Update Ramdisk. Continuing...
	REM set restore=%ramdisk1%
	REM set rootfilesystem=%ramdisk2%
REM ) else (
    REM :: assume all 3 ramdisks are there. 
	REM set update=%ramdisk1%
	REM set restore=%ramdisk2%
	REM set rootfilesystem=%ramdisk3%
REM )
echo Done^^!

call :log Ramdisks-Update-%update%-Restore-%restore%-Rootfs-%rootfilesystem%

%tools%\7za.exe e -o%tempdir%\IPSW -mmt %IPSW% %update% %restore% >> %logdir%\%timestamp%


echo bgcolor 0 0 0 >>%tempdir%\kbags.txt 

echo go fbecho iKeyHelper v%version% by Callum Jones ^<cj@icj.me^> >>%tempdir%\kbags.txt
echo go fbecho ========================================>>%tempdir%\kbags.txt
echo go fbecho - Loading iOS %ProductVersion%%MarketingVersiontitle% (%BuildNumber%) >>%tempdir%\kbags.txt 
echo go fbecho ^> for %ProductType% (%url_parsing_device%) >>%tempdir%\kbags.txt 
echo go fbecho ========================================>>%tempdir%\kbags.txt

if exist *.txt del *.txt /S /Q >NUL
if exist *asr del *asr /S /Q >NUL

call :log Getting KBAGs...
:: delete the files

if exist %tempdir%\Restore.txt del %tempdir%\Restore.txt /S /Q >NUL
if exist %tempdir%\Restore1.txt del %tempdir%\Restore1.txt /S /Q >NUL
if exist %tempdir%\Restore2.txt del %tempdir%\Restore2.txt /S /Q >NUL

:kbags

<nul set /p "= - Grabbing KBAGs... "

call :grabkbag %LLB% >>%tempdir%\kbags.txt
call :grabkbag %iBoot% >>%tempdir%\kbags.txt 
call :grabkbag %devicetree% >>%tempdir%\kbags.txt 
call :grabkbag %applelogo% >>%tempdir%\kbags.txt 
call :grabkbag %recoverymode% >>%tempdir%\kbags.txt 
call :grabkbag %batterylow0% >>%tempdir%\kbags.txt 
call :grabkbag %batterylow1% >>%tempdir%\kbags.txt 
call :grabkbag %glyphcharging% >>%tempdir%\kbags.txt 
call :grabkbag %glyphplugin% >>%tempdir%\kbags.txt 
call :grabkbag %batterycharging0% >>%tempdir%\kbags.txt 
call :grabkbag %batterycharging1% >>%tempdir%\kbags.txt 
call :grabkbag %batteryfull% >>%tempdir%\kbags.txt 
call :grabkbag %ibss% >>%tempdir%\kbags.txt 
call :grabkbag %ibec% >>%tempdir%\kbags.txt 
call :grabkbag %kernel% >>%tempdir%\kbags.txt 


pushd %tempdir%\IPSW\
:: run this TWICE.
if exist %tempdir%\IPSW\%restore% (
	%tools%\xpwntool.exe %tempdir%\IPSW\%restore% %tempdir%\IPSW\%restore%.dec >NUL 2>NUL
	%tools%\hfsplus %tempdir%\IPSW\%restore%.dec extract /usr/sbin/asr %restore:~0,-4%_asr >NUL 2>NUL
	if not exist %restore:~0,-4%_asr ( 
		::echo doing RESTORE
		set restoreenc=y
		call :log Restore is encrypted
		call :grabkbag %restore% >>%tempdir%\kbags.txt
	) else (
		set restoreenc=n
		call :log Restore not encrypted
		echo go echo %restore% >>%tempdir%\kbags.txt
		echo go echo *Not_Encrypted >>%tempdir%\kbags.txt
	)
)

if "%updateishere%"=="yes" (
	%tools%\xpwntool.exe %tempdir%\IPSW\%update% %tempdir%\IPSW\%update%.dec >NUL 2>NUL
	%tools%\hfsplus %tempdir%\IPSW\%update%.dec extract /usr/sbin/asr %update:~0,-4%_asr >NUL 2>NUL
	if not exist %update:~0,-4%_asr (
		::echo DOING UPDATE
		set updateenc=y
		call :log Update is encrypted
		call :grabkbag %update% >>%tempdir%\kbags.txt
	) else (
		set updateenc=n
		call :log Update is not encrypted
		echo go echo %update% >>%tempdir%\kbags.txt
		echo go echo *Not_Encrypted >>%tempdir%\kbags.txt
	)
)

:: remove files
if exist %update:~0,-4%_asr del %update:~0,-4%_asr /S /Q >NUL
if exist %restore:~0,-4%_asr del %restore:~0,-4%_asr /S /Q >NUL
if exist %update%.dec del %update%.dec /S /Q >NUL
if exist %restore%.dec del %restore%.dec /S /Q >NUL

popd

echo go fbecho ===================================>>%tempdir%\kbags.txt
echo go fbecho - Done>>%tempdir%\kbags.txt 
echo go fbecho - Rebooting...>>%tempdir%\kbags.txt
echo go fbecho ===================================>>%tempdir%\kbags.txt

echo Done^^!
echo /exit >>%tempdir%\kbags.txt

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


::checking for dfu
<nul set /p "= - Please Enter DFU mode... "
goto dfucheck

:dfucheck
%tools%\irecovery.exe -c | find /I /N "DFU">> %logme%

if "%ERRORLEVEL%"=="0" (
	echo Found device^^!
	call :log Device found in DFU mode.
) else (
	ping localhost -n 6 >nul
	CALL :log error No DFU device found. Rechecking...
	goto dfucheck
)

:found-recovery
call %tools%\irecovery.exe -c "setenv boot-args 2" >> %logme%
call %tools%\irecovery.exe -c "saveenv" >> %logme%

call :log Extracting RootFS
start /B "" %tools%\7za.exe e -o%tempdir%\IPSW -mmt %IPSW% %rootfilesystem% >NUL

cd %tempdir%

:: injectpois0n
call :log Starting Injectpois0n.
<nul set /p "= - Running injectpois0n... "
call %tools%\injectpois0n.exe -2 >> %logdir%\%timestamp% 2>NUL
call :log Injectpois0n finished.
if exist %tempdir%\iBSS* del %tempdir%\iBSS* /S /Q >> %logme%
echo Done^^!

goto elsewhere

:elsewhere

:: run irecovery -s to get rid of unneeded junk :)

start /B %tools%\irecovery -s >> %logme%
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
%tools%\irecovery -s gp-keys.txt < kbags.txt >> %logme%

cd %tempdir%\IPSW\

goto loop1

:loop1
tasklist /FI "IMAGENAME eq irecovery.exe" 2>NUL | find /I /N "irecovery.exe">NUL

if "%ERRORLEVEL%"=="0" (
	goto loop1
) 

:: reboot 

call :log Rebooting Device. 
<nul set /p "= Rebooting... "
%tools%\irecovery -c "setenv auto-boot true" >> %logme%
%tools%\irecovery -c "saveenv" >> %logme%
%tools%\irecovery -c "reboot" >> %logme%


echo Done^^!

call :log formatting text file.
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
	%tools%\7za.exe e -o%tempdir%\IPSW -mmt %IPSW% %rootfilesystem% >> %logme%
)

if not exist %tempdir%\decrypted mkdir %tempdir%\decrypted\ >NUL

cd %tempdir%

if exist %tempdir%\decrypted\%update%.dec del %tempdir%\decrypted\%update%.dec /S /Q >NUL
if exist %tempdir%\decrypted\%restore%.dec del %tempdir%\decrypted\%restore%.dec /S /Q >NUL

call :log Update Ramdisk Shiz
if not "%update%"=="" (
	if not "%updateenc%"=="n" (
		%tools%\xpwntool %tempdir%\IPSW\%update% %tempdir%\decrypted\%update%.dec -iv %iv19% -k %key19% >NUL
	) else (
		%tools%\xpwntool %tempdir%\IPSW\%update% %tempdir%\decrypted\%update%.dec >NUL
	)
)
call :log Restore Ramdisk Shiz
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
	call :log Found extracted RootFS
)

<nul set /p "= - Getting RootFS Key... "
call :log Getting RootFS Key using restore
%tools%\genpass.exe -p %platform% -r decrypted/%restore%.dec -f IPSW/%rootfilesystem% >%tempdir%\IPSW\genpass.txt 2>NUL

findstr /C:"vfdecrypt key" %tempdir%\IPSW\genpass.txt >NUL

if not "%ERRORLEVEL%"=="0" (
	CALL :log error RootFS key not found -trying update
	%tools%\genpass.exe -p %platform% -r decrypted/%update%.dec -f IPSW/%rootfilesystem% >%tempdir%\IPSW\genpass.txt 2>NUL
)

call :log Decrypting RootFS TEST
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



if "%bdid%"=="ipad11" goto ipadbb
if "%bdid%"=="iphone21" goto ipadbb
goto noipadbb

:ipadbb
:: Get the baseband for iPad from ramdisk
if exist %tempdir%\ipad-bb rmdir %tempdir%\ipad-bb /S /Q >NUL
call :log Getting iPad/3G[S] Baseband
if not exist %tempdir%\ipad-bb mkdir %tempdir%\ipad-bb

pushd %tempdir%\ipad-bb
	:: hfsplus to the rescue! (lol)
	%tools%\hfsplus "%tempdir%\decrypted\%restore%.dec" extractall /usr/local/standalone/firmware/ >NUL 2>NUL
	:: check if its wrapped in a BBFW file
	if exist ICE2.Release.bbfw (
		call :log BBFW EXISTS
		%tools%\7za x -y -mmt ICE2.Release.bbfw >NUL
	) else (
		call :log BBFW NO EXISTY
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
	call :log iPad/3G[S]Baseband: %baseband%
popd

goto noipadbb

:noipadbb
 
:: i'm sure there's a reason behind this but at the moment it looks absolutely stupid.
echo . >NUL

pushd %temp%\iKeyHelper

:: get url for firmware
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

if not %MarketingVersion%==%ProductVersion% (
	if not "%downloadurl%"=="" (
		echo  ^| version             = %ProductVersion% ^(%MarketingVersion%^)>>iphonewikikeys.txt
	) else (
		echo  ^| version             = %ProductVersion% ^(%MarketingVersion%^) b[number]>>iphonewikikeys.txt
	)
	
) else (
	if not "%downloadurl%"=="" (
		echo  ^| version             = %ProductVersion%>>iphonewikikeys.txt
	) else (
		echo  ^| version             = %ProductVersion%b[number]>>iphonewikikeys.txt
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

start "" notepad "%bundledir%\%url_parsing_device%\%ipswname%.txt"

:: create a plist file for this.

if not exist %MYFILES%\Template.plist.txt (
	call :log error No Template.plist.txt... skipping
	goto urlopen
)

move /y %MYFILES%\Template.plist.txt %tempdir%\Template.plist.txt >nul

%tools%\ssr.exe 0 "[BoardConfig]" "%boardid%ap" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[iBSSName]" "%ibss%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[iBSSIV]" "%iv15%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[iBSSKey]" "%key15%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[RecoveryModeName]" "%recoverymode%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[RecoveryModeIV]" "%iv7%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[RecoveryModeKey]" "%key7%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[DeviceTreeName]" "%devicetree%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[DeviceTreeIV]" "%iv5%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[DeviceTreeKey]" "%key5%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[GlyphChargingName]" "%glyphcharging%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[GlyphChargingIV]" "%iv10%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[GlyphChargingKey]" "%key10%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[BatteryCharging1Name]" "%batterycharging1%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BatteryCharging1IV]" "%iv13%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BatteryCharging1Key]" "%key13%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[iBootName]" "%iboot%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[iBootIV]" "%iv4%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[iBootKey]" "%key4%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[BatteryCharging0Name]" "%batterycharging0%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BatteryCharging0IV]" "%iv12%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BatteryCharging0Key]" "%key12%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[BatteryLow0Name]" "%batterylow0%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BatteryLow0IV]" "%iv8%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BatteryLow0Key]" "%key8%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[LLBName]" "%llb%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[LLBIV]" "%iv3%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[LLBKey]" "%key3%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[iBECName]" "%ibec%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[iBECIV]" "%iv16%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[iBECKey]" "%key16%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[KernelCacheName]" "%kernel%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[KernelCacheIV]" "%iv17%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[KernelCacheKey]" "%key17%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[RootFileSystemDMG]" "%rootfilesystem%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[RootFileSystemKey]" "%rtkey%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[AppleLogoName]" "%applelogo%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[AppleLogoIV]" "%iv6%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[AppleLogoKey]" "%key6%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[UpdateRamdiskDMG]" "%update%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[UpdateRamdiskIV]" "%iv19%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[UpdateRamdiskKey]" "%key19%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[RestoreRamdiskDMG]" "%restore%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[RestoreRamdiskIV]" "%iv18%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[RestoreRamdiskKey]" "%key18%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[GlyphPluginName]" "%glyphplugin%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[GlyphPluginIV]" "%iv11%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[GlyphPluginKey]" "%key11%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[BatteryLow1Name]" "%batterylow1%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BatteryLow1IV]" "%iv9%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BatteryLow1Key]" "%key9%" %tempdir%\Template.plist.txt

%tools%\ssr.exe 0 "[FirmwareVersion]" "%ProductVersion%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[FirmwareURL]" "%downloadurl%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BuildID]" "%BuildNumber%" %tempdir%\Template.plist.txt
%tools%\ssr.exe 0 "[BuildTrain]" "%BuildTrain%" %tempdir%\Template.plist.txt

move /y "%tempdir%\Template.plist.txt" "%bundledir%\%url_parsing_device%\%ipswname%.plist" >nul
echo - Saved Keys and Plist files to "%bundledir%"

:urlopen
echo - Opening theiphonewiki page for %BuildTrain% %BuildNumber% (%url_parsing_device%)...
call :log Opening theiphonewiki page for %BuildTrain%_%BuildNumber% ...
start http://theiphonewiki.com/wiki/index.php?title=%BuildTrain%_%BuildNumber%_(%deviceidw%)^&action=edit

cd %tempdir%

if not "%rtkey%"=="" (
	<nul set /p "= - Decrypting Root Filesystem... "
	if exist "%tempdir%\decrypted\%rootfilesystem%.dec" del "%tempdir%\decrypted\%rootfilesystem%.dec" /S /Q >NUL
	%tools%\dmg.exe extract %tempdir%\IPSW\%rootfilesystem% %tempdir%\decrypted\%rootfilesystem%.dec -k %rtkey% >NUL
	echo Done^^!
) else (
	call :log error Cannot decrypt RootFS
	echo - Unable to decrypt Root Filesystem :(
)

pushd %tempdir%\decrypted 

<nul set /p "= - Decrypting other files... "

call :log Decrypting %applelogo%
%tools%\xpwntool.exe %tempdir%\IPSW\%applelogo% %applelogo%.dec -iv %iv6% -k %key6% >> %logdir%\%timestamp% 

call :log Decrypting %LLB%
%tools%\xpwntool.exe %tempdir%\IPSW\%LLB% %LLB%.dec -iv %iv3% -k %key3% >> %logdir%\%timestamp%

call :log Decrypting %iBoot%
%tools%\xpwntool.exe %tempdir%\IPSW\%iBoot% %iBoot%.dec -iv %iv4% -k %key4% >> %logdir%\%timestamp%

call :log Decrypting %devicetree%
%tools%\xpwntool.exe %tempdir%\IPSW\%devicetree% %devicetree%.dec -iv %iv5% -k %key5% >> %logdir%\%timestamp%

call :log Decrypting %recoverymode%
%tools%\xpwntool.exe %tempdir%\IPSW\%recoverymode% %recoverymode%.dec -iv %iv7% -k %key7% >> %logdir%\%timestamp%

call :log Decrypting %batterylow0%
%tools%\xpwntool.exe %tempdir%\IPSW\%batterylow0% %batterylow0%.dec -iv %iv8% -k %key8% >> %logdir%\%timestamp%

call :log Decrypting %batterylow1%
%tools%\xpwntool.exe %tempdir%\IPSW\%batterylow1% %batterylow1%.dec -iv %iv9% -k %key9% >> %logdir%\%timestamp%

call :log Decrypting %glyphcharging%
%tools%\xpwntool.exe %tempdir%\IPSW\%glyphcharging% %glyphcharging%.dec -iv %iv10% -k %key10% >> %logdir%\%timestamp%

call :log Decrypting %glyphplugin%
%tools%\xpwntool.exe %tempdir%\IPSW\%glyphplugin% %glyphplugin%.dec -iv %iv11% -k %key11% >> %logdir%\%timestamp%

call :log Decrypting %batterycharging0%
%tools%\xpwntool.exe %tempdir%\IPSW\%batterycharging0% %batterycharging0%.dec -iv %iv12% -k %key12% >> %logdir%\%timestamp%

call :log Decrypting %batterycharging1%
%tools%\xpwntool.exe %tempdir%\IPSW\%batterycharging1% %batterycharging1%.dec -iv %iv13% -k %key13% >> %logdir%\%timestamp%

call :log NOT Decrypting %batteryfull%

:: This doesn't work, and I don't care why.
:: %tools%\xpwntool.exe %tempdir%\IPSW\%batteryfull% %batteryfull%.dec -iv %iv14% -k %key14% >> %logdir%\%timestamp%

call :log Decrypting %ibss%
%tools%\xpwntool.exe %tempdir%\IPSW\%ibss% %ibss%.dec -iv %iv15% -k %key15% >> %logdir%\%timestamp%

call :log Decrypting %ibec%
%tools%\xpwntool.exe %tempdir%\IPSW\%ibec% %ibec%.dec -iv %iv16% -k %key16% >> %logdir%\%timestamp%

call :log Decrypting %kernel%
%tools%\xpwntool.exe %tempdir%\IPSW\%kernel% %kernel%.dec -iv %iv17% -k %key17% >> %logdir%\%timestamp%

echo Done^^!

popd

<nul set /p "= - Extracting files from DMGs... "
call :log Extracting files from the DMGs
if not "%rtkey%"=="" (
	%tools%\hfsplus %tempdir%\decrypted\%rootfilesystem%.dec extract /etc/fstab %tempdir%\decrypted\fstab >NUL
	call :log - fstab
	%tools%\hfsplus %tempdir%\decrypted\%rootfilesystem%.dec extract /System/Library/Lockdown/Services.plist %tempdir%\decrypted\Services.plist >NUL
	call :log - Services.plist
	%tools%\hfsplus %tempdir%\decrypted\%rootfilesystem%.dec extract /usr/libexec/lockdownd %tempdir%\decrypted\lockdownd
	call :log - lockdownd
)
%tools%\hfsplus %tempdir%\decrypted\%restore%.dec extract /usr/sbin/asr %tempdir%\decrypted\asr >NUL
call :log - asr
echo Done^^!


cd %tempdir%
if exist *.bundle rmdir *.bundle /S /Q >> %logme%
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

call :log Finished.
call :log ----------------------------------------------------------------------------------------------

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

if exist %temp%\iKeyHelper\# del %temp%\iKeyHelper\# /S /Q >NUL

goto :EOF


:DeQuote
set _DeQuoteVar=%1
call set _DeQuoteString=%%!_DeQuoteVar!%%
if [!_DeQuoteString:~0^,1!]==[^"] (
if [!_DeQuoteString:~-1!]==[^"] (
set _DeQuoteString=!_DeQuoteString:~1,-1!
) else (goto :eof)
) else (goto :eof)
set !_DeQuoteVar!=!_DeQuoteString!
set _DeQuoteVar=
set _DeQuoteString=
goto :eof

:sfn
set bundlename=%~n1.bundle
set shortipsw=%~n1.ipsw
goto :eof


:log

:: log messages

if not exist %logdir% mkdir %logdir% >NUL
set timestamp=iKeyHelper_%version%.log
set logme=%logdir%\%timestamp%
if not exist %logme% echo. >%logme%
if not "%1"=="" (
	if "%1"=="error" (
		echo [%time:~0,8%] [ERROR] %2 %3 %4 %5 %6 %7 %8 %9  >>%logme%
	) else (
		echo [%time:~0,8%] [INFO] %1 %2 %3 %4 %5 %6 %7 %8 %9 >>%logme%
	)
) else (
	echo Usage: log ^[error^]
)

goto eof

:: parse.bat - pretty epic really.

:parse
if exist %temp%\plistparse\ rmdir %temp%\plistparse /S /Q 


if %1.==. goto plistparseusage
if %2.==. goto plistparseusage

set plist=%~f1
set string=%2

::echo You want me to parse "%string%" from "%plist%".

:: delete temp files

if exist %temp%\plistparse\ rmdir %temp%\plistparse /S /Q >NUL
if not exist %temp%\plistparse\ mkdir %temp%\plistparse >NUL

%tools%\binmay.exe -i %plist% -o %temp%\plistparse\tmp1 -s 0A 09 09 2>NUL
%tools%\binmay.exe -i %temp%\plistparse\tmp1 -o %temp%\plistparse\tmp2 -s 09 09 09 2>NUL

%tools%\ssr.exe 0 "</string>" "/SSR_NL/</string> " %temp%\plistparse\tmp2 >NUL

%tools%\ssr.exe 0 "<key>%string%</key><string>" "/SSR_NL/%string%:" %temp%\plistparse\tmp2 >NUL

FOR /F "tokens=2 delims=:" %%a IN ('find "%string%" ^<%temp%\plistparse\tmp2') DO set data1=%%a 

echo %data1% >%temp%\plistparse\tmp3

set thedata1=

set data=

%tools%\binmay.exe -i %temp%\plistparse\tmp3 -o %temp%\plistparse\tmp4 -s 20 20 20 2>NUL

set /p data=<%temp%\plistparse\tmp4


if "%data%"=="ECHOisoff." (
	set errorlevel=1
) else (
	if "%3"=="echo" (
		echo %data%
	)
	set %string%=%data%
)
if exist %temp%\plistparse\ rmdir %temp%\plistparse /S /Q >> %logme%

goto eof

:plistparseusage

echo usage: %0 ^<plist file^> ^<string^>
echo.
goto eof

:tolowercase
:: thanks to http://www.robvanderwoude.com/battech_convertcase.php
set %~1=!%1:A=a!
set %~1=!%1:B=b!
set %~1=!%1:C=c!
set %~1=!%1:D=d!
set %~1=!%1:E=e!
set %~1=!%1:F=f!
set %~1=!%1:G=g!
set %~1=!%1:H=h!
set %~1=!%1:I=i!
set %~1=!%1:J=j!
set %~1=!%1:K=k!
set %~1=!%1:L=l!
set %~1=!%1:M=m!
set %~1=!%1:N=n!
set %~1=!%1:O=o!
set %~1=!%1:P=p!
set %~1=!%1:Q=q!
set %~1=!%1:R=r!
set %~1=!%1:S=s!
set %~1=!%1:T=t!
set %~1=!%1:U=u!
set %~1=!%1:V=v!
set %~1=!%1:W=w!
set %~1=!%1:X=x!
set %~1=!%1:Y=y!
set %~1=!%1:Z=z!

goto eof


:toolcheck

if not exist resources\tools\%1 (
	if not exist %tools%\%1 (
		call :log error tool: %1 not found
		echo Error: %1 not found
		pause
	)
) else (
	call :log Found tool: %1
	if not exist "%tools%\%1" (
		copy /y resources\tools\%1 %tools%\%1 >> %logme%
	)
)
goto eof


:eof