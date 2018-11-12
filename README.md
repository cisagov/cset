# CSET 9.0

## License

MIT License, Apache License 2.0

Copyright 2018 Battelle Energy Alliance, LLC

See License.txt, NOTICE.txt

Contact information of authors: cset@hq.dhs.gov

Idaho National Laboratory, P.O. Box 1625, MS 3870, Idaho Falls, ID 83415

Includes software licensed under LGPL

LGPL dependencies are required to build CSET. You will be required to aquire them via nuGet in order to build this software. They are not distributed with this source.

This application uses Hangfire software as a nuGet dependency.

## CSET 9.0 Enterprise Installation Instructions

### Overview

This guide will detail the procedure for installing the latest version of the Cyber Security Evaluation Tool (CSET 9.0) in a web-based configuration on a Microsoft Windows Server 2016 instance running Microsoft SQL Server 2016.

### Prerequisites

In order to configure the CSET Database, an instance of Microsoft SQL Server Management Studio (SSMS) which is able to connect to the server instance will be required.

You will also need to obtain the latest CSET distribution source tree, and build it.
(see build.sh for an example of how to build, or build in Microsoft Visual Studio and NPM).

### Note

For the purposes of this document, a Windows Server 2016 instance, running inside a VMWare Workstation Pro 14 virtual machine will be used. The same VM will be running the database and the web server.

In order to host the database and web server on separate machines, the procedure given in this document will need to be modified accordingly, and extra care will be required in configuration steps (e.g.: the Web.config file will need to be edited to refer to the SQL Server machine, instead of localhost).

For other configurations, please refer to the applicable documentation from the relevant operating system and software vendors.

### Installation Steps

#### IIS Setup

CSET is deployed as an IIS website. We will now install and configure the IIS Web Server for CSET deployment.

- left click on &quot;Add roles and features (button)&quot; in &quot;Server Manager&quot;
- select &quot;Role-based or feature-based installation&quot; and continue
- select the &quot;Web Server (IIS)&quot; checkbox on the Server Roles list
- expand the &quot;Web Server (IIS)&quot; list item, the &quot;Web Server&quot; list item, and the &quot;Application Development&quot; list item
- select the ASP.NET 4.6 checkbox and continue
- expand &quot;.NET Framework 4.6 Features&quot; list item on the Features list
- select the &quot;ASP.NET 4.6&quot; checkbox and continue
- select the &quot;HTTP Redirection&quot; checkbox in the Role Services list and continue
- complete the installation

#### SQL Server Installation

CSET requires a SQL Server database. In this document, we will install a new SQL Server instance on the Windows Server, and configure it for CSET. If a SQL Server instance already exists, skip this section, and continue to Additional Dependencies. Ensure you have administrative access and privileges on the database.

- Insert the SQL Server disk, or mount the disk image and run Setup.exe
- Click the &quot;Installation&quot; link on the navigation pane on the left
- Click the &quot;New SQL Server stand-alone installation or add features to an existing installation&quot; link
- Enter your product key and continue, accepting the license terms
- At the Feature Selection screen, select the &quot;Database Engine Services&quot; checkbox on the Features list and continue
- At the Database Engine Configuration screen, select the &quot;Mixed Mode (SQL Server authentication and Windows authentication)&quot; radio button
- Enter (and confirm) a password for the server administrator (sa) account
  - Take note of this password. It will be required in a later step
- Click the &quot;Add Current User&quot; button and continue when the user information appears in the text box
  - It may take a few moments for the user information to appear in the text box
- Complete the installation

#### Additional Dependencies

There is some additional software required by CSET. We will now install this software.

