const path = require('path');
const electron = require('electron');

const DEFAULT_WIDTH = 370;
const DEFAULT_HEIGHT = 160;

function getElectronMainExport(id) {
	if (electron[id]) {
		return electron[id];
	}

	let remote = electron.remote;
	if (!remote) {
		try {
			remote = require('@electron/remote');
		} catch (originalError) {
			const error = new Error(
				'Install and set-up package `@electron/remote` to use this module from a renderer processs.\n'
				+ 'It is preferable to set up message exchanges for this using `ipcMain.handle()` and `ipcRenderer.invoke()`,\n'
				+ 'avoiding remote IPC overhead costs, and one morepackage dependancy.\n\n'
				+ 'Original error message:\n\n'
				+ originalError.message,
			);

			error.originalError = originalError;
			throw error;
		}
	}

	if (remote && remote[id]) {
		return remote[id];
	}

	throw new Error('Unknown electron export: ' + String(id));
}

const BrowserWindow = getElectronMainExport('BrowserWindow');
const ipcMain = getElectronMainExport('ipcMain');

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

		promptWindow.setMenu(null);
		promptWindow.setMenuBarVisibility(options_.menuBarVisible);

		const getOptionsListener = event => {
			event.returnValue = JSON.stringify(options_);
		};

		const cleanup = () => {
			ipcMain.removeListener('prompt-get-options:' + id, getOptionsListener);
			ipcMain.removeListener('prompt-post-data:' + id, postDataListener);
			ipcMain.removeListener('prompt-error:' + id, errorListener);

			if (promptWindow) {
				promptWindow.close();
				promptWindow = null;
			}
		};

		const postDataListener = (event, value) => {
			resolve(value);
			event.returnValue = null;
			cleanup();
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
		ipcMain.on('prompt-post-data:' + id, postDataListener);
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
