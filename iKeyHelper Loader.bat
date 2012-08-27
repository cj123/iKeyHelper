:: iKeyHelper Loader
:: (c) Callum Jones <cj@icj.me>
:: probably not of use to anyone, but meh ;P

@echo OFF
setlocal
setlocal enabledelayedexpansion

goto top

:top

title Loading iKeyHelper...

:: get the log datestamp
reg copy "HKCU\Control Panel\International" "HKCU\Control Panel\International-Temp" /f >NUL
reg add "HKCU\Control Panel\International" /v sShortDate /d "dd-MM-yy" /f >NUL
set LogDate=%date%
reg copy "HKCU\Control Panel\International-Temp" "HKCU\Control Panel\International" /f >NUL

set logdir=%appdata%\iKeyHelper\logs
set logfile=%logdir%\iKeyHelper_Loader-%LogDate%.log


:: variables
set workingDir=%appdata%\iKeyHelper
set tempDir=%temp%\iKeyHelper
set tools=%workingDir%\bin

:: wipe clean

if "%1%"=="clean" goto clean
if exist %workingDir%\version.check (
	echo This is a previous version, wiping files
	call :clean
	goto :top
)
call :log info ---------------------------------------------------------------------------------
call :log info Starting iKeyHelper Loader.
call :log info ---------------------------------------------------------------------------------
:: create the directories
call :log info Creating directories...
if not exist %workingDir% mkdir %workingDir% >NUL
if not exist %tempDir% mkdir %tempDir% >NUL
if not exist %tools% mkdir %tools% >NUL

:: unpack tools from "compiled" exe
if not exist "%tools%\curl.exe" ( copy "%MYFILES%\curl.exe" "%tools%\curl.exe" >NUL )
if not exist "%tools%\libeay32.dll" ( copy "%MYFILES%\libeay32.dll" "%tools%\libeay32.dll" >NUL )
if not exist "%tools%\libssl32.dll" ( copy "%MYFILES%\libssl32.dll" "%tools%\libssl32.dll" >NUL )

if not exist %UserProfile%\iKeyHelper\iKeyHelper.settings.bat (
	echo No settings file found, downloading standard configuration...
	%tools%\curl -L -A "iKeyHelper %uuid%" --silent http://hidden.iKeyHelper.icj.me/resources/iKeyHelper.settings.bat > "%UserProfile%\iKeyhelper\iKeyHelper.settings.bat"
	echo Settings file saved to %UserProfile%\iKeyHelper\iKeyHelper.settings.bat
)

cls 
echo Parsing Settings file... 
call :log info Parsing settings file...
call %UserProfile%\iKeyHelper\iKeyHelper.settings.bat this-is-meant-to-be-run

color 0%fontcolour%


:: generate the UUID
pushd %tools%
	if not exist uuid.exe (
		call :log info Downloading UUID.exe
		curl -LO -A "iKeyHelper Loader" --silent http://www.icj.me/~cj/uuid.exe
	)
	for /F "tokens=2 delims=: " %%a IN ('uuid.exe ^| find "UUID"') DO SET uuid=%%a
	call :log info UUID: %uuid%
popd

:: previous version

pushd %workingDir%
	for /F "tokens=* delims= " %%a IN ('dir /OS /B iKeyHelper-*') do set file=%%a >NUL
	if "%file:~16,1%"=="-" (
		set previousversion=%file:~11,7%
	) else (
		set previousversion=%file:~11,5%
	)
popd

:: first time run
if not exist "%workingDir%\version.check.bat" (
	cls & echo First time run detected. Downloading necessary files...
	pushd %workingDir%
		%tools%\curl -LO -A "iKeyHelper Loader - %uuid%" --silent http://hidden.iKeyHelper.icj.me/resources/tools.zip >NUL
		set previousversion=0.0
	popd
	
	:: if its only offering a beta version, download it
	set downloadbetas=yes
)




pushd %workingDir%
	if not exist version.check.bat goto :versioncheck

	:: dont check for updates if the settings file tells you not to
	if "%checkforupdates%"=="no" (
		call :log info Not checking for updates.
		set downloadedversion=%previousversion%
		goto :start
	)
	call :log info previous version: %previousversion%
	goto :versioncheck
	:: check for updates
	:versioncheck
	call :log info Downloading update.bat
	%tools%\curl -L -A "iKeyHelper Loader - %uuid%" --silent http://hidden.iKeyHelper.icj.me/version.bat >version.check.bat

	call version.check.bat
	set downloadedversion=%version%
	
	:: beta versions
	echo %downloadedversion% | find "~b" >NUL
	if %errorlevel%==0 (
		if "%downloadbetas%"=="no" (
			call :log info Not downloading betas
			set downloadedversion=%previousversion%
			goto :start
		)
	)
	
	if %downloadedversion% GTR %previousversion% (
		call :log info Found new version: %downloadedversion%
		cls & echo New version ^(%downloadedversion%^) detected. Downloading...
		%tools%\curl -L -A "iKeyHelper Loader - %uuid%" --silent http://hidden.iKeyHelper.icj.me/builds/%downloadedversion%.exe >iKeyHelper-%downloadedversion%.exe
		if exist iKeyHelper-%previousversion%.exe del iKeyHelper-%previousversion%.exe /S /Q >NUL
	) else (
		call :log info No new version
		set downloadedversion=%previousversion%
	)
	
	:start
	:: run the exe
	call :log info Running: iKeyHelper-%downloadedversion%.exe
	call iKeyHelper-%downloadedversion%.exe
popd
endlocal

goto :eof

:clean
call :log info Cleaning Files
<nul set /p "=Wiping all files... "
if exist %workingDir% rmdir %workingdir% /S /Q>NUL
if exist %tempDir% rmdir %tempDir% /S /Q>NUL
if exist %tools% rmdir %tools% /S /Q>NUL
echo Done^^!
goto :EOF

:log

:: log messages

if not exist %logdir% mkdir %logdir% >NUL

if not .%1.==.. (
	if "%1"=="error" (
		echo [%time:~0,8%] [ERROR] %2 %3 %4 %5 %6 %7 %8 %9 >> %logfile%
	) else (
		echo [%time:~0,8%] [INFO] %1 %2 %3 %4 %5 %6 %7 %8 %9 >> %logfile%
	)
) else (
	echo Usage: log ^(error^) ^<description^>
)

goto eof

:eof

