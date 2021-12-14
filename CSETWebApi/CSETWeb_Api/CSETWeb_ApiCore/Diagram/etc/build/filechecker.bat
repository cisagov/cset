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
		call :datetime %%~tf
		set blddatetime=!datetime!
	)
	echo app.min.js !blddatetime!

	set x=-1
	call :getfiles %jsfldr% *.js
	for /L %%f in (0,1,!x!) do (
		set fname=!files[%%f].name!
		set fdatetime=!files[%%f].fdatetime!
		if "!fdatetime!" gtr "!blddatetime!" (
			echo !fname! !fdatetime!
			set /a buildcnt += 1
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
	
	call :datetime %%~tf
	set files[!x!].fdatetime=!datetime!
)
set path=%~1*
for /D %%d in (%path%) do (
	call :getfiles %%~fd\ %~2
)
exit /b

:datetime
set date=%1
set yyyy=%date:~6,4%
set mm=%date:~0,2%
set dd=%date:~3,2%

set time=%2
set hh=%time:~0,2%
set mn=%time:~3,2%
if %hh% equ 12 set hh=00
if %3 equ PM set /a hh = hh + 12
set datetime=%yyyy%%mm%%dd%%hh%%mn%
exit /b