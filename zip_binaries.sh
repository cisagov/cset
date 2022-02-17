
##################################################################
## This script builds the front and backend of CSET,            ##
## then zips them up with SQL Server Express 2019,              ##
## .NET 5 hosting bundle, database files, and web.config files. ##
##################################################################

_versionNum=11010

sed -i 's/\"EnterpriseInstallation\": \"false\"/\"EnterpriseInstallation\": \"true\"/g' CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/appsettings.json

cd CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/Diagram/etc/build
ant

cd C:/src/repos/cset

./build_core.sh

mkdir dist/database
mkdir dist/CSETUI

cp -r C:/src/Repos/cset/CSETWebNg/dist/. dist/CSETUI
cp -r C:/src/Repos/CSETStandAlone/setup/WixInstaller/CSET_WixBootStrapperProject/redist/enterprise/. dist
cp  C:/Users/${USERNAME}/CSETWeb${_versionNum}.mdf dist/database
cp  C:/Users/${USERNAME}/CSETWeb${_versionNum}_log.ldf dist/database


 ECHO "Zipping files to CSETv${_versionNum}_Enterprise_Binaries.zip"
 ./7zip/7z.exe a -tzip CSETv${_versionNum}_Enterprise_Binaries.zip dist/.
 # ECHO "Completed creation of enterprise binaries"
 $SHELL
