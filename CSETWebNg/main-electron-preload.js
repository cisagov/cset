const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronApi', {
  printToPdf: () => {
    ipcRenderer.send('print-to-pdf');
  },
  returnFromDiagram: (returnPath) => {
    return ipcRenderer.invoke('return-from-diagram', { returnPath });
  }
});
