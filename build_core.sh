#!/bin/bash
shopt extglob dotglob nullglob



build_ng() {
  echo 'Angular Build'
  cd CSETWebNg

	# Verify Angular CLI installation
	if ! command -v ng &> /dev/null
	then
		echo "Angular CLI not found! Build Cancelled!"
		exit 1
	fi

  echo 'building CSET app'
	outputDir="/c/temp/ng-dist_${1}"
  ng build --configuration production --base-href ./ --source-map=false | sed "s/^/APP: /" > ../ng-build.log 2> ../ng-errors.log

	mkdir -p "${outputDir}" && cp -r dist "${outputDir}/."
	
  echo 'Angular project built.'
	
  echo 'PLEASE WAIT'
}

build_api() {
  cd CSETWebApi/csetweb_api/CSETWeb_ApiCore

  echo 'Cleaning Project...'

	dotnet clean 

  echo 'Publishing project...'
	outputDirApi="/c/temp/api-publish_${1}"
	dotnet publish --configuration Release -o $outputDirApi -v q

	rm -f ${outputDirApi}/appsettings.development.json
	
	mkdir -p ../../../dist/CSETWebApi && cp -r "${outputDirApi}/." ../../../dist/CSETWebApi


  echo 'API project published.'
    
  echo 'PLEASE WAIT'
}

build_electron() {
	cd CSETWebNg
	
	echo 'Packaging CSET as Electron App'
	npm run build:electron
	
	package="CSET"
	
	mkdir -p ../dist/electron && cp -r "electron-builds/${package}-win32-x64/." ../dist/electron
	
	echo 'Electron package complete'
}


############################
##########  MAIN  ##########
############################

userguides/UserGuides.exe -Y

date

if [ -d dist ]
then
  echo 'Deleting existing dist folder'
  rm -rf dist
fi

ts=$(date +%Y-%m-%d_%H.%M.%S)


echo 'Beginning asynchronous build processes...'

build_ng $ts | sed "s/^/NG BUILD: /" &

build_api $ts | sed "s/^/API BUILD: /" &

echo 'Processes started.'

wait

if [ $# -ne 0 ] && [ $1 == -electron ]
then
	build_electron $ts | sed "s/^/ELECTRON BUILD: /"
wait
fi

echo 'All build processes complete.'


date

echo 'CSETWeb BUILD COMPLETE'

