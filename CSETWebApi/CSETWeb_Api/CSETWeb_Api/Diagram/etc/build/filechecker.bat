@echo off
setlocal enabledelayedexpansion

cls
set cwd=%~dp0

set jsfldr="%cwd%..\..\src\main\webapp\js\"
call :joinpath %jsfldr% "app.min.js"
set appminjs=!combined!

set /a buildcnt = 0
if not exist !appminjs! (
    set /a buildcnt = 1
) else (
	for %%f in (!appminjs!) do (
		call :jdate %%~tf
		set /a blddate = !jdate!
		set /a bldtime = !jtime!
	)

	set x=-1
	call :getfiles %jsfldr% *.js
	for /L %%f in (0,1,!x!) do (
		set fdate=!files[%%f].fdate!
		set ftime=!files[%%f].ftime!
		if !fdate! geq !blddate! (
			if !ftime! gtr !bldtime! (
				set /a buildcnt += 1
			)
		)
	)
)
exit /b !buildcnt!

:joinpath
set path1=%~1
set path2=%~2
if not {%path1:~-1,1%}=={\} (
	set path1=%path1%\
)
set combined=%path1%%path2%
exit /b

:getfiles
set path=%~1%~2
for %%f in (%path%) do (
	set /a x += 1
	set files[!x!].idx=!x!
	set files[!x!].name=%%~nxf
	set files[!x!].path=%%~ff
	
	call :jdate %%~tf
	set files[!x!].fdate=!jdate!
	set files[!x!].ftime=!jtime!
)
set path=%~1*
for /D %%d in (%path%) do (
	call :getfiles %%~fd\ %~2
)
exit /b

:jdate
set date=%1
set mm=%date:~0,2%
set dd=%date:~3,2%
set /a yyyy= %date:~6,4% + 4800
if %mm:~0,1% equ 0 set mm=%mm:~1%
if %dd:~0,1% equ 0 set dd=%dd:~1%

set /a month1 = ( %mm% - 14 ) / 12
set /a year1 = %yyyy% + 4800
set /a jdate = 1461 * ( %year1% + %month1% ) / 4 + 367 * ( %mm% - 2 -12 * %month1% ) / 12 - ( 3 * ( ( %year1% + %month1% + 100 ) / 100 ) ) / 4 + %dd% - 32075
set month1=
set year1=

set tt=%2
set hh=%tt:~0,2%
set mn=%tt:~3,2%
if %hh% equ 12 set /a hh = 00
if %3 equ PM (
	set /a hh = hh + 12
)
set jtime=%hh%%mn%
exit /b