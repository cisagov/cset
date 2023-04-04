const { app, BrowserWindow, Menu, MenuItem, shell, session, dialog } = require('electron');
const path = require('path');
const url = require('url');
const child = require('child_process').execFile;
const request = require('request');
const log = require('electron-log');
const tcpPortUsed = require('tcp-port-used');
const findTextPrompt = require('./src/custom-modules/electron-prompt/lib/index');
const gotTheLock = app.requestSingleInstanceLock();

const masterConfig = require('./dist/assets/settings/config.json');

// We can only use one value in the config chain in this script until we figure out an equivalent to fetch for electron
let installationMode = masterConfig.currentConfigChain[0] || 'CSET';

const subConfig = require(`./dist/assets/settings/config.${installationMode}.json`);

// config is the union of the masterConfig and subconfig file based on installationMode for now
// Any properties in subconfig will overwrite those in masterConfig
const config = {...masterConfig, ...subConfig};

let clientCode;
let appCode;
switch(installationMode) {
  case 'ACET':
    clientCode = 'NCUA';
    appCode = 'ACET';
    break;
  case 'TSA':
    clientCode = 'TSA';
    appCode = 'CSET-TSA';
    break;
  case 'CF':
    clientCode = 'CF';
    appCode = 'CSET-CF';
    break;
  default:
    clientCode = 'DHS';
    appCode = 'CSET';
}

let mainWindow = null;

// preventing a second instance of Electron from spinning up
if (!gotTheLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    // Someone tried to run a second instance, we should focus our window
    if (mainWindow) {
      if (mainWindow.isMinimized()) {
        mainWindow.restore();
      }
      mainWindow.focus();
    }
  });
}

