#!/bin/bash
shopt extglob dotglob nullglob



build_ng() {
    echo 'Angular Build'
    cd CSETWebNg

    echo 'building CSET app'
	outputDir="/c/temp/ng-dist_${1}/"
    ng build --configuration=$ng_config --base-href ./ --source-map=false --output-path=$outputDir | sed "s/^/APP: /" > ../ng-build.log 2> ../ng-errors.log
	cp -R -f $outputDir dist
	
    echo 'Angular project built.'
	
    echo 'PLEASE WAIT'
}

build_api() {
    cd CSETWebApi/csetweb_api

    echo 'Cleaning solution...'
    # eval "$msbuild CSETWeb_Api/CSETWeb_Api.sln -property:Configuration=$msbuild_config -t:Clean" | sed "s/^/CLEAN: /" > ../api-build.log 2> ../api-errors.log
	dotnet clean 
	
    # echo 'Building solution...'
    # eval "$msbuild CSETWeb_Api/CSETWeb_Api.sln -property:Configuration=$msbuild_config -t:Build" | sed "s/^/BUILD: /" >> ../api-build.log 2>> ../api-errors.log
    # echo 'Solution built.'

    echo 'Publishing project...'
	outputDir="/c/temp/api-publish_${1}/"
	dotnet publish --configuration Release -o $outputDir -v q

	#apiZip="${outputDir}.zip"
	#echo "Zipping to $apiZip"
	#zip -r $apiZip $outputDir


    echo 'API project published.'
    
    echo 'PLEASE WAIT'
}

build_electron() {
	cd CSETWebNg
	
	echo 'Packaging CSET as Electron App'
	npm run build:electron
	
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

echo 'Processes started.'

wait

build_electron $ts | sed "s/^/ELECTRON BUILD: /" &

wait

echo 'All build processes complete.'


date

echo 'CSETWeb BUILD COMPLETE'

