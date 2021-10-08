const { app, BrowserWindow } = require('electron');
const path = require('path');
const url = require('url');
const child = require('child_process').execFile;
const request = require('request');
const log = require('electron-log');

let mainWindow = null;
const gotTheLock = app.requestSingleInstanceLock();

// preventing a second instance of Electron from spinning up
if (!gotTheLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    // Someone tried to run a second instance, we should focus our window.
    if (mainWindow) {
      if (mainWindow.isMinimized()) {
        mainWindow.restore();
      }
      mainWindow.focus();
    }
  });
}

function createWindow(callback) {
  let rootDir = app.getAppPath();
  if (path.basename(rootDir) == 'app.asar') {
    rootDir = path.dirname(app.getPath('exe'));
  }
  log.info('Root Directory of CSET Electron app: ' + rootDir);
  // launch api locations depending on configuration (production)
  if (app.isPackaged) {
    callback(rootDir + '/Website', 'CSETWebCore.Api.exe');
    callback(rootDir + '/Website', 'CSETWebCore.Reports.exe');
  }
  else {
    callback(rootDir + '/../CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/bin/Release/net5.0', 'CSETWebCore.Api.exe');
    callback(rootDir + '/../CSETWebApi/CSETWeb_Api/CSETWebCore.Reports/bin/Release/net5.0', 'CSETWebCore.Reports.exe');
  }

  // Create the browser window.
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
  retryApiConnection(20, 2000, err => {
    if (err) {
      log.error(err);
    } else {
      // load the index.html of the app.
      mainWindow.loadURL(
        url.format({
          pathname: path.join(__dirname, 'dist/index.html'),
          protocol: 'file:',
          slashes: true
        })
      );
    }
  });

  // Emitted when the window is closed.
  mainWindow.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });

  // setting up logging
  try {
    mainWindow.webContents.debugger.attach('1.3');
  } catch (err) {
    log.error('Debugger attach failed:', err);
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

app.on('ready', () => {
  // set log to output to local appdata folder
  log.transports.file.resolvePath = () => path.join(app.getPath('home'), 'AppData/Local/DHS/CSET/cset.log');
  log.catchErrors();

  if (mainWindow === null) {
    createWindow(launchAPI);
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