function createWindow() {
  // Create the browser window
  mainWindow = new BrowserWindow({
    width: 1000,
    height: 800,
    webPreferences: { nodeIntegration: true, webSecurity: false },
    icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
    title: appCode
  });

  // Default Electron application menu is immutable; have to create new one and modify from there
  let defaultMenu = Menu.getApplicationMenu();
  let newMenu = new Menu();

  // Setup Electron application menu (remove empty help tab and add print option)
  defaultMenu.items.filter(x => x.role != 'help').forEach(x => {
    if (x.role === 'filemenu') {
      let newSubmenu = new Menu();

      // Add print option (we only want to print the focused window)
      newSubmenu.append(
        new MenuItem({
          type: 'normal',
          label: 'Print',
          accelerator: 'Ctrl+P',
          click: () => {
            BrowserWindow.getFocusedWindow().webContents.print();
          }
        })
      );

      x.submenu.items.forEach(y => newSubmenu.append(y));
      x.submenu = newSubmenu;

      newMenu.append(
        new MenuItem({
          role: x.role,
          type: x.type,
          label: x.label,
          submenu: newSubmenu,
        })
      );
    } else if (x.role === 'windowmenu') {
      let newSubmenu = new Menu();

      // Remove unnecessary Zoom button from window tab
      x.submenu.items.filter(y => y.label != 'Zoom').forEach(z => newSubmenu.append(z));
      x.submenu = newSubmenu;

      newMenu.append(
        new MenuItem({
          role: x.role,
          type: x.type,
          label: x.label,
          submenu: newSubmenu,
        })
      );
    } else if(x.role === 'viewmenu') {
      let newSubmenu = new Menu();

      // Remove unnecessary Zoom button from window tab
      x.submenu.items.forEach(y => {
        if (y.label === 'Zoom In') {
          let newZoomIn = new MenuItem({
            role: y.role,
            type: y.type,
            label: y.label,
            accelerator: 'Ctrl+Shift+Up',
            click: y.click
          });
          newSubmenu.append(newZoomIn);
        } else if (y.label === 'Zoom Out') {
          let newZoomOut = new MenuItem({
            role: y.role,
            type: y.type,
            label: y.label,
            accelerator: 'Ctrl+Shift+Down',
            click: y.click
          });
          newSubmenu.append(newZoomOut);
        } else {
          newSubmenu.append(y);
        }
      });

      // Add find in page (ctrl + f) functionality
      let findInPage = new MenuItem({
        type: 'normal',
        label: 'Find...',
        accelerator: 'Ctrl+F',
        click: () => {
          let currentWindow = BrowserWindow.getFocusedWindow()
          findTextPrompt({
            title: 'Find Text',
            label: 'Find:',
            type: 'input',
            icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
            alwaysOnTop: true,
            height: 190,
            inputAttrs: {
              required: true
            },
            buttonLabels: {
              ok: 'Find Next'
            }
          }, currentWindow).then(r => {
            if(r === null) {
              // text search is done here
            }
          }).catch(e => {
            log.error(e);
          });
        }
      });
      newSubmenu.append(findInPage);

      x.submenu = newSubmenu;

      newMenu.append(
        new MenuItem({
          role: x.role,
          type: x.type,
          label: x.label,
          submenu: newSubmenu,
        })
      );
    } else {
      newMenu.append(x);
    }
  });

  Menu.setApplicationMenu(newMenu);

  mainWindow.loadFile(path.join(__dirname, config.behaviors.splashPageHTML));

  let rootDir = app.getAppPath();

  if (path.basename(rootDir) == 'app.asar') {
    rootDir = path.dirname(app.getPath('exe'));
  }

  log.info('Root Directory of ' + installationMode.toUpperCase() + ' Electron app: ' + rootDir);

  if (app.isPackaged) {

    // Check angular config file for initial API port and increment port automatically if designated port is already taken
    let apiPort = parseInt(config.api.port);
    let apiUrl = config.api.url;
    assignPort(apiPort, null, apiUrl).then(assignedApiPort => {
      log.info('API launching on port', assignedApiPort);
      launchAPI(rootDir + '/Website', 'CSETWebCore.Api.exe', assignedApiPort, mainWindow);
      return assignedApiPort;
    }).then(assignedApiPort => {
      // Keep attempting to connect to API, every 2 seconds, then load application
      retryApiConnection(120, 2000, assignedApiPort, error => {
        if (error) {
          log.error(error);
          mainWindow.loadFile(path.join(__dirname, '/dist/assets/app-startup-error.html'));
        } else {
           // Load the index.html of the app
           mainWindow.loadURL(
            url.format({
              pathname: path.join(__dirname, 'dist/index.html'),
              protocol: 'file:',
              query: {
                apiUrl: config.api.protocol + '://' + config.api.url + ':' + assignedApiPort,
              },
              slashes: true
            })
          );
        }
      });
    });
  } else {
    mainWindow.loadURL(
      url.format({
        pathname: path.join(__dirname, 'dist/index.html'),
        protocol: 'file:',
        query: {
          apiUrl: config.api.protocol + '://' + config.api.url + ':' + config.api.port
        },
        slashes: true
      })
    );
  }

  // Emitted when the window is closed
  mainWindow.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element
    mainWindow = null;

  });

  // Emitted when the window is going to be closed
  mainWindow.on('close', () => {
    // Clear cache & local storage before the window is closed
    session.defaultSession.clearCache();
    session.defaultSession.clearStorageData();
  });

  // Customize the look of all new windows and handle different types of urls from within angular application
  mainWindow.webContents.setWindowOpenHandler(details => {
    // trying to load url in form of index.html?returnPath=report/
    if (details.url.includes('returnPath=report')) {
      let childWindow = new BrowserWindow({
        parent: mainWindow,
        width: 1000,
        height: 800,
        webPreferences: { nodeIntegration: true },
        icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
      })

      const newPath = details.url.substring(details.url.indexOf('index.html'));
      const newUrl = 'file:///' + __dirname + '/dist/' + newPath;

      log.info('Navigated to ' + newUrl);
      childWindow.loadURL(newUrl);

      return {action: 'deny'};

    // navigating to help section; prevent additional popup windows
    } else if (details.url.includes('htmlhelp')) {
        let childWindow = new BrowserWindow({
          parent: mainWindow,
          webPreferences: { nodeIntegration: true },
          icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
        })

        childWindow.loadURL(details.url);

        childWindow.webContents.on('new-window', (event, newUrl) => {
          event.preventDefault();
          childWindow.loadURL(newUrl);
        })

      return { action: 'deny' };

    // Navigating to external url; open in web browser
    } else if (details.url.includes('.com') || details.url.includes('.gov') || details.url.includes('.org')) {
      shell.openExternal(details.url);
      return {action: 'deny'};
    }
    return {
      action: 'allow',
      overrideBrowserWindowOptions: {
        parent: mainWindow,
        icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
        title: details.frameName === 'csetweb-ng' || '_blank' ? `${installationMode}` : details.frameName
      }
    };
  })

  mainWindow.webContents.on('did-create-window', childWindow => {

    // Child windows that fail to load url are closed
    childWindow.webContents.on('did-fail-load', (event, errorCode, errorDescription) => {
      log.error(errorDescription);
      childWindow.close();
    })
  })

  // Load landing page if any window in app fails to load
  mainWindow.webContents.on('did-fail-load', () => {
    mainWindow.loadURL(
      url.format({
        pathname: path.join(__dirname, 'dist/index.html'),
        protocol: 'file:',
        slashes: true
      })
    );
  });

  // setting up logging
  try {
    mainWindow.webContents.debugger.attach('1.3');
  } catch (error) {
    log.error('Debugger attach failed:', error);
  }

  mainWindow.webContents.debugger.on('detach', () => {
    log.info('Debugger has been detached');
  });

  mainWindow.webContents.debugger.on('message', (event, method, params) => {
    if (method === 'Network.responseReceived') {
      mainWindow.webContents.debugger.sendCommand('Network.getResponseBody', { requestId: params.requestId }).then(body => {
        if (params.response.url.toString().substring(0, 4) != 'file') {
          log.info('REQUEST AT:', params.response.url, 'RETURNED STATUS CODE', params.response.status, '\nRESPONSE BODY:', body);
        }
      }).catch(() => {
        // Errors here being caused by traffic before api connection is established, so they are irrelevant
      });
    }
  });

  mainWindow.webContents.debugger.sendCommand('Network.enable');
}

