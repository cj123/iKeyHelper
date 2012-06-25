@ECHO OFF
:: iKeyHelper Device Definitions
:: Copyright (C) 2012 Callum Jones
:: See attached license

set bdid=%1

if "%bdid%"=="" (
	echo No Boardid Supplied
	goto eof
) else if "%bdid%"=="iPod41" (

	REM iPod Touch 4
	set bdid=ipod41
	set deviceid=iPod Touch 4
	set boardid=n81
	set deviceidw=iPod_touch_4G
	set url_parsing_device=iPod Touch 4
	set requiresdevice=no

) else if "%bdid%"=="iPhone31" (

	REM iPhone 4 GSM
	set bdid=iphone31
	set deviceid=iPhone 4
	set boardid=n90
	set deviceidw=iPhone_4
	set url_parsing_device=iPhone 4 ^(GSM^)
	set requiresdevice=no

) else if "%bdid%"=="iPad11" (

	REM iPad 1
	set bdid=ipad11
	set deviceid=iPad
	set boardid=k48
	set deviceidw=iPad
	set url_parsing_device=iPad 1
	set requiresdevice=no

) else if "%bdid%"=="AppleTV21" (

	REM Apple TV 2G
	set bdid=appletv21
	set deviceid=Apple TV 2G
	set boardid=k66
	set deviceidw=Apple_TV_2G
	set url_parsing_device=Apple TV 2G
	set requiresdevice=no

) else if "%bdid%"=="iPhone33" (

	REM iPhone 4 CDMA
	set bdid=iphone33
	set deviceid=iPhone 4 [CDMA]
	set boardid=n92
	set deviceidw=iPhone_4_CDMA
	set url_parsing_device=iPhone 4 ^(CDMA^)
	set requiresdevice=no

) else if "%bdid%"=="iPhone21" (
	
	REM iPhone 3G[S]
	set bdid=iphone21
	set deviceid=iPhone 3G[S]
	set boardid=n88
	set deviceidw=iPhone_3GS
	set url_parsing_device=iPhone 3G[S]
	set requiresdevice=yes
	
) else if "%bdid%"=="iPod31" (

	REM iPod Touch 3
	set bdid=ipod31
	set deviceid=iPod Touch 3
	set boardid=n18
	set deviceidw=iPod_Touch_3G
	set url_parsing_device=iPod Touch 3
	set requiresdevice=yes

) else if "%bdid%"=="iPhone41" (

	REM iPhone 4[S]
	echo.
	echo - Unsupported device detected! 
	echo - Press any key to exit...
	pause >NUL
	exit
	set bdid=iphone41
	set deviceid=iPhone 4[S]
	set boardid=n94
	set deviceidw=iPhone_4S
	set url_parsing_device=iPhone 4[S]

) else (

	REM Unknown device
	echo - Unknown device detected! 
	echo - Press any key to exit...
	pause >NUL
	exit

)

:eof