# CSET Enterprise Installation Instructions

## Introduction
This documentation is provided to assist users in navigating the basics of the CSET® Enterprise Edition for use on Windows Server. 
Here users will find step-by-step directions for installation, configuration, and setup, as well as links to 
various resources to assist in this process.

## Using the Provided Setup Script
The enterprise installation can be automated through the use of a provided PowerShell script named ```setup_enterprise.ps1``` 
(as of CSET release v11.0.1.2). This script is located in the root of the enterprise binaries zip folder.

1. Download and extract the CSET enterprise binaries from the archive to a desired location on your computer.

![](img/figES0.PNG)

2. Search for PowerShell from the Windows Start menu. Right-click on Windows Powershell then click "Run as administrator."

![](img/figES1.PNG)

3. Navigate to the extracted CSET binaries folder. In this example, the folder is located on the user desktop. The PowerShell command to navigate to the desktop directory would be: <br/>
 ```cd C:\users\%USER%\Desktop\CSETv%VERSION%_Enterprise_Binaries```.

4. To run the setup script in the enterprise binaries directory, type ```.\setup_enterprise``` and hit the enter key.

5. The script will open the installation wizards for SQL Server Express 2022 and the .NET 7 Hosting Bundle. The script will not proceed to each subsequent installation step until each installation wizard window is closed. It will also install IIS and IIS Manager in the background.

![](img/figES2.PNG) 
<br/>

6. The script will then prompt for the creation of a password for the new CSET service user.

![](img/figES3.PNG)
<br/>

7. The script will create the application pools and sites necessary for hosting CSET in IIS. Next, the script will prompt for the SQL server name to be used for the database setup. This name will likely be in the following format: <br/> 
```%COMPUTERNAME%\SQLEXPRESS```

![](img/figES4.PNG)
<br/>

8. Once the script finishes its execution, open IIS Manager and browse the CSETUI site to begin using CSET.

![](img/figES5.PNG)
<br/>

![](img/figES6.PNG)
<br/>

## Manual Setup

