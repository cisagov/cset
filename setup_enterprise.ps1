# Install dotnet 6 hosting bundle 
Start-Process dotnet-hosting-6.0.2-win.exe -ArgumentList -Wait

# Install SQL Server Express 2019
Start-Process SQL2019-SSEI-Expr.exe -ArgumentList -Wait

# Install Web Server (IIS)
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Create CSETUser
$password = Read-Host -AsSecureString "Enter a password for CSET service user account"
New-LocalUser -Name "CSETUser" -Description "CSET Service User" -Password $password -PasswordNeverExpires -UserMayNotChangePassword

# Create directories to place CSETAPI, CSETReportAPI, and CSETUI
New-Item -ItemType directory -Path C:\inetpub\wwwroot\CSETAPI
New-Item -ItemType directory -Path C:\inetpub\wwwroot\CSETReportAPI
New-Item -ItemType directory -Path C:\inetpub\wwwroot\CSETUI

Copy-Item -Path CSETWebApi\* -Destination C:\inetpub\wwwroot\CSETAPI -Recurse
Copy-Item -Path CSETWebApiReports\* -Destination C:\inetpub\wwwroot\CSETReportAPI -Recurse
Copy-Item -Path CSETUI\* -Destination C:\inetpub\wwwroot\CSETUI -Recurse

# Add CSETAPP app pool (leaving managedRuntimeVersion blank results in "No Managed Code")
& ${Env:windir}\system32\inetsrv\appcmd add apppool /name:"CSETAPP" /managedPipelineMode:"Integrated" /managedRuntimeVersion:"" /processModel.identityType:"SpecificUser" /processModel.userName:"CSETUser" /processModel.password:$password

# Create CSETAPI, CSETReportAPI, and CSETUI sites and add them to CSET app pool
& ${Env:windir}\system32\inetsrv\appcmd add site /name:"CSETAPI" /physicalPath:"C:\inetpub\wwwroot\CSETAPI" /bindings:"http/*:5001:"
& ${Env:windir}\system32\inetsrv\appcmd set site "CSETAPI" /applicationPool:"CSETAPP"

& ${Env:windir}\system32\inetsrv\appcmd add site /name:"CSETReportAPI" /physicalPath:"C:\inetpub\wwwroot\CSETReportAPI" /bindings:"http/*:5002:"
& ${Env:windir}\system32\inetsrv\appcmd set site "CSETReportAPI" /applicationPool:"CSETAPP"

& ${Env:windir}\system32\inetsrv\appcmd add site /name:"CSETUI" /physicalPath:"C:\inetpub\wwwroot\CSETUI" /bindings:"http/*:80:"
& ${Env:windir}\system32\inetsrv\appcmd set site "CSETUI" /applicationPool:"CSETAPP"

# Carry on with database setup...