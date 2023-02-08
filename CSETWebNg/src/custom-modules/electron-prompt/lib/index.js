const path = require('path');

const DEFAULT_WIDTH = 370;
const DEFAULT_HEIGHT = 160;

const { BrowserWindow, ipcMain } = require('electron');

function electronPrompt(options, parentWindow) {
	return new Promise((resolve, reject) => {
		const id = `${Date.now()}-${Math.random()}`;

		const options_ = Object.assign(
			{
				width: DEFAULT_WIDTH,
				height: DEFAULT_HEIGHT,
				minWidth: DEFAULT_WIDTH,
				minHeight: DEFAULT_HEIGHT,
				resizable: false,
				title: 'Prompt',
				label: 'Please input a value:',
				buttonLabels: null,
				alwaysOnTop: false,
				value: null,
				type: 'input',
				selectOptions: null,
				icon: null,
				useHtmlLabel: false,
				customStylesheet: null,
				menuBarVisible: false,
				skipTaskbar: true,
			},
			options || {},
		);

		if (options_.type === 'select' && (options_.selectOptions === null || typeof options_.selectOptions !== 'object')) {
			reject(new Error('"selectOptions" must be an object'));
			return;
		}

    let startNewFind= true;

		let promptWindow = new BrowserWindow({
			width: options_.width,
			height: options_.height,
			minWidth: options_.minWidth,
			minHeight: options_.minHeight,
			resizable: options_.resizable,
			minimizable: false,
			fullscreenable: false,
			maximizable: false,
			parent: parentWindow,
			skipTaskbar: options_.skipTaskbar,
			alwaysOnTop: options_.alwaysOnTop,
			useContentSize: options_.resizable,
			modal: Boolean(parentWindow),
			title: options_.title,
			icon: options_.icon || undefined,
			webPreferences: {
				nodeIntegration: true,
				contextIsolation: false,
			},
		});

    parentWindow.webContents.on('found-in-page', (event, result) => {
      if (result.matches == 0) {
        parentWindow.webContents.send('text-search-event', result);
      }
    });

		promptWindow.setMenu(null);
		promptWindow.setMenuBarVisibility(options_.menuBarVisible);

		const getOptionsListener = event => {
			event.returnValue = JSON.stringify(options_);
		};

		const cleanup = () => {
			ipcMain.removeListener('prompt-get-options:' + id, getOptionsListener);
			ipcMain.removeListener('prompt-find:' + id, findListener);
			ipcMain.removeListener('prompt-cancel:' + id, cancelListener);
			ipcMain.removeListener('prompt-error:' + id, errorListener);

      parentWindow.webContents.stopFindInPage('clearSelection');

			if (promptWindow) {
				promptWindow.close();
				promptWindow = null;
			}
		};

		const cancelListener = (event, value) => {
			resolve(value);
			event.returnValue = null;
			cleanup();
		};

    const findListener = (event, value) => {
      parentWindow.webContents.once('found-in-page', (event, result) => {
        promptWindow?.webContents.send('found-in-page-results', result)
      })

      if (!!value) {
        parentWindow.webContents.findInPage(value, { findNext: startNewFind });
      }
      event.returnValue = value;
    };

		const unresponsiveListener = () => {
			reject(new Error('Window was unresponsive'));
			cleanup();
		};

		const errorListener = (event, message) => {
			reject(new Error(message));
			event.returnValue = null;
			cleanup();
		};

		ipcMain.on('prompt-get-options:' + id, getOptionsListener);
		ipcMain.on('prompt-find:' + id, findListener);
		ipcMain.on('prompt-cancel:' + id, cancelListener);
		ipcMain.on('prompt-error:' + id, errorListener);
		promptWindow.on('unresponsive', unresponsiveListener);

		promptWindow.on('closed', () => {
			promptWindow = null;
			cleanup();
			resolve(null);
		});

		promptWindow.loadFile(
			path.join(__dirname, 'page', 'prompt.html'),
			{hash: id},
		);
	});
}

module.exports = electronPrompt;
