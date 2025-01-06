const { app, BrowserWindow, Menu, MenuItem, shell, session, dialog } = require('electron');
const path = require('path');
const fs = require('fs');
const url = require('url');
const child = require('child_process').execFile;
const http = require('http');
const log = require('electron-log');
const net = require('net');
const util = require('util');
const findTextPrompt = require('electron-find-on-page');
const gotTheLock = app.requestSingleInstanceLock();
const merge = require('lodash').merge;

let config = require('./dist/assets/settings/config.json');

/**
 * Load each config in the currentConfigChain and merge with previous configs.
 * In the case of a key collisions, the right-most (last) object's value wins out.
 */
config.currentConfigChain.forEach((configProfile) => {
  const subConfig = require(`./dist/assets/settings/config.${configProfile}.json`);
  merge(config, subConfig);
});

const installationMode = config.installationMode;
const clientCode = config.behaviors.clientCode;
const appName = config.behaviors.defaultTitle;

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
    title: appName
  });

  // Default Electron application menu is immutable; have to create new one and modify from there
  let defaultMenu = Menu.getApplicationMenu();
  let newMenu = new Menu();

  // Setup Electron application menu (remove empty help tab and add print option)
  defaultMenu.items
    .filter((x) => x.role != 'help')
    .forEach((x) => {
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

        // Add Save as PDF option (we only want to save the focused window as PDF)
        newSubmenu.append(
          new MenuItem({
            type: 'normal',
            label: 'Save as PDF',
            accelerator: 'Ctrl+S',
            click: () => {
              BrowserWindow.getFocusedWindow()
                .webContents.printToPDF({ pageSize: 'Letter' })
                .then((data) => {
                  const saveDialogOptions = {
                    title: `${appName} - Save as PDF`,
                    filters: [
                      {
                        name: 'PDF',
                        extensions: ['pdf']
                      }
                    ],
                    defaultPath: app.getPath('downloads')
                  };

                  let filepath = dialog.showSaveDialogSync(saveDialogOptions);

                  if (filepath) {
                    fs.writeFile(filepath, data, (error) => {
                      if (error) {
                        log.error(error);
                      }
                    });
                  }
                })
                .catch((error) => {
                  log.error(error);
                });
            }
          })
        );

        x.submenu.items.forEach((y) => newSubmenu.append(y));
        x.submenu = newSubmenu;

        newMenu.append(
          new MenuItem({
            role: x.role,
            type: x.type,
            label: x.label,
            submenu: newSubmenu
          })
        );
      } else if (x.role === 'windowmenu') {
        let newSubmenu = new Menu();

        // Remove unnecessary Zoom button from window tab
        x.submenu.items.filter((y) => y.label != 'Zoom').forEach((z) => newSubmenu.append(z));
        x.submenu = newSubmenu;

        newMenu.append(
          new MenuItem({
            role: x.role,
            type: x.type,
            label: x.label,
            submenu: newSubmenu
          })
        );
      } else if (x.role === 'viewmenu') {
        let newSubmenu = new Menu();

        // Remove unnecessary Zoom button from window tab
        x.submenu.items.forEach((y) => {
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
            let currentWindow = BrowserWindow.getFocusedWindow();
            findTextPrompt(
              {
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
              },
              currentWindow
            )
              .then((r) => {
                if (r === null) {
                  // text search is done here
                }
              })
              .catch((e) => {
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
            submenu: newSubmenu
          })
        );
      } else {
        newMenu.append(x);
      }
    });

  Menu.setApplicationMenu(newMenu);

  mainWindow.loadFile(path.join(__dirname, config.behaviors.splashPageHTML));
  let rootDir = path.dirname(app.getPath('exe'));

  log.info('Root Directory of ' + appName + ' Electron app: ' + rootDir);

  if (app.isPackaged) {
    // Check angular config file for initial API port and increment port automatically if designated port is already taken
    let apiPort = parseInt(config.api.port);
    let apiUrl = config.api.host;
    assignPort(apiPort, null, apiUrl)
      .then((assignedApiPort) => {
        log.info('API launching on port', assignedApiPort);
        launchAPI(rootDir + '/Website', 'CSETWebCore.Api.exe', assignedApiPort, mainWindow);
        return assignedApiPort;
      })
      .then((assignedApiPort) => {
        // Keep attempting to connect to API, every 2 seconds, then load application
        retryApiConnection(240, 2000, assignedApiPort, (error) => {
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
                  apiUrl: config.api.protocol + '://' + config.api.host + ':' + assignedApiPort,
                  libraryUrl: config.api.protocol + '://' + config.api.host + ':' + assignedApiPort
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
          apiUrl: config.api.protocol + '://' + config.api.host + ':' + config.api.port,
          libraryUrl: config.api.protocol + '://' + config.api.host + ':' + config.api.port
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
  mainWindow.webContents.setWindowOpenHandler((details) => {
    // trying to load url in form of index.html?returnPath=report/
    if (details.url.includes('index.html?returnPath=report')) {
      let childWindow = new BrowserWindow({
        parent: mainWindow,
        width: 1000,
        height: 800,
        webPreferences: { nodeIntegration: true },
        icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
        title: details.frameName.includes('web-ng') || details.frameName === '_blank' ? `${appName}` : details.frameName
      });

      const newPath = details.url.substring(details.url.indexOf('index.html'));
      const newUrl = 'file:///' + __dirname + '/dist/' + newPath;

      log.info('Navigated to ' + newUrl);
      childWindow.loadURL(newUrl);

      // Setup external links in child windows
      childWindow.webContents.setWindowOpenHandler((details) => {
        if (!details.url.startsWith('file:///') && !details.url.startsWith('http://localhost')) {
          shell.openExternal(details.url);
          return { action: 'deny' };
        }
      });

      return { action: 'deny' };

      // navigating to help section; prevent additional popup windows
    } else if (details.url.includes('htmlhelp')) {
      let childWindow = new BrowserWindow({
        parent: mainWindow,
        webPreferences: { nodeIntegration: true },
        icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
        title: details.frameName.includes('web-ng') || details.frameName === '_blank' ? `${appName}` : details.frameName
      });

      childWindow.loadURL(details.url);

      // Setup external links in child windows
      childWindow.webContents.setWindowOpenHandler((details) => {
        if (!details.url.startsWith('file:///') && !details.url.startsWith('http://localhost')) {
          shell.openExternal(details.url);
          return { action: 'deny' };
        } else {
          childWindow.loadURL(newUrl);
          return { action: 'deny' ,
            overrideBrowserWindowOptions: {
              title: details.frameName.includes('web-ng') || details.frameName === '_blank' ? `${appName}` : details.frameName
            }
          };
        }
      });

      return { action: 'deny' };

      // Navigating to external url if not using file protocol or localhost; open in web browser
    } else if (!details.url.startsWith('file:///') && !details.url.startsWith('http://localhost')) {
      shell.openExternal(details.url);
      return { action: 'deny' };
    }

    return {
      action: 'allow',
      overrideBrowserWindowOptions: {
        parent: mainWindow,
        icon: path.join(__dirname, 'dist/favicon_' + installationMode.toLowerCase() + '.ico'),
        title: details.frameName.includes('web-ng') || details.frameName === '_blank' ? `${appName}` : details.frameName
      }
    };
  });

  mainWindow.webContents.on('did-create-window', (childWindow) => {
    // Child windows that fail to load url are closed
    childWindow.webContents.on('did-fail-load', (event, errorCode, errorDescription) => {
      log.error(errorDescription);
      childWindow.close();
    });
  });

  // Load landing page if any window in app fails to load
  mainWindow.webContents.on('did-fail-load', (event) => {
    // This event is triggered inside diagram even when the page loads successfully.
    // Not sure why... so we're ignoring it for now.
    if (event.sender?.getURL().includes('diagram/src/main/webapp/index.html')) {
      return;
    }

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
      mainWindow.webContents.debugger
        .sendCommand('Network.getResponseBody', { requestId: params.requestId })
        .then((body) => {
          if (params.response.url.toString().substring(0, 4) != 'file') {
            log.info(
              'REQUEST AT:',
              params.response.url,
              'RETURNED STATUS CODE',
              params.response.status,
              '\nRESPONSE BODY:',
              body
            );
          }
        })
        .catch(() => {
          // Errors here being caused by traffic before api connection is established, so they are irrelevant
        });
    }
  });

  mainWindow.webContents.debugger.sendCommand('Network.enable');
}

// log all node process uncaught exceptions
process.on('uncaughtException', (error) => {
  log.error(error);
  app.quit();
});

app.on('ready', () => {
  // set log to output to local appdata folder

  log.transports.file.resolvePathFn = () =>
    path.join(app.getPath('home'), `AppData/Local/${clientCode}/ACET/ACET_electron.log`);
  log.errorHandler.startCatching();

  if (mainWindow === null) {
    try {
      createWindow();
    } catch {
      app.quit();
    }
  }
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    log.info(appName + ' has been shut down');
    app.quit();
  }
});

function launchAPI(exeDir, fileName, port, window) {
  let exe = exeDir + '/' + fileName;
  let options = { cwd: exeDir };
  let args = ['--urls', config.api.protocol + '://' + config.api.host + ':' + port];
  let apiProcess = child(exe, args, options, (error) => {
    if (error) {
      window.loadFile(path.join(__dirname, '/dist/assets/app-startup-error.html'));
      log.error(error);
      if (error.stack.includes('DatabaseManager.DatabaseSetupException')) {
        dialog.showErrorBox(
          `${appName} Database Setup Error`,
          `There was a problem initializing the SQL LocalDB ${appName} database. Please restart your system and try again.\n\n` +
            error.message
        );
      }
    }
  });

  apiProcess.stdout.on('data', (data) => {
    if (data.includes('uninstall previous versions')) {
      const options = {
        type: 'info',
        title: 'Notice',
        message: data
      };

      dialog.showMessageBox(options);
    }
  });
}

// Increment port number until a non listening port is found
function assignPort(port, offLimitPort, host) {
  return checkPort(port, host).then(
    (status) => {
      if (status === true || port === offLimitPort) {
        log.info('Port', port, 'on', host, 'is already in use. Incrementing port...');
        return assignPort(port + 1, offLimitPort, host);
      } else {
        return port;
      }
    },
    (error) => {
      log.error(error);
    }
  );
}

/**
 * Checks if a TCP port is in use by creating the socket and binding it to the
 * target port. Once bound, successfully, it's assume the port is available.
 * After the socket is closed or in error, the promise is resolved.
 * Note: you have to be super user to correctly test system ports (0-1023).
 * @param {Number|Object} port The port you are curious to see if available. If an object, must have the parameters as properties.
 * @param {String} [host] May be a DNS name or IP address. Default '127.0.0.1'
 * @return {Object} A deferred Q promise.
 **/
function checkPort(port, host) {
  function getDeferred() {
    var resolve,
      reject,
      promise = new Promise(function (res, rej) {
        resolve = res;
        reject = rej;
      });

    return {
      resolve: resolve,
      reject: reject,
      promise: promise
    };
  }

  /**
   * Creates an options object from all the possible arguments
   * @private
   * @param {Number} port a valid TCP port number
   * @param {String} host The DNS name or IP address.
   * @param {Boolean} status The desired in use status to wait for: false === not in use, true === in use
   * @param {Number} retryTimeMs the retry interval in milliseconds - defaultis is 200ms
   * @param {Number} timeOutMs the amount of time to wait until port is free default is 1000ms
   * @return {Object} An options object with all the above parameters as properties.
   */
  function makeOptionsObj(port, host, inUse, retryTimeMs, timeOutMs) {
    var opts = {};
    opts.port = port;
    opts.host = host;
    opts.inUse = inUse;
    opts.retryTimeMs = retryTimeMs;
    opts.timeOutMs = timeOutMs;
    return opts;
  }

  var deferred = getDeferred();
  var inUse = true;
  var client;

  var opts;
  if (typeof opts !== 'object') {
    opts = makeOptionsObj(port, host);
  } else {
    opts = port;
  }

  // check is port is valid
  if (typeof opts.port !== 'number' || isNaN(opts.port) || opts.port < 0 || opts.port > 65535) {
    deferred.reject(new Error('invalid port: ' + util.inspect(opts.port)));
    return deferred.promise;
  }

  // check for host
  if (opts.host == null) {
    opts.host = '127.0.0.1';
  }

  function cleanUp() {
    if (client) {
      client.removeAllListeners('connect');
      client.removeAllListeners('error');
      client.end();
      client.destroy();
      client.unref();
    }
  }

  function onConnectCb() {
    deferred.resolve(inUse);
    cleanUp();
  }

  function onErrorCb(err) {
    if (err.code !== 'ECONNREFUSED') {
      deferred.reject(err);
    } else {
      inUse = false;
      deferred.resolve(inUse);
    }
    cleanUp();
  }

  client = new net.Socket();
  client.once('connect', onConnectCb);
  client.once('error', onErrorCb);
  client.connect({ port: opts.port, host: opts.host }, function () {});

  return deferred.promise;
}

let retryApiConnection = (() => {
  let count = 0;

  return (max, timeout, port, next) => {
    function checkMaxCountAndRecurse(maxTries, timeoutBetweenRequests, destPort, callback) {
      if (count++ < max - 1) {
        return setTimeout(() => {
          retryApiConnection(maxTries, timeoutBetweenRequests, destPort, callback);
        }, timeout);
      } else {
        return next(new Error('Max API connection retries reached'));
      }
    }

    let req = http.get(
      config.api.protocol + '://' + config.api.host + ':' + port + '/api/IsRunning',
      {
        timeout: 2000
      },
      (response) => {
        if (response.statusCode !== 200) {
          return checkMaxCountAndRecurse(max, timeout, port, next);
        }

        log.info('Successful connection to API established. Loading ' + appName + ' main window...');
        next(null);
      }
    );

    req.on('error', (error) => {
      return checkMaxCountAndRecurse(max, timeout, port, next);
    });
  };
})();