The software required is the Microsoft URL Rewrite Module 2.0 for IIS. It can be obtained through the Microsoft website at [https://www.microsoft.com/en-us/download/details.aspx?id=7435](https://www.microsoft.com/en-us/download/details.aspx?id=7435).

Simply download the file to the server and run it. This will install the module needed for IIS to function properly with CSET.

#### Firewall Configuration

In order to configure and use the new SQL Server instance, it needs to be able to receive incoming connections. By default, this is prevented by the Windows firewall. We will now reconfigure the firewall to allow incoming database connections.

- From the Windows &quot;Start&quot; menu, search for &quot;firewall&quot;, and select &quot;Windows Firewall with Advanced Security&quot;
- On the navigation pane on the left, click &quot;Inbound Rules&quot;
- On the Actions pane on the right, click &quot;New Rule…&quot;
- Select the &quot;Port&quot; radio button and continue
- Select the &quot;Specific local ports&quot; radio button
- In the text field, input **1433** and continue
- Select the &quot;Allow the connection&quot; radio button and continue
- On the Profile screen, select which networks you wish to allow incoming connections from, and continue
- Enter a name and a description for this rule, and continue
  - The description is optional, but the name should reference SQL Server

#### Database Setup

The database used by CSET must be configured properly for CSET. This step involves configuring the SQL Server instance installed in a previous step.

- On the server or virtual machine, navigate to the CSET Distribution which was downloaded previously
- In the &quot;Database Images&quot; folder, there are two files: CSETWeb.mdf and CSETWeb\_log.ldf.
- Copy these files to a suitable shared location such as the root of the C: drive
  - You will need to ensure that users have adequate permissions to read and modify both files

- On a host or client machine, open SSMS
- Connect to the SQL Server instance using an administrative account, such as the &#39;sa&#39; account created while installing the SQL Server instance in the previous step
  - The server or virtual machine needs to be configured to be reachable on the network by the host or client machine, but this is outside of the scope of this document
- In the navigation pane on the left, right click on Databases
- Click Attach
- In the Attach Databases dialog, click the Add button
- In the Locate Database Files dialog, navigate to the folder you copied the database images to
- Select CSETWeb.mdf and click OK
- In the Attach Databases dialog, click OK
- In the navigation pane on the left, under Databases, CSETWeb should appear

#### Create Database User

In order for the CSET application to use the database, it needs a user account to connect as. This step details the creation of a suitable user account in the CSET database. This user account will be used in the CSET Configuration process.

- Right click on the Security list item in the navigation pane
- Select New then select Login…
- Enter the credentials for the user account that will be used by the CSET application to connect to the database
  - If using Windows authentication, you will need to provide a valid account on the domain that the IIS and SQL servers are on
  - Make note of the credentials used in this step. They will be used in the CSET Configuration process
- In the &quot;Default database&quot; selector, select &quot;CSETWeb&quot;
- In the navigation pane of the &quot;Login Properties&quot; window, select &quot;User Mapping&quot;
- Select the CSETWeb checkbox, and click OK
- Expand the CSETWeb database list item in the navigation pane
- Expand the Security folder, under the CSETWeb database list item
- Expand the Users folder
- Right click on the user corresponding to the login you created
- Click Properties
- In the navigation pane of the &quot;Database User&quot; window, select Securables
- Click Search…
- Select the &quot;Specific objects…&quot; radio button, and click OK
- Click &quot;Object Types…&quot;
- Select the Schemas checkbox, and click OK
- Click Browse…
- Select the [dbo] checkbox, and click OK
- Click OK in the &quot;Select Objects&quot; window
- In the Securables: list, select the dbo line
- In the &quot;Permissions for dbo:&quot; list, locate the Execute line, and select the Grant checkbox
- In the navigation pane of the &quot;Database User&quot; window, select Membership
- In the &quot;Database role membership:&quot; list, select db\_datareader and db\_datawriter, and click OK

#### CSET Installation

With the system properly configured, CSET itself can now be installed.

- On the server or virtual machine, navigate to the CSET Distribution which was downloaded previously
- Navigate to the &#39;dist&#39; folder
  - The contents of this file will need to be copied to the folder for the IIS website it is being deployed to
- In the navigation pane on the left side of the Server Manager window, click IIS
- In the SERVERS list, right click on the server instance you will be deploying to
  - If you have followed the installation instructions given, it will be the only item in the list, and will be highlighted
- Click &quot;Internet Information Services (IIS) Manager&quot; on the right-click menu
- In the &quot;Internet Information Services (IIS) Manager&quot; window, on the left navigation pane, locate the server name, and expand that list item
- Expand the Sites list item
- Click on the &quot;Default Web Site&quot; list item
- In the Actions pane on the right side, click Explore
- A new Windows Explorer window will appear
- Remove the files in that folder, **but**  **do not**  **delete the &#39;aspnet\_client&#39; folder**
- Copy all of the contents of the &#39;dist&#39; folder (inside the CSET distribution) into this folder

#### CSET Configuration

Now that CSET is installed, it must be configured before it can be used.

- In the website folder found in the &quot;CSET Installation&quot; steps, locate the file Web.config
- Open this file in a text editor such as Notepad
  - You will need to ensure you have proper permissions to modify this file before editing
- Locate the section of code between the _\<connectionStrings\>_ and the _\</connectionStrings\>_ tags
- On each of these lines, locate the words _data source_
- Edit these to reference the IP address or domain name of the machine that the SQL Server instance is installed on (e.g.: _data source=domain.name.here_ or _data source=123.456.789.012_)
  - If IIS and SQL Server are running on the same machine, then use _localhost_ as the domain name
- Edit the lines to indicate login credentials after _persist security info=True;_
  - The information used in this step will be the login credentials of the new database login created in the Create Database User procedure
  - If SQL Server authentication will be used, then a user id and password will need to be provided for the login that will be used
    - E.g.: user id=cset\_user;password=AbC!2#;
  - If Windows domain authentication will be used, then the user id and password will need to be replaced with _Trusted\_Connection=SSPI;_


## Using the CSET Stand-alone Installer

Double-click on the CSETStandAlone program.

The User Account Control dialogue will come up (Fig.1). Select &quot;Yes&quot;.

![][fig1]
 
Figure 1: User Account Control box

A CSET 9.0 dialogue will open asking if you want to install CSET 9.0 Desktop (Fig.2). Select &quot;Yes&quot;.

![][fig1]
 
Figure 2: Install dialogue

The program will begin extracting.

After extracting a CSET 9.0 Setup dialogue will open (Fig.3). Select &quot;Install&quot;.

![][fig3]
 
Figure 3. CSET Setup

CSET will begin to install. If the user doesn&#39;t have IIS 10.0 Express, CSET will install it. The IIS 10.0 Express Setup dialogue will open (Fig.4). Click the check box to confirm that you &quot;…accept the terms in the License Agreement&quot;, and then select &quot;Install&quot;.

![][fig4]
 
Figure 4. IIS Setup

IIS will install. Select &quot;Finish&quot; when it completes.

The CSET 9.0 Setup Wizard will open to walk the user through the install process (Fig.5). Select &quot;Next&quot;.

![][fig5]
 
Figure 5: Setup Wizard

A disclaimer will open (Fig.6). Read through and then click the box &quot;I read the disclaimer&quot;, and select &quot;next&quot;.

![][fig6]
 
Figure 6: Disclaimer

CSET will choose a default folder to install CSET 9.0 to, but you can change this in the Destination Folder dialogue (Fig.7). Select &quot;Next&quot;.

![][fig7]
 
Figure 7: Destination Folder

The CSET Installer will show that it is ready to install (Fig. 8), select &quot;Install&quot;.

![][fig8]
 
Figure 8: Ready to Install

CSET 9.0 will be installed. Make sure that the &quot;Launch CSET 9.0 when setup exists&quot; box is checked, and select &quot;Finish&quot;.

The user should see a setup successful dialogue (Fig.9), and then have an option of how they want to open the app. For this example, Edge was used.

![][fig9]
 
Figure 9: Setup Successful

The user has access to CSET 9.0 as Local User. The Local Installation ribbon is visible at the top of the screen. They can see their landing page with no assessments at this time (Fig.10).

![][fig10]
 
Figure 10: Local Install Landing Page

[fig1]: img/fig1.png
[fig2]: img/fig2.png
[fig3]: img/fig3.png
[fig4]: img/fig4.png
[fig5]: img/fig5.png
[fig6]: img/fig6.png
[fig7]: img/fig7.png
[fig8]: img/fig8.png
[fig9]: img/fig9.png
[fig10]: img/fig10.png