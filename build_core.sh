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
    ng build --configuration production --base-href ./ --source-map=false --output-path=$outputDir | sed "s/^/APP: /" > ../ng-build.log 2> ../ng-errors.log
	if [ -d dist ]
	then
		rm -rf dist
	fi
	cp -r "${outputDir}/." dist
	
    echo 'Angular project built.'
	
    echo 'PLEASE WAIT'
}

build_api() {
    cd CSETWebApi/csetweb_api/CSETWeb_ApiCore

    echo 'Cleaning solution...'
    # eval "$msbuild CSETWeb_Api/CSETWeb_Api.sln -property:Configuration=$msbuild_config -t:Clean" | sed "s/^/CLEAN: /" > ../api-build.log 2> ../api-errors.log
	dotnet clean 
	
    # echo 'Building solution...'
    # eval "$msbuild CSETWeb_Api/CSETWeb_Api.sln -property:Configuration=$msbuild_config -t:Build" | sed "s/^/BUILD: /" >> ../api-build.log 2>> ../api-errors.log
    # echo 'Solution built.'

    echo 'Publishing project...'
	outputDirApi="/c/temp/api-publish_${1}"
	dotnet publish --configuration Release -o $outputDirApi -v q
	
	mkdir -p ../../dist/web && cp -r "${outputDirApi}/." ../../dist/web

	#apiZip="${outputDir}.zip"
	#echo "Zipping to $apiZip"
	#zip -r $apiZip $outputDir


    echo 'API project published.'
    
    echo 'PLEASE WAIT'
}

build_reports_api() {
    cd CSETWebApi/csetweb_api/CSETWebCore.Reports

    echo 'Cleaning solution...'
  
	dotnet clean 

    echo 'Publishing project...'
	outputDirReportsApi="/c/temp/reports-api-publish_${1}"
	dotnet publish --configuration Release -o $outputDirReportsApi -v q
	
	mkdir -p ../../dist/web && cp -r "${outputDirReportsApi}/." ../../dist/web


    echo 'API project published.'
    
    echo 'PLEASE WAIT'
}

build_electron() {
	cd CSETWebNg
	
	echo 'Packaging CSET as Electron App'
	npm run build:electron
	
	mkdir -p ../dist/electron && cp -r electron-builds/CSET-win32-x64/. ../dist/electron
	
	echo 'Electron package complete'
}


############################
##########  MAIN  ##########
############################

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

build_reports_api $ts | sed "s/^/REPORTS API BUILD: /" &

echo 'Processes started.'

wait

if [ $# -ne 0 ] && [ $1 == -electron ]
then
	build_electron $ts | sed "s/^/ELECTRON BUILD: /" &
wait
fi

echo 'All build processes complete.'


date

echo 'CSETWeb BUILD COMPLETE'