// log all node process uncaught exceptions
process.on('uncaughtException', error => {
  log.error(error);
  app.quit();
})

app.on('ready', () => {
  // set log to output to local appdata folder
  log.transports.file.resolvePath = () => path.join(app.getPath('home'), `AppData/Local/${clientCode}/${appCode}/${appCode}_electron.log`);
  log.catchErrors();

  if (mainWindow === null) {
    createWindow();
  }
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    log.info(installationMode.toUpperCase() + ' has been shut down')
    app.quit();
  }
});

function launchAPI(exeDir, fileName, port, window) {
  let exe = exeDir + '/' + fileName;
  let options = {cwd:exeDir};
  let args = ['--urls', config.api.protocol + '://' + config.api.url + ':' + port]
  child(exe, args, options, (error, stdout) => {
    if (error) {
      window.loadFile(path.join(__dirname, '/dist/assets/app-startup-error.html'));
      log.error(error);
      if (error.stack.includes('DatabaseManager.DatabaseSetupException')) {
        dialog.showErrorBox(`${appCode} Database Setup Error`, `There was a problem initializing the SQL LocalDB ${appCode} database. Please restart your system and try again.\n\n` + stdout);
      }
    }
  });
}

// Increment port number until a non listening port is found
function assignPort(port, offLimitPort, host) {
  return tcpPortUsed.check(port, host).then(status => {
    if (status === true || port === offLimitPort) {
      log.info('Port', port, 'on', host, 'is already in use. Incrementing port...');
      return assignPort(port + 1, offLimitPort, host);
    } else {
      return port;
    }
  }, error => {
    log.error(error);
  });
}

let retryApiConnection = (() => {
  let count = 0;

  return (max, timeout, port, next) => {
    request.get(
    {
      url:'http://localhost:' + port + '/api/IsRunning'
    },
    (error, response) => {
      if (error || response.statusCode !== 200) {
        if (count++ < max - 1) {
          return setTimeout(() => {
            retryApiConnection(max, timeout, port, next);
          }, timeout);
        } else {
          return next(new Error('Max API connection retries reached'));
        }
      }

      log.info('Successful connection to API established. Loading ' + installationMode.toUpperCase() + ' main window...');
      next(null);
    });
  }
})();
