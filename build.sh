#!/bin/bash
shopt extglob dotglob nullglob

############################
#######  CONSTANTS  ########
############################

#if not passed in on command line, set to web deployment values
if [ -z "$ng_config" ]; then
	ng_config=production
fi
if [ -z "$reports_config" ]; then
	reports_config=production
fi
if [ -z "$msbuild_config" ]; then
	msbuild_config=Release
fi
if [ -z "$mspublish_config" ]; then
	mspublish_config=FolderProfile
fi
if [ -z "$mspublish_folder" ]; then
	mspublish_folder=$msbuild_config
fi

#StandAlone values
# ng_config=local reports_config=local msbuild_config=localdb mspublish_config=runlocal

#Enterprise install default values
# msbuild_config=localhost mspublish_folder=Release

############################
#######  VARIABLES  ########
############################

# run vswhere, and convert to POSIX path format
vs_install_dir=$( echo "$(./vswhere.bat | tail -n 1)" | sed -e 's/\\/\//g' -e 's/://' -e 's/^/\//' )
echo "Visual Studio Installation Directory: $vs_install_dir"
echo ''

build_dir=$(pwd) # so we can get back to the build directory after finding MSBuild

# The path to the MSBuild executable
if [ -d "$vs_install_dir/MSBuild/Current" ]
then
    echo 'MSBuild version >= 2019 found. Using current version'
    msbuild="'$vs_install_dir/MSBuild/Current/Bin/MSBuild.exe'"
else
    # Delete Me. please
    echo 'Finding MSBuild Versions...'
    pushd "$vs_install_dir/MSBuild"
    msbuild_version=0.0
    for i in *.*; # the directories we are looking for are all similar to 5.0/
    do
        if [ -d $i ]; # make sure it is a directory
        then 
            echo "Found Version $i"; 
            if [ ${i%.*} -eq ${msbuild_version%.*} ] && [ ${i#*.} \> ${msbuild_version#*.} ] || [ ${i%.*} -gt ${msbuild_version%.*} ];
            then
                msbuild_version=$i
            fi
        fi

    done
    if [ $msbuild_version = 0.0 ];
    then
        echo 'MSBuild not found! Build cancelled!'
        exit 1
    fi
    echo "Selected MSBuild version: $msbuild_version"
    echo ''
    msbuild="'$vs_install_dir/MSBuild/$msbuild_version/Bin/MSBuild.exe'"
    popd
    # cd $build_dir
fi


echo "MSBuild Path: $msbuild"
echo ''

############################
#######  FUNCTIONS  ########
############################

# NOTE: Throughout, the output of asynchronous processes is prefixed with a descriptive tag by piping to sed

build_ng() {
    echo 'Angular Build'
    cd CSETWebNg

    echo 'building CSET app'
    ng build --configuration=$ng_config --source-map=false | sed "s/^/APP: /" > ../ng-build.log 2> ../ng-errors.log

    echo 'building Reports app'
    ng build reports --configuration=$reports_config --source-map=false --base-href="./" | sed "s/^/REPORTS: /" > ../reports-build.log 2> ../reports-errors.log

    echo 'done building Angular project'
    echo 'PLEASE WAIT'
}

build_api() {
    cd CSETWebApi

    echo 'Cleaning solution...'
    eval "$msbuild CSETWeb_Api/CSETWeb_Api.sln -property:Configuration=$msbuild_config -t:Clean" | sed "s/^/CLEAN: /" > ../api-build.log 2> ../api-errors.log
    echo 'Building solution...'
    eval "$msbuild CSETWeb_Api/CSETWeb_Api.sln -property:Configuration=$msbuild_config -t:Build" | sed "s/^/BUILD: /" >> ../api-build.log 2>> ../api-errors.log
    echo 'Solution built.'

    echo 'Publishing project...'
    eval "$msbuild CSETWeb_Api/CSETWeb_Api/CSETWeb_Api.csproj -p:DeployOnBuild=true -p:PublishProfile=$mspublish_config -p:Configuration=$msbuild_config" | sed "s/^/PUBLISH: /" > ../api-publish.log 2> publish-errors.log
    echo 'Project published.'
    
    echo 'PLEASE WAIT'
}

publish_dist() {
    echo 'Cleaning up dist folder.'
    rm -rf dist | sed "s/^/DIST CLEANUP: /"

    #NOTE: the Angular dist must be copied into the API dist, and not vice versa
    echo 'Publishing to dist folder'
    mv "CSETWebApi/CSETWeb_Api/CSETWeb_Api/bin/$mspublish_folder/Publish" dist | sed "s/^/API PUBLISH: /"
    cp -r CSETWebNg/dist . | sed "s/^/NG PUBLISH: /"
    echo 'dist Folder is ready for deployment.'
}

############################
##########  MAIN  ##########
############################

if [ -d dist ]
then
    echo 'Deleting existing dist folder'
    rm -rf dist
fi

echo 'Beginning asynchronous build processes...'
build_ng | sed "s/^/NG BUILD: /" &
build_api | sed "s/^/API BUILD: /" &
echo 'Processes started.'
wait
echo 'All build processes complete.'

publish_dist
echo 'CSETWeb BUILD COMPLETE'