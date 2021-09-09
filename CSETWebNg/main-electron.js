const { app, BrowserWindow, Menu } = require('electron');
const path = require('path');
const url = require('url');

let mainWindow = null;

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
  if (process.env.NODE_ENV == 'production') {
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

app.on('ready', () => {
  if (mainWindow === null) {
    createWindow();
  }
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
