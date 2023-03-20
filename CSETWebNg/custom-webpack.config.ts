import MonacoEditorWebpackPlugin from 'monaco-editor-webpack-plugin';
import * as webpack from 'webpack';

export default (config: webpack.Configuration) => {
  config?.plugins?.push(new MonacoEditorWebpackPlugin());
  return config;
};