## Prerequisites & Necessary Files
1.	Download the CSET Enterprise Files from the [CSET® releases page](https://github.com/cisagov/cset/releases). Click the "CSETvXXXX_Enterprise_Binaries.zip" file to download it. Once the download is complete, you will need to unzip the folder. This folder includes the CSET® application binaries, as well as the required installation packages listed in prerequsites 2-4.

2.	We will be using Microsoft SQL Server 2022 for this setup. If you need to, you can download the [Express version from Microsoft directly](https://www.microsoft.com/en-us/download/details.aspx?id=101064).
  
3.	CSET® requires your server to have the URL Rewrite Module installed as well. Again, this can be downloaded [directly from Microsoft](https://www.iis.net/downloads/microsoft/url-rewrite) (Note that this module cannot be installed until IIS has been installed first. The process for installing IIS is explained in the next section).
  
4. CSET® requires the ASP.NET Core 7 and .NET 7 runtimes to run successfully. It is recommended to install these using the .NET 7 Hosting Bundle, which includes both of these runtimes and IIS support. This can be downloaded [directly from Microsoft](https://dotnet.microsoft.com/en-us/download/dotnet/7.0).

5.	If you are using a SQL Server, download and install Microsoft [SQL Server Management Studio (SSMS)](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15).


## Installing IIS
1.	On your Windows Server, open the “Server Manager” application.

![](img/figE1.PNG) 
<br/>

2.	Click “Add Roles and Features.” This should open the Roles and Features Wizard that will guide you through the installation process. 

![](img/figE2.PNG)<br/>

  * Installation Type – This should default to “Role-based or feature-based installation.” If it does not, please select this option.
  * Server Selection – Choose the server you plan on running CSET® on.
  * Server Roles – Select the “Web Server (IIS)” check box. Add any features the program prompts you for.
  * Features – The defaults will work just fine for running CSET®, however you may add any additional features you wish.
  * Web Server Role (IIS) – Click “Next.”
  * Role Services – Under Common HTTP Features, select “HTTP Redirection.”
  * Confirmation – Click “Install”. Close out of the Wizard when installation is complete.

  3. It may be necessary to create a new IIS Application Pool for your CSET Installation to run properly. When setting up the application in IIS, create a new Application Pool for CSET and give it the identity of the account you want to access the SQL Server with. Provided below are links to the official Microsoft documentation for this process.
  * To read more about IIS Application Pool creation click [here](https://docs.microsoft.com/en-us/iis/configuration/system.applicationhost/applicationpools/).
  * To read more about Pool Identification click [here](https://docs.microsoft.com/en-us/iis/manage/configuring-security/application-pool-identities).

![](img/figE3.PNG)<br/>

## SQL Server Installation
1.	To begin the process of installing a new SQL Server on your machine (see below): 
  * Open Microsoft’s “SQL Server Installation Center” 
  * On the left, select “Installation” 
  * Click “New SQL Server standalone installation” 

  ![](img/figE4.PNG)<br/>

  * Input your product key (if needed) and accept the licensing terms to continue the installation.
  * The defaults for most of the sections will be just fine. However, the two sections you will need to modify are “Feature Selection” and “Database Engine Configuration.”
  * Feature Selection (see below) – When you are prompted to select specific server features, check the “Database Engine Services” box and then continue.

    ![](img/figE5.PNG)

  * Database Engine Configuration (see below) – At the Database Engine Configuration screen, select the “Mixed Mode (SQL Server authentication and Windows authentication)” option.
  * Under the same section, you will be asked to create and input a password for the system administrator account. Make sure to remember this information!
  * Finally, click the Add Current User button at the bottom. This will populate your current windows account as a user. Once that is complete, click “Next.”

    ![](img/figE6.PNG)

  * The final step is to click the Install button to finish up this process. Once this is complete, you can close out of the Server Setup window.

2. Once your server is up and running, you will need to install the URL Rewrite Module and the .NET 7 Runtimes. Simply download the installation media files from Microsoft (see Page 2 links or above hyperlink) and run them to install the necessary patches.

## Firewall Configuration
1. Open Windows Defender Firewall

![](img/figE7.PNG)

2.	On the left, select “Advanced Settings.”
  * Inside the new window, double-click “Inbound Rules” and then select “New Rule” on the right (see below).

  ![](img/figE8.PNG)

  * Rule Type – Select “Port” as the new rule type and click “Next.”
  * Protocol and Ports (see below) – Change the rule to apply to “Specific local ports” and enter your desired port. Once that is finished, click “Next.”

  ![](img/figE9.PNG)

  * Action – Select the “Allow the connection” radio button. This should be selected by default. Click “Next.”
  * Profile – Choose what type of networks you wish to allow connections from. If you are unsure, leave them all checked. Click “Next.”
  * Name – The final step is to create a name and description for this new rule. Once you’ve done this, click “Finish.”

## Database Setup
1.	Open the CSET® Enterprise Binaries folder that you downloaded earlier and navigate to the “database” subfolder. Inside this folder you will find two files called “CSETWebXXXX” and “CSETWebXXXX_log.” Copy these two files to your server.

2.	Open Microsoft SQL Server Management Studio (see below) and connect to the SQL Server that we setup previously. 
  * Open the “Connect to Server” dialog box.

  ![](img/figE10.PNG)

  * Change the server name to “localhost” or whatever name you have specified for your server already.
  * Your Server can be run through either the “SQL Server Authentication,” which will require the login information you created earlier, or you can use the Windows Authentication, which will not require any login information as the server will verify your identity through your Windows account.

  ![](img/figE11.PNG)

3.	Inside the Object Explorer on the left, right-click the Database folder (see below) and then click “Attach.”

![](img/figE12.PNG)

  * This will bring up the “Attach Databases” dialog box (see below). Click the Add button and navigate to the location where you previously saved/copied the CSETWeb.mdf file. Click on the file and then click “OK,” and then click “OK” again to attach the database.

  ![](img/figE13.PNG)

  * You’ll know you’ve completed this step successfully when you can see the “CSETWeb” object appear under the Databases section in the Object explorer.

  ![](img/figE14.PNG)

## Create Database User
1. Peviously we created our SQL Server account. We will now need to create an account that has access to the database. Continuing in the Object Explorer, right-click on the folder named Security, hover over New (see below) and then click “Login.”

![](img/figE15.PNG)

  * In the next window (see below), enter a login name, select the “SQL Server authentication” radio button, and then enter a password. If you choose to go through the Windows authentication, you will not need to enter a password.
  * At the bottom of the box, change the Default database to CSETWeb.

  ![](img/figE16.PNG)

  * At top-left from the window shown below, click “User Mapping” and then select the CSETWeb checkbox. Then click “OK.”

  ![](img/figE17.PNG)

2.	Back in the Object Explorer of SSMS (see below), expand the CSETWeb list, followed by Security and then Users. You should see the new user you created listed here. For us, it’s simply “user”. Right-click on your user’s name and select properties.

![](img/figE18.PNG)

  * In the dialog box that pops up, select “Securables” from the menu on the left if it is not already selected.
  * Click the Search button to generate another dialog box. Make sure the “Specific objects…” radio button is selected and then click “OK.”

  ![](img/figE19.PNG)

  * Once you hit OK, you should see yet another box pop-up titled “Select Object.” Click the button that says Object Types… This will generate a list of object types. Scroll down until you see the “Schemas” object (see below). Check this box, and then click “OK.”

  ![](img/figE20.PNG)

  * Next, click "Browse" and select the "dbo" checkbox. Then click "Ok".

  ![](img/figE21.PNG)

  * Once we have our dbo inside our Securables, we need to grant it permissions. Scroll through the list of permissions and when you find the "Execute" permission, select the "Grant" checkbox.

  ![](img/figE22.PNG)

  * Our final step is to go over to the Membership page (see below) and select the checkboxes for “db_datareader” and “db_datawriter.” Then select “OK.”

  ![](img/figE23.PNG)

## CSET Installation
1.	Re-open Windows Server Manager (see below). Double-click on “IIS” on the left. Then, right-click on the server name and click “Internet Information Services (IIS) Manager.”

![](img/figE24.PNG)

  * As seen in the picture below, expand the server’s name drop-down list and then expand the Sites drop down list. You should see a “Default Web Site” item. Right-click this item and select “Explore”. This will open the “wwwroot” folder.
  
![](img/figE25.PNG)
  
  * Delete everything inside this folder. 
  * If you’ve done any kind of changes or work inside this folder previously, we recommend copying the contents to preserve those changes as deleting the files will erase any changes you have made.
  * Copy the "CSETUI" and "CSETWebApi" folders from inside the CSET® Enterprise Binaries folder you downloaded and place them into your "wwwroot" folder.
  * You can add two additional websites (i.e. one to host the front-end application called CSETUI and one to host the back-end api called CSETWebApi) and point the physical paths to their respective folders located in "wwwroot." Ensure that the backend site is assigned to an application pool that has the .Net CLR Version set to "No Managed Code."
  * If you set the back-end api port to something other than 5000, you will need to update the following config value found in wwwroot\CSETUI\assets\settings\config.json:

![](img/figE31.PNG)

## CSET Configuration
1.	Locate the "appsettings.json" file that should now be inside the “wwwroot\CSETWebApi” folder. Open this file using a text editor such as notepad.

![](img/figE26.PNG)

  * The top of the document contains the "ConnectionStrings" section. We will need to edit the "CSET_DB" value to correctly connect to CSET®.
  * In the value for "CSET_DB" there is a part that says “data source=…” You will need to change the part after the equals sign to the IP address or domain name of the machine on which the SQL Server is running.

  ![](img/figE27.PNG)

  * If IIS and the SQL Server instance are running on the same machine, you can use “localhost” as the domain name. Otherwise, you will need the specific domain or IP address to connect properly.

  * In the connection string, you will need to update the “Integrated Security=SSPI” section to reflect your SQL Server specific login info.

  ![](img/figE28.PNG)
  
  * If you are using the Windows domain authentication method, then you will use “Integrated Security=SSPI” instead of a user ID and password
  
  * If you run into the error "The certificate chain was issued by an authority that is not trusted" when attempting to establish a connection to the database, you can can add this property to the connection string: `Trust Server Certificate=True`

  * Save and close the appsettings.json file.
  * If you receive an error stating that you do not have permissions to save the appsettings.json file, find the file inside the wwwroot folder and right-click on it. Select properties and go into the security tab. Click on the edit button and make sure that all users have “Full Control” over the file.
  * Go back to the “Internet Information Services (IIS) Manager” and on the right, make sure the server is running. You may now browse to your Enterprise CSET® Installation!

## Other Steps (Optional)
### Creating CSET User
There are two ways to add a new user to your freshly created CSET® Stand-Alone. The first way is to register for a new account inside the CSET® application itself. This will require a valid mail host as user’s will be required to enter their email address and receive a confirmation email on your network.

  1.	Using a browser, navigate to your CSET® webpage.
  2.	At right, select “Register New User Account.”
  3.	Enter your information (name, email, and security questions), and select “Register.”
  4.	A confirmation email will be sent to the email you entered. This email will contain a temporary password that will allow you to login to the CSET® Application.
  5.	Once a user has logged in for the first time, they will be prompted to create their own password to replace the temporary one.

The second way to add a new user to your CSET® Application is to use the “AddUser” program. This tool is intended more for testing purposes than company-wide use. It allows anybody to create a new user without the email check and should only be used by administrators. As such, do not place this program in a public or shared folder on your system. This tool can be downloaded from the latest CSET [releases page](https://github.com/cisagov/cset/releases). Simply click on the "AddUser.zip" link to download the file.

  1.	Inside the “AddUser” folder, you will find a file called “AddCSETUser.exe”. It’s a config file. Open this file with a text editor such as notepad. 
  * Inside the "connectionStrings" tags, you will need to change your “data source=” to the IP Address or domain of your server.
  * You will then need to change the “user id=” and “password=” to the admin account you created previously.
  * Save and close the file.
  
  2.	Double-click on the “AddCSETUser” application and a small dialog box should pop-up with entry fields to add a new CSET® User.

  ![](img/figE29.PNG)

  * Enter the required information and click “Save.”
  * If you’ve connected with the server properly, you will see small green text at the bottom-left of the box that says, “Added Successfully”. You may now login to CSET® using that user account.

## Mail Host Configuration
1.	Inside “wwwroot\CSETWebApi”, open the appsettings.json file.
  * Inside the config file, you will need to locate the “SMTP Host”, and “Sender Email” portions.

  ![](img/figE30.PNG)

  * Edit the text after the equal sign of value to your domain name. (e.g. value=”mailhost.YOURDOMAIN.com”).
  * Save and close the file when you are finished.

## SSL Security Certificate for Extra Security
An SSL certificate is a web technology that establishes a secure link between a web server and a browser. This link encrypts all data (such as passwords) so that your server is more secure.

  1.	You can follow [this tutorial](https://www.digicert.com/ssl-support/pfx-import-export-iis-7.htm) to add an SSL certificate to your CSET® stand-alone.

