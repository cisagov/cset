
function Test-SqlConnection {
    param(
        [Parameter(Mandatory)]
        [string]$connectionString
    )

    try {
        $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $connectionString
        $sqlConnection.Open()
        ## This will run if the Open() method does not throw an exception
        return $true
    } catch {
        return $false
    } finally {
        $sqlConnection.Close()
    }
}

# Install SQL Server Express 2022
Start-Process SQL2022-SSEI-Expr.exe -Wait

# Install Web Server (IIS)
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Install URL Rewrite module for IIS
Start-Process rewrite_amd64_en-US.msi -Wait

# Install dotnet 6 hosting bundle 
Start-Process dotnet-hosting-8.0.1-win.exe -Wait

# Update enviornment path to ensure sqlcmd works after installing SQL server
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# Create CSETUser
$password = Read-Host -AsSecureString "Enter a password for CSET service user account"
New-LocalUser -Name "CSETUser" -Description "CSET Service User" -Password $password -PasswordNeverExpires -UserMayNotChangePassword

# Create directories to place CSETAPI and CSETUI
New-Item -ItemType directory -Path C:\inetpub\wwwroot\CSETAPI -Force
New-Item -ItemType directory -Path C:\inetpub\wwwroot\CSETUI -Force

Copy-Item -Path CSETWebApi\* -Destination C:\inetpub\wwwroot\CSETAPI -Recurse -Force
Copy-Item -Path CSETUI\* -Destination C:\inetpub\wwwroot\CSETUI -Recurse -Force

# Copy database files to user directory
New-Item -ItemType directory -Path C:\CSETDatabase -Force
Copy-Item -Path database\CSETWeb*.mdf -Destination C:\CSETDatabase\CSETWeb.mdf -Force
Copy-Item -Path database\CSETWeb*_log.ldf -Destination C:\CSETDatabase\CSETWeb_log.ldf -Force

$plainTextPassword = [Net.NetworkCredential]::new('', $password).Password

# Add CSET app pools (leaving managedRuntimeVersion blank results in "No Managed Code")
& ${Env:windir}\system32\inetsrv\appcmd add apppool /name:"CSETAPI" /managedPipelineMode:"Integrated" /managedRuntimeVersion:"" /processModel.identityType:"SpecificUser" /processModel.userName:"${env:computername}\CSETUser" /processModel.password:$plainTextPassword
& ${Env:windir}\system32\inetsrv\appcmd add apppool /name:"CSETUI" /managedPipelineMode:"Integrated" /managedRuntimeVersion:"" /processModel.identityType:"SpecificUser" /processModel.userName:"${env:computername}\CSETUser" /processModel.password:$plainTextPassword

# Create CSETAPI and CSETUI sites and add them to CSET app pool
& ${Env:windir}\system32\inetsrv\appcmd add site /name:"CSETAPI" /physicalPath:"C:\inetpub\wwwroot\CSETAPI" /bindings:"http/*:5001:"
& ${Env:windir}\system32\inetsrv\appcmd set site "CSETAPI" /applicationDefaults.applicationPool:"CSETAPI"

& ${Env:windir}\system32\inetsrv\appcmd add site /name:"CSETUI" /physicalPath:"C:\inetpub\wwwroot\CSETUI" /bindings:"http/*:80:"
& ${Env:windir}\system32\inetsrv\appcmd set site "CSETUI" /applicationDefaults.applicationPool:"CSETUI"

# Carry on with database setup...
$server = Read-Host "Enter the SQL server name to be used for CSET database setup"

$sqlConnectionSucceeded = Test-SqlConnection "data source=${server};persist security info=True;Integrated Security=SSPI;MultipleActiveResultSets=True;Encrypt=false"

While ($sqlConnectionSucceeded -ne $true) {
	$server = Read-Host "Error connecting to the provided database server. Please try again"
	$sqlConnectionSucceeded = Test-SqlConnection "data source=${server};persist security info=True;Integrated Security=SSPI;MultipleActiveResultSets=True;Encrypt=false"
	$sqlConnectionSucceeded
}

$serverescaped = $server.replace("\", "\\")

# Making sure connection string and ports are correct in config files
(Get-Content C:\inetpub\wwwroot\CSETAPI\appsettings.json -Raw).replace("(localdb)\\INLLocalDb2022", ($serverescaped + ";Trust Server Certificate=True")) | Set-Content C:\inetpub\wwwroot\CSETAPI\appsettings.json -NoNewLine
(Get-Content C:\inetpub\wwwroot\CSETUI\assets\settings\config.json -Raw).replace('"port": "5000"', '"port": "5001"') | Set-Content C:\inetpub\wwwroot\CSETUI\assets\settings\config.json -NoNewLine

sqlcmd -E -S $server -d "MASTER" -Q "CREATE DATABASE CSETWeb ON (FILENAME = 'C:\CSETDatabase\CSETWeb.mdf'), (FILENAME = 'C:\CSETDatabase\CSETWeb_log.ldf') FOR ATTACH;"
sqlcmd -E -S $server -d "CSETWeb" -Q "CREATE LOGIN [${env:computername}\CSETUser] FROM WINDOWS WITH DEFAULT_DATABASE = CSETWeb; CREATE USER [${env:computername}\CSETUser] FOR LOGIN [${env:computername}\CSETUser] WITH DEFAULT_SCHEMA = [dbo];"
sqlcmd -E -S $server -d "CSETWeb" -Q "ALTER ROLE [db_owner] ADD MEMBER [${env:computername}\CSETUser];"
sqlcmd -E -S $server -d "CSETWeb" -Q "GRANT EXECUTE ON SCHEMA :: [dbo] to [${env:computername}\CSETUser];"

# Restarting websites
& ${Env:windir}\system32\inetsrv\appcmd start apppool "CSETAPI"
& ${Env:windir}\system32\inetsrv\appcmd start apppool "CSETUI"

& ${Env:windir}\system32\inetsrv\appcmd stop site "CSETAPI"
& ${Env:windir}\system32\inetsrv\appcmd stop site "CSETUI"
& ${Env:windir}\system32\inetsrv\appcmd stop site "Default Web Site"

& ${Env:windir}\system32\inetsrv\appcmd start site "CSETAPI"
& ${Env:windir}\system32\inetsrv\appcmd start site "CSETUI"

Write-Host "CSET enterprise setup complete. Open IIS Manager to check the status of the application or make further changes."