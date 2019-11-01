@echo off

call %~dp0filechecker.bat
set buildcnt=%errorlevel%
if %buildcnt% gtr 0 (
	pushd %~dp0
	ant
	popd
) else (
	echo There are no javascript changes that require `ant` builder.
)