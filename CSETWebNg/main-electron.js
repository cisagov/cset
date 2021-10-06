const { app, BrowserWindow, Menu } = require('electron');
const path = require('path');
const url = require('url');
const child = require('child_process').execFile;
const request = require('request');

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
  console.log('Root Directory of Electron app: ' + rootDir);
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
      console.log(err);
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
}

app.on('ready', () => {
  if (mainWindow === null) {
    createWindow(launchAPI);
  }
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

function launchAPI(exeDir, fileName) {
  let exe = exeDir + '/' + fileName;
  let options = {cwd:exeDir};
  child(exe, options, (error, data) => {
    console.log(error);
    console.log(data.toString());
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
        console.log('Attempt #' + (count + 1) + ': Failed to connect to API');

        if (count++ < max - 1) {
          return setTimeout(() => {
            retryApiConnection(max, timeout, next);
          }, timeout);
        } else {
          return next(new Error('Max API connection retries reached'));
        }
      }

      console.log('Successful connection to API established');
      next(null);
    });
  }
})();
