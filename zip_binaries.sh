
##################################################################
## This script builds the front and backend of CSET,            ##
## then zips them up with SQL Server Express 2022,              ##
## .NET 7 hosting bundle, database files, and web.config files. ##
## Provide the script with the correct _versionNum on cmd line. ##
##################################################################

_installationMode=$1 
_versionNum=$2

start C:/src/Repos/CSETStandAlone/setup/WixInstaller/CSET_WixSetup/deprecateFAA.bat CSETWeb${_versionNum}
sqlcmd -S "(localdb)\INLLocalDb2022" -d "$CSETWeb${_versionNum}" -i  $RepoDir"Database Scripts\Database Maint Scripts\Users Clean-out.sql"
sqlcmd -S "(localdb)\INLLocalDb2022" -d "$CSETWeb${_versionNum}" -i  $RepoDir"Database Scripts\Database Maint Scripts\Assessment Clean-out.sql"
sqlcmd -S "(localdb)\INLLocalDb2022" -d "$CSETWeb${_versionNum}" -i  $RepoDir"Database Scripts\Database Maint Scripts\Standards Clean-out.sql"

shopt -s nocasematch

if [[ $_installationMode == "WMATA" ]]
then
    sqlcmd -S "(localdb)\INLLocalDb2022" -d "$CSETWeb${_versionNum}" -i  $RepoDir"Database Scripts\Database Maint Scripts\WMATA Setup.sql"
fi

sed -i 's/\"EnterpriseInstallation\": \"false\"/\"EnterpriseInstallation\": \"true\"/g' CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/appsettings.json

cd CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/Diagram/etc/build
ant

cd C:/src/repos/cset

./build_core.sh

mkdir dist/database
mkdir dist/CSETUI

cp -r C:/src/Repos/cset/CSETWebNg/dist/. dist/CSETUI
cp  setup_enterprise.ps1 dist
cp -r C:/src/Repos/CSETStandAlone/setup/WixInstaller/CSET_WixBootStrapperProject/redist/enterprise/. dist
mv dist/CSETUIweb.config dist/CSETUI/web.config
cp  C:/Users/${USERNAME}/CSETWeb${_versionNum}.mdf dist/database
cp  C:/Users/${USERNAME}/CSETWeb${_versionNum}_log.ldf dist/database


 ECHO "Zipping files to CSETv${_versionNum}_Enterprise_Binaries.zip"
 ./7zip/7z.exe a -tzip CSETv${_versionNum}_Enterprise_Binaries.zip dist/.
 # ECHO "Completed creation of enterprise binaries"
 $SHELL
