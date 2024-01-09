## CSET Local Developement Installation Instructions

### Introduction
This documentation is provided to assist users in installing and running CSET locally for development.

### Prerequisites & Necessary Files

1. Windows OS required either via Windows machine or VM
2. Node.js which can be downloaded and installed [here at the node website.](https://nodejs.org/en/download/)
3. Angular 2 for CSETWebApi. You can find local installation [here at the angular website and along with docs.](https://angular.io/guide/setup-local)
4. Git tools for Windows.
5. Visual Studio 2022 (Community Edition is fine) which can be [downloaded here](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=Community&rel=16)
6. VS Code which can be [downloaded here.](https://code.visualstudio.com/docs/?dv=win)

Note: VSCode and Visual studio are two diffent IDE's VS Code is used for Front end UI (CSETWebNg) while Visual Studio is used for the backend (CSETWebAPI)

### Installation

1. Clone CSET github repo.
2. Move into project `cd cset`

### Setting up Angular Web UI

Here you can open VSCode and run these commands from the terminal within VSCode.

1. Move to angular folder `cd CSETWebNg`
2. Install packages `npm install` or `npm i`
3. Run server `ng serve`

### Setting up Backend Api

1. Follow Steps above for setting up DB: 
    1. [CSET Enterprise Installation Instructions](https://github.com/cisagov/cset#cset-enterprise-installation-instructions)
    2. [SQL Server Installation](https://github.com/cisagov/cset#sql-server-installation)
    3. [Firewall Configuration](https://github.com/cisagov/cset#firewall-configuration)
    4. [Database Setup](https://github.com/cisagov/cset#database-setup)
    5. [Create Database User](https://github.com/cisagov/cset#create-database-user)
2. Open CSET with Visual Studio.
3. Select `CSETWeb_Api.sin` for project file.
4. Open `appsettings.json` in the CSETWebCore.Api project and change the settings in `connectionStrings` according to [CSET Configuration](https://github.com/cisagov/cset#cset-configuration).
5. Build solution and run within Visual Studio by selecting the play button on the top with "CSETWeb_ApiCore" selected.

![](img/figApiRun.png) 

<br>

This will open a window in the default web browser to confirm that the db is connected.