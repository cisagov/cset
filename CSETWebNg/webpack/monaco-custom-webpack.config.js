const path = require('path');
const MONACO_DIR = path.join(__dirname, "../node_modules/monaco-editor");

module.exports = {
	entry: {
		app: './webpack/monaco-webpack-entry.js',
		// Package each language's worker and give these filenames in `getWorkerUrl`
		'editor.worker': 'monaco-editor/esm/vs/editor/editor.worker.js',
		'json.worker': 'monaco-editor/esm/vs/language/json/json.worker',
		'css.worker': 'monaco-editor/esm/vs/language/css/css.worker',
		'html.worker': 'monaco-editor/esm/vs/language/html/html.worker',
		'ts.worker': 'monaco-editor/esm/vs/language/typescript/ts.worker'
	},
	output: {
		globalObject: 'self',
		filename: '[name].bundle.js',
		path: path.resolve(__dirname, '../dist')
	},
	module: {
		rules: [
			{
				test: /\.css$/,
        include: MONACO_DIR,
				use: ['style-loader', 'css-loader']
			},
			{
				test: /\.ttf$/,
        include: MONACO_DIR,
				use: ['file-loader']
			}
		]
	}
};
