const { app, BrowserWindow, Menu, shell } = require('electron');
const path = require('path');
const url = require('url');
const child = require('child_process').execFile;
const request = require('request');
const log = require('electron-log');
const tcpPortUsed = require('tcp-port-used');

const angularConfig = require('./dist/assets/config.json');
const gotTheLock = app.requestSingleInstanceLock();
let mainWindow = null;

let installationMode = angularConfig.installationMode;
if (!installationMode || installationMode.length === 0) {
  installationMode = 'cset';
}

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
    webPreferences: { nodeIntegration: true },
    icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
    title: installationMode.toUpperCase()
  });

  mainWindow.loadFile(path.join(__dirname, 'dist/assets/splash.html'))

  let rootDir = app.getAppPath();

  if (path.basename(rootDir) == 'app.asar') {
    rootDir = path.dirname(app.getPath('exe'));
  }

  log.info('Root Directory of ' + installationMode.toUpperCase() + ' Electron app: ' + rootDir);

  if (app.isPackaged) {
    //Menu.setApplicationMenu(null);

    // check angular config file for initial API port and increment port automatically if designated port is already taken
    let apiPort = parseInt(angularConfig.api.port);
    let apiUrl = angularConfig.api.url;
    assignPort(apiPort, null, apiUrl).then(assignedApiPort => {
      log.info('API launching on port', assignedApiPort);
      launchAPI(rootDir + '/Website', 'CSETWebCore.Api.exe', assignedApiPort);
      return assignedApiPort;
    }).then(assignedApiPort => {

      // port checking for reports api...
      let reportsApiPort = parseInt(angularConfig.reportsApi.substr(angularConfig.reportsApi.length - 6, 5));
      assignPort(reportsApiPort, assignedApiPort, apiUrl).then(assignedReportsApiPort => {
        log.info('Reports API launching on port', assignedReportsApiPort);
        launchAPI(rootDir + '/Website', 'CSETWebCore.Reports.exe', assignedReportsApiPort);
        return {apiPort: assignedApiPort, reportsApiPort: assignedReportsApiPort};
      }).then(ports => {

        // keep attempting to connect to API, every 2 seconds, then load application
        retryApiConnection(30, 2000, ports.apiPort, error => {
          if (error) {
            log.error(error);
            app.quit();
          } else {

            // load the index.html of the app
            mainWindow.loadURL(
              decodeURI(url.format({
                pathname: path.join(__dirname, 'dist/index.html'),
                protocol: 'file:',
                query: {
                  apiUrl: angularConfig.api.protocol + '://' + angularConfig.api.url + ':' + ports.apiPort,
                  reportsApiUrl: angularConfig.reportsApi.substr(0, 17) + ports.reportsApiPort + '/'
                },
                slashes: true
              })
            ));
          }
        });
      });
    });
  } else {
    mainWindow.loadURL(
      decodeURI(url.format({
        pathname: path.join(__dirname, 'dist/index.html'),
        protocol: 'file:',
        query: {
          apiUrl: angularConfig.api.protocol + '://' + angularConfig.api.url + ':' + angularConfig.api.port,
          reportsApiUrl: angularConfig.reportsApi
        },
        slashes: true
      })
    ));
  }

  // Emitted when the window is closed
  mainWindow.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element
    mainWindow = null;
  });

  // Customize the look of all new windows and handle different types of urls from within angular application
  mainWindow.webContents.setWindowOpenHandler(details => {
    // trying to load url in form of index.html?returnPath=report/
    if (details.url.includes('report')) {
      let childWindow = new BrowserWindow({
        parent: mainWindow,
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
        icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
        title: details.frameName === 'csetweb-ng' || '_blank' ? 'CSET' : details.frameName
      }
    };
  })

  // Child windows that fail to load url are closed
  mainWindow.webContents.on('did-create-window', childWindow => {

    childWindow.webContents.on('did-fail-load', (event, errorCode, errorDescription) => {
      log.error(errorDescription);
      childWindow.close();
    })
  })

  // Load landing page if any window in app fails to load
  mainWindow.webContents.on('did-fail-load', () => {
    mainWindow.loadURL(
      decodeURI(url.format({
        pathname: path.join(__dirname, 'dist/index.html'),
        protocol: 'file:',
        slashes: true
      })
    ));
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
  log.transports.file.resolvePath = () => path.join(app.getPath('home'), 'AppData/Local/DHS/CSET/cset11000.log');
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

function launchAPI(exeDir, fileName, port) {
  let exe = exeDir + '/' + fileName;
  let options = {cwd:exeDir};
  let args = ['--urls', angularConfig.api.protocol + '://' + angularConfig.api.url + ':' + port]
  child(exe, args, options, (error, data) => {
    log.error(error);
    log.info(data.toString());
  })
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
