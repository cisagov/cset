const { app, BrowserWindow, Menu } = require('electron');
const path = require('path');
const url = require('url');
const child = require('child_process').execFile;

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

function createWindow() {
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

  // and load the index.html of the app.
  // paths to some assets still need fixed
  mainWindow.loadURL(
    url.format({
      pathname: path.join(__dirname, 'dist/index.html'),
      protocol: "file:",
      slashes: true
    })
  );

  // Emitted when the window is closed.
  mainWindow.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });
}

function LaunchAPI(exeDir, fileName) {;
  let exe = exeDir + "/" + fileName;
  let options = {cwd:exeDir};
  child(exe, options, (error, data) => {
    console.log(error);
    console.log(data.toString());
  })
}

app.on('ready', () => {
  if (mainWindow === null) {
    // LaunchAPI("C:/src/Repos/cset/CSETWebApi/CSETWeb_Api/CSETWebCore.Reports/bin/Release/net5.0", "CSETWebCore.Reports.exe");
    // need a pause here
    LaunchAPI("C:/src/Repos/cset/CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/bin/Release/net5.0", "CSETWebCore.Api.exe");
    createWindow();
  }
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
