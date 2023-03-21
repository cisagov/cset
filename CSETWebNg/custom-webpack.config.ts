import MonacoEditorWebpackPlugin from 'monaco-editor-webpack-plugin';
import * as webpack from 'webpack';

export default (config: webpack.Configuration) => {
  config?.plugins?.push(new MonacoEditorWebpackPlugin({
  // we can disable features that we end up not needing/using
  features: [
    'accessibilityHelp',
    'format',
    '!anchorSelect',
    '!bracketMatching',
    '!browser',
    '!caretOperations',
    '!clipboard',
    '!codeAction',
    '!codelens',
    '!colorPicker',
    '!comment',
    '!contextmenu',
    '!copyPaste',
    '!cursorUndo',
    '!dnd',
    '!documentSymbols',
    '!dropIntoEditor',
    '!find',
    '!folding',
    '!fontZoom',
    '!gotoError',
    '!gotoLine',
    '!gotoSymbol',
    '!hover',
    '!iPadShowKeyboard',
    '!inPlaceReplace',
    '!indentation',
    '!inlayHints',
    '!inlineCompletions',
    '!inspectTokens',
    '!lineSelection',
    '!linesOperations',
    '!linkedEditing',
    '!links',
    '!multicursor',
    '!parameterHints',
    '!quickCommand',
    '!quickHelp',
    '!quickOutline',
    '!readOnlyMessage',
    '!referenceSearch',
    '!rename',
    '!smartSelect',
    '!snippet',
    '!stickyScroll',
    '!suggest',
    '!toggleHighContrast',
    '!toggleTabFocusMode',
    '!tokenization',
    '!unicodeHighlighter',
    '!unusualLineTerminators'
  ],
  globalAPI: true
}));
  return config;
};
