:: iKeyHelper Options
:: Sample configuration
:: ----------------------------
:: config check, dont edit this
:: ----------------------------
@ECHO OFF

if not "%1"=="this-is-meant-to-be-run" start "" notepad %0

:: ! LEAVING THIS CONFIG BLANK WILL CAUSE iKEYHELPER TO USE STANDARD CONFIGURATION !
::
:: NOTE SOME STANDARD VARIABLES
:: ----------------------------
::
:: %temp% is the default temporary folder
:: %UserProfile% is your User directory (e.g. C:\Users\John)
::
:: You can add paths to these variables,
:: e.g. %UserProfile%\iKeyHelper-log-dir Would map to C:\Users\John\iKeyHelper-log-dir
::
:: Avoid using spaces anywhere in this file.
:: 
:: Edit below this line
:: -----------------------------

:: path to save the bundles in (default = %UserProfile%\iKeyHelper\)
set bundledir=%UserProfile%\iKeyHelper

:: if you do not wish to check for updates, set this to "no" (without quotes), anything else will auto check for updates.
set checkforupdates=yes

:: set this to "yes" (without quotes) to auto enter recovery mode
:: otherwise leave it empty or set it to "no" (without quotes)
set autoenterrecovery=yes

:: set this to "yes" (without quotes) to download unstable betas
:: NOTE: NOT RECOMMENDED.
:: otherwise set it to "no" (without quotes)
set downloadbetas=no

:: this will open baretail.exe with the log, so you can debug (requires baretail in the tools folder)
set viewlog=no

:: font colour 
:: -----------------------------------
::    1 = Blue        9 = Light Blue
::    2 = Green       A = Light Green
::    3 = Aqua        B = Light Aqua
::    4 = Red         C = Light Red
::    5 = Purple      D = Light Purple
::    6 = Yellow      E = Light Yellow
::    7 = White       F = Bright White
:: -----------------------------------
set fontcolour=D

