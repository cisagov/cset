const {app, ipcMain, BrowserWindow, Menu} = require('electron')
const path = require('path')
const url = require('url')
const { execFile } = require('child_process')

let win

function createWindow () {
  // Create the browser window.
  win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: { nodeIntegration: true }
  })

  Menu.setApplicationMenu(null)

  // and load the index.html of the app.
  // win.loadURL(url.format({
  //   pathname: path.join(__dirname, 'dist/index.html'),
  //   protocol: 'file:',
  //   slashes: true
  // }))

  win.loadURL('http://localhost:4200/')

  // Open the DevTools.
  win.webContents.openDevTools()


  // Emitted when the window is closed.
  win.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    win = null
  })
}

app.on('ready', () => {
  // Launch CSET API
  apiDirPath = path.join(__dirname, '../CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore/bin/Debug/net5.0/')
  execFile(apiDirPath + 'CSETWebCore.Api.exe', { cwd: apiDirPath },
   (error, stderr) => {
    if (error) {
        console.error('stderr', stderr);
        throw error;
      }
  });
  createWindow()
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (win === null) {
    createWindow()
  }
})





