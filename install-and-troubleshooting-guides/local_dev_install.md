# CSET Local Development Installation Instructions

## Introduction
This documentation is provided to assist users in installing and running CSET locally for development.

## Prerequisites & Necessary Files

1. Windows OS required either via Windows machine or VM
2. Node.js which can be downloaded and installed [here at the node website.](https://nodejs.org/en/download/)
3. Angular for CSETWebNg. You can find local installation [here at the angular website and along with docs.](https://angular.io/guide/setup-local)
4. Git tools for Windows.
5. Visual Studio 2022 (Community Edition is fine) which can be [downloaded here](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=Community&rel=16)
6. VS Code which can be [downloaded here](https://code.visualstudio.com/docs/?dv=win).

Note: VS Code and Visual Studio are two different IDE's. VS Code is used for front-end UI (CSETWebNg) while Visual Studio is used for the back-end (CSETWebAPI).

## Installation

1. Clone CSET GitHub repo.
2. Move into project `cd cset`

## Setting up Angular Web UI

Here you can open VS Code and run these commands from the terminal within VS Code.

1. Move to angular folder `cd CSETWebNg`
2. Install packages `npm install` or `npm i`
3. Run server `ng serve`

## Setting up Backend API

1. Follow steps above for setting up DB: 
    1. [CSET Enterprise Installation Instructions](enterprise_install.md#cset-enterprise-installation-instructions)
    2. [SQL Server Installation](enterprise_install.md#sql-server-installation)
    3. [Firewall Configuration](enterprise_install.md#firewall-configuration)
    4. [Database Setup](enterprise_install.md#database-setup)
    5. [Create Database User](enterprise_install.md#create-database-user)
2. Open CSET with Visual Studio.
3. Select the `CSETWeb_Api.sln` solution file.
4. Open `appsettings.json` in the CSETWebCore.Api project and change the settings in `connectionStrings` according to [CSET Configuration](enterprise_install.md#cset-configuration).
5. Build solution and run within Visual Studio by selecting the play button on the top with "CSETWeb_ApiCore" selected.

![](img/figApiRun.png) 



This will open a window in the default web browser to confirm that the db is connected.