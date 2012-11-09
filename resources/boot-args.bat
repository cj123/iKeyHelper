:: Set boot args in preparation for iKeyHelper
:: (c) Callum Jones <cj@icj.me>
@ECHO OFF

setlocal
SETLOCAL EnableDelayedExpansion

<nul set /p "=- Please enter recovery mode... "

:recoverycheck

set tools=%AppData%\iKeyHelper\bin

if not exist %tools%\irecovery.exe (
	echo.
	echo Please open iKeyHelper first, then come back here.
	goto EOF
)

%tools%\irecovery.exe -c | find /I /N "Found iPhone/iPod in Recovery mode">NUL

if "%ERRORLEVEL%"=="0" (
	echo Found device^^!
	goto patchme
) else (
	ping localhost -n 6 >nul
	goto recoverycheck
)

:patchme

<nul set /p "=- Patching... "
call %tools%\irecovery.exe -c "setenv boot-args 2" >nul
call %tools%\irecovery.exe -c "saveenv" >nul
echo Done^^!

goto EOF

:EOF

endlocal