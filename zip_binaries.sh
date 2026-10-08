
##################################################################
## This script builds the front and backend of CSET,            ##
## then zips them up with SQL Server Express 2022,              ##
## .NET hosting bundle, database files, and web.config files.   ##
## Provide the script with the correct _versionNum on cmd line. ##
##################################################################

_versionNum=$1

if [ -z "$_versionNum" ]; then
  echo "Usage: ./zip_binaries.sh <versionNum>, for example 13000"
  exit 1
fi

RepoDir="$(cd "$(dirname "$0")" && pwd)"
cd "$RepoDir"

StandAloneDir="C:/src/Repos/CSETStandAlone"

# The enterprise installer uses SQL Server Express 2022, so the database has to stay in 2022 format.
# Attaching it to the 2025 instance would upgrade the file and the installer could no longer attach it.
LocalDbInstance="(localdb)\\INLLocalDb2022"
DbName="CSETWeb${_versionNum}"
DbFile="C:/Users/${USERNAME}/${DbName}.mdf"
DbLogFile="C:/Users/${USERNAME}/${DbName}_log.ldf"

SignTool="C:/Program Files (x86)/Windows Kits/10/bin/10.0.26100.0/x64/signtool.exe"
SignSubjectName="DOE - Idaho National Laboratory"
SignTimestampUrl="http://timestamp.entrust.net/rfc3161ts2"

# MSYS rewrites arguments that start with a slash, which breaks signtool switches like /fd
sign_file() {
  MSYS2_ARG_CONV_EXCL='*' "$SignTool" sign /fd SHA256 /n "$SignSubjectName" /tr "$SignTimestampUrl" /td SHA256 "$(cygpath -w "$1")" || return 1
  MSYS2_ARG_CONV_EXCL='*' "$SignTool" verify /pa "$(cygpath -w "$1")"
}

run_sql_file() {
  sqlcmd -E -b -S "$LocalDbInstance" -d "$DbName" -i "$(cygpath -w "$RepoDir/DatabaseScripts/DatabaseMaintScripts/$1")"
}

if [ ! -f "$SignTool" ]; then
  echo "signtool.exe not found at $SignTool"
  exit 1
fi
dbCount=$(sqlcmd -E -S "$LocalDbInstance" -h -1 -W -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name = N'${DbName}'" | tr -d '[:space:]')
if [ "$dbCount" != "1" ]; then
  echo "Database ${DbName} is not attached to ${LocalDbInstance}. Attach it there before running this script."
  exit 1
fi

# Same changes as deprecateFAA.bat, run against the 2022 instance
sqlcmd -E -b -S "$LocalDbInstance" -d "$DbName" -Q "UPDATE [dbo].[SETS] SET [Is_Deprecated] = 1 where set_name = 'FAA_MAINT'; update [sets] set IsEncryptedModule = 1 where set_name in ('FAA','FAA_PED_V2'); update [sets] set IsEncryptedModuleOpen = 0 where set_name in ('FAA_MAINT'); update [sets] set IsEncryptedModuleOpen = 0 where set_name in ('FAA','FAA_PED_V2'); update [sets] set IsEncryptedModuleOpen = 0 where set_name in ('FAA_MAINT');" || { echo "FAA deprecation failed"; exit 1; }

run_sql_file "Users Clean-out.sql" || { echo "Users clean-out failed"; exit 1; }
run_sql_file "Assessment Clean-out.sql" || { echo "Assessment clean-out failed"; exit 1; }
run_sql_file "Standards Clean-out.sql" || { echo "Standards clean-out failed"; exit 1; }

# The mdf and ldf can't be copied while the database is attached
sqlcmd -E -b -S "$LocalDbInstance" -d master -Q "ALTER DATABASE [${DbName}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; EXEC sp_detach_db @dbname = N'${DbName}';" || { echo "Detaching ${DbName} failed"; exit 1; }

if [ ! -f "$DbFile" ] || [ ! -f "$DbLogFile" ]; then
  echo "Expected database files were not found: $DbFile and $DbLogFile"
  exit 1
fi

shopt -s nocasematch

sed -i 's/\"EnterpriseInstallation\": \"false\"/\"EnterpriseInstallation\": \"true\"/g' CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/appsettings.json

(cd CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/Diagram/etc/build && ant) || { echo "Diagram build failed"; exit 1; }

./build_core.sh || { echo "build_core.sh failed"; exit 1; }

if [ ! -f dist/CSETWebApi/CSETWebCore.Api.exe ]; then
  echo "dist/CSETWebApi/CSETWebCore.Api.exe was not produced by the build"
  exit 1
fi

sign_file dist/CSETWebApi/CSETWebCore.Api.exe || { echo "Signing CSETWebCore.Api.exe failed"; exit 1; }

mkdir dist/database
mkdir dist/CSETUI

cp -r "$RepoDir/CSETWebNg/dist/." dist/CSETUI
cp setup_enterprise.ps1 dist
cp -r "$StandAloneDir/setup/WixInstaller/CSET_WixBootStrapperProject/redist/enterprise/." dist
mv dist/CSETUIweb.config dist/CSETUI/web.config
cp "$DbFile" dist/database
cp "$DbLogFile" dist/database

echo "Zipping files to CSETv${_versionNum}_Enterprise_Binaries.zip"
./7zip/7z.exe a -tzip CSETv${_versionNum}_Enterprise_Binaries.zip dist/. || { echo "Zipping failed"; exit 1; }

echo "Completed creation of CSETv${_versionNum}_Enterprise_Binaries.zip"
