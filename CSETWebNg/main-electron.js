const { app, BrowserWindow, Menu } = require('electron');
const path = require('path');
const url = require('url');
const child = require('child_process').execFile;
const request = require('request');
const log = require('electron-log');
const tcpPortUsed = require('tcp-port-used');
const fs = require('fs');

const angularConfig = require('./dist/assets/config.json');
const gotTheLock = app.requestSingleInstanceLock();
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
  let rootDir = app.getAppPath();

  if (path.basename(rootDir) == 'app.asar') {
    rootDir = path.dirname(app.getPath('exe'));
  }
  log.info('Root Directory of CSET Electron app: ' + rootDir);

  // launch apis depending on configuration (production)
  if (app.isPackaged) {
    launchAPI(rootDir + '/Website', 'CSETWebCore.Api.exe');
    launchAPI(rootDir + '/Website', 'CSETWebCore.Reports.exe');
    // get appsettings file for API
    parseJsonFile(rootDir + '/Website/appsettings.json', (error, configObj) => {
      if (error) {
        log.error(error);
        return;
      }

    });
  } else {
    parseJsonFile(rootDir + '/../CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/appsettings.json', (error, configObj) => {
      if (error) {
        log.error(error);
        return;
      }
      assignPorts(configObj);

    });
  }


  // Create the browser window
  mainWindow = new BrowserWindow({
    width: 1000,
    height: 800,
    webPreferences: { nodeIntegration: true },
    icon: path.join(__dirname, 'dist/favicon_cset.ico'),
    title: 'CSET'
  });

  // remove menu bar if in production
  if (app.isPackaged) {
    Menu.setApplicationMenu(null);
  }

  // keep attempting to connect to API, every 2 seconds, then load application
  retryApiConnection(20, 2000, error => {
    if (error) {
      log.error(error);
      app.quit();
    } else {
      // load the index.html of the app
      mainWindow.loadURL(
        url.format({
          pathname: path.join(__dirname, 'dist/index.html'),
          protocol: 'file:',
          slashes: true
        })
      );
    }
  });

  // Emitted when the window is closed
  mainWindow.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element
    mainWindow = null;
  });

  // Load landing page if any window in app fails to load
  mainWindow.webContents.on("did-fail-load", () => {
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

  mainWindow.webContents.debugger.on('detach', reason => {
    log.info('Debugger detached:', reason);
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
  log.transports.file.resolvePath = () => path.join(app.getPath('home'), 'AppData/Local/DHS/CSET/cset.log');
  log.catchErrors();

  if (mainWindow === null) {
    createWindow();
  }
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    log.info('CSET has been shut down')
    app.quit();
  }
});

function launchAPI(exeDir, fileName) {
  let exe = exeDir + '/' + fileName;
  let options = {cwd:exeDir};
  child(exe, options, (error, data) => {
    log.error(error);
    log.info(data.toString());
  })
}

function parseJsonFile(path, callback) {
  fs.readFile(path, 'utf8', (error, jsonString) => {
    if (error) {
      return callback(error);
    }
    try {
      const jsonObj = JSON.parse(jsonString);
      return callback(null, jsonObj);
    } catch(error) {
      return callback(error);
    }
  });
}

function assignPorts(configFile) {
  tcpPortUsed.check(parseInt(angularConfig.api.port), angularConfig.api.url)
  .then(status => {
    log.info('Port', angularConfig.api.port, 'on', angularConfig.api.url, 'in use:', status);

  }, error => {
    log.error(error);
  });
}

let retryApiConnection = (() => {
  let count = 0;

  return (max, timeout, next) => {
    request.post(
    {
      url:'http://localhost:5000/api/auth/login/standalone',
      json: {}
    },
    (error, response) => {
      if (error || response.statusCode !== 200) {
        if (count++ < max - 1) {
          return setTimeout(() => {
            retryApiConnection(max, timeout, next);
          }, timeout);
        } else {
          return next(new Error('Max API connection retries reached'));
        }
      }

      log.info('Successful connection to API established. Loading CSET main window...');
      next(null);
    });
  }
})();
