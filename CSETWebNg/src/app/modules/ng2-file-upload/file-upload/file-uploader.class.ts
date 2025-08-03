import { EventEmitter } from '@angular/core';
import { FileLikeObject } from './file-like-object.class';
import { FileItem } from './file-item.class';
import { FileType } from './file-type.class';

function isFile(value: any): boolean {
  return (File && value instanceof File);
}

export interface Headers {
  name: string;
  value: string;
}

export interface ParsedResponseHeaders { [ headerFieldName: string ]: string }

export interface FilterFunction {
  name: string;
  fn(item: FileLikeObject, options?: FileUploaderOptions): boolean;
}

export interface FileUploaderOptions {
  allowedMimeType?: string[];
  allowedFileType?: string[];
  autoUpload?: boolean;
  isHTML5?: boolean;
  filters?: FilterFunction[];
  headers?: Headers[];
  method?: string;
  authToken?: string;
  maxFileSize?: number;
  queueLimit?: number;
  removeAfterUpload?: boolean;
  url: string;
  disableMultipart?: boolean;
  itemAlias?: string;
  authTokenHeader?: string;
  additionalParameter?: { [ key: string ]: any };
  parametersBeforeFiles?: boolean;
  // eslint-disable-next-line @typescript-eslint/ban-types
  formatDataFunction?: Function;
  formatDataFunctionIsAsync?: boolean;
}

export class FileUploader {

  authToken?: string;
  isUploading = false;
  queue: FileItem[] = [];
  progress = 0;
  _nextIndex = 0;
  autoUpload: any;
  authTokenHeader?: string;
  response: EventEmitter<any>;

  options: FileUploaderOptions = {
    autoUpload: false,
    isHTML5: true,
    filters: [],
    removeAfterUpload: false,
    disableMultipart: false,
    formatDataFunction: (item: FileItem) => item._file,
    formatDataFunctionIsAsync: false,
    url: ''
  };

  protected _failFilterIndex?: number;

  constructor(options: FileUploaderOptions) {
    this.setOptions(options);
    this.response = new EventEmitter<string>();
  }

  setOptions(options: FileUploaderOptions): void {
    this.options = Object.assign(this.options, options);

    this.authToken = this.options.authToken;
    this.authTokenHeader = this.options.authTokenHeader || 'Authorization';
    this.autoUpload = this.options.autoUpload;
    this.options.filters?.unshift({ name: 'queueLimit', fn: this._queueLimitFilter });

    if (this.options.maxFileSize) {
      this.options.filters?.unshift({ name: 'fileSize', fn: this._fileSizeFilter });
    }

    if (this.options.allowedFileType) {
      this.options.filters?.unshift({ name: 'fileType', fn: this._fileTypeFilter });
    }

    if (this.options.allowedMimeType) {
      this.options.filters?.unshift({ name: 'mimeType', fn: this._mimeTypeFilter });
    }

    for (let i = 0; i < this.queue.length; i++) {
      this.queue[ i ].url = this.options.url;
    }
  }

  addToQueue(files: File[], _options?: FileUploaderOptions, filters?: [] | string): void {
    let options = _options;
    const list: File[] = [];
    for (const file of files) {
      list.push(file);
    }
    const arrayOfFilters = this._getFilters(filters);
    const count = this.queue.length;
    const addedFileItems: FileItem[] = [];
    list.map((some: File) => {
      if (!options) {
        options = this.options;
      }

      const temp = new FileLikeObject(some);
      if (this._isValidFile(temp, arrayOfFilters, options)) {
        const fileItem = new FileItem(this, some, options);
        addedFileItems.push(fileItem);
        this.queue.push(fileItem);
        this._onAfterAddingFile(fileItem);
      } else {
        if (typeof this._failFilterIndex === 'number' && this._failFilterIndex >= 0) {
          const filter = arrayOfFilters[ this._failFilterIndex ];
          this._onWhenAddingFileFailed(temp, filter, options);
        }
      }
    });
    if (this.queue.length !== count) {
      this._onAfterAddingAll(addedFileItems);
      this.progress = this._getTotalProgress();
    }
    this._render();
    if (this.options.autoUpload) {
      this.uploadAll();
    }
  }

  removeFromQueue(value: FileItem): void {
    const index = this.getIndexOfItem(value);
    const item = this.queue[ index ];
    if (item.isUploading) {
      item.cancel();
    }
    this.queue.splice(index, 1);
    this.progress = this._getTotalProgress();
  }

  clearQueue(): void {
    while (this.queue.length) {
      this.queue[ 0 ].remove();
    }
    this.progress = 0;
  }

  uploadItem(value: FileItem): void {
    const index = this.getIndexOfItem(value);
    const item = this.queue[ index ];
    const transport = this.options.isHTML5 ? '_xhrTransport' : '_iframeTransport';
    item._prepareToUploading();
    if (this.isUploading) {
      return;
    }
    this.isUploading = true;
    (this as any)[ transport ](item);
  }

  cancelItem(value: FileItem): void {
    const index = this.getIndexOfItem(value);
    const item = this.queue[ index ];
    const prop = this.options.isHTML5 ? item._xhr : item._form;
    if (item && item.isUploading) {
      prop.abort();
    }
  }

  uploadAll(): void {
    const items = this.getNotUploadedItems().filter((item: FileItem) => !item.isUploading);
    if (!items.length) {
      return;
    }
    items.map((item: FileItem) => item._prepareToUploading());
    items[ 0 ].upload();
  }

  cancelAll(): void {
    const items = this.getNotUploadedItems();
    items.map((item: FileItem) => item.cancel());
  }

  isFile(value: any): boolean {
    return isFile(value);
  }

  isFileLikeObject(value: any): boolean {
    return value instanceof FileLikeObject;
  }

  getIndexOfItem(value: any): number {
    return typeof value === 'number' ? value : this.queue.indexOf(value);
  }

  getNotUploadedItems(): any[] {
    return this.queue.filter((item: FileItem) => !item.isUploaded);
  }

  getReadyItems(): any[] {
    return this.queue
      .filter((item: FileItem) => (item.isReady && !item.isUploading))
      .sort((item1: any, item2: any) => item1.index - item2.index);
  }

  onAfterAddingAll(fileItems: any): any {
    return { fileItems };
  }

  onBuildItemForm(fileItem: FileItem, form: any): any {
    return { fileItem, form };
  }

  onAfterAddingFile(fileItem: FileItem): any {
    return { fileItem };
  }

  onWhenAddingFileFailed(item: FileLikeObject, filter: any, options: any): any {
    return { item, filter, options };
  }

  onBeforeUploadItem(fileItem: FileItem): any {
    return { fileItem };
  }

  onProgressItem(fileItem: FileItem, progress: any): any {
    return { fileItem, progress };
  }

  onProgressAll(progress: any): any {
    return { progress };
  }

  onSuccessItem(item: FileItem, response: string, status: number, headers: ParsedResponseHeaders): any {
    return { item, response, status, headers };
  }

  onErrorItem(item: FileItem, response: string, status: number, headers: ParsedResponseHeaders): any {
    return { item, response, status, headers };
  }

  onCancelItem(item: FileItem, response: string, status: number, headers: ParsedResponseHeaders): any {
    return { item, response, status, headers };
  }

  onCompleteItem(item: FileItem, response: string, status: number, headers: ParsedResponseHeaders): any {
    return { item, response, status, headers };
  }

  onCompleteAll(): any {
    return void 0;
  }

  _mimeTypeFilter(item: FileLikeObject): boolean {
    return !(item?.type && this.options.allowedMimeType && this.options.allowedMimeType?.indexOf(item.type) === -1);
  }

  _fileSizeFilter(item: FileLikeObject): boolean {
    return !(this.options.maxFileSize && item.size > this.options.maxFileSize);
  }

  _fileTypeFilter(item: FileLikeObject): boolean {
    return !(this.options.allowedFileType &&
      this.options.allowedFileType.indexOf(FileType.getMimeClass(item)) === -1);
  }

  _onErrorItem(item: FileItem, response: string, status: number, headers: ParsedResponseHeaders): void {
    item._onError(response, status, headers);
    this.onErrorItem(item, response, status, headers);
  }

  _onCompleteItem(item: FileItem, response: string, status: number, headers: ParsedResponseHeaders): void {
    item._onComplete(response, status, headers);
    this.onCompleteItem(item, response, status, headers);
    const nextItem = this.getReadyItems()[ 0 ];
    this.isUploading = false;
    if (nextItem) {
      nextItem.upload();

      return;
    }
    this.onCompleteAll();
    this.progress = this._getTotalProgress();
    this._render();
  }

  protected _headersGetter(parsedHeaders: ParsedResponseHeaders): any {
    return (name: any): any => {
      if (name) {
        return parsedHeaders[ name.toLowerCase() ] || undefined;
      }

      return parsedHeaders;
    };
  }

  protected _xhrTransport(item: FileItem): any {
    // tslint:disable-next-line:no-this-assignment
    // eslint-disable-next-line @typescript-eslint/no-this-alias
    const that = this;
    const xhr = item._xhr = new XMLHttpRequest();
    let sendable: any;
    this._onBeforeUploadItem(item);

    if (typeof item._file.size !== 'number') {
      throw new TypeError('The file specified is no longer valid');
    }
    if (!this.options.disableMultipart) {
      sendable = new FormData();
      this._onBuildItemForm(item, sendable);
      const appendFile = () => sendable.append(item.alias, item._file, item.file.name);
      if (!this.options.parametersBeforeFiles) {
        appendFile();
      }

      // For AWS, Additional Parameters must come BEFORE Files
      if (this.options.additionalParameter !== undefined) {
        Object.keys(this.options.additionalParameter).forEach((key: string) => {
          let paramVal = this.options.additionalParameter?.[ key ];
          // Allow an additional parameter to include the filename
          if (typeof paramVal === 'string' && paramVal.indexOf('{{file_name}}') >= 0 && item.file?.name) {
            paramVal = paramVal.replace('{{file_name}}', item.file.name);
          }
          sendable.append(key, paramVal);
        });
      }

      if (appendFile && this.options.parametersBeforeFiles) {
        appendFile();
      }
    } else {
      if (this.options.formatDataFunction) {
        sendable = this.options.formatDataFunction(item);
      }
    }

    xhr.upload.onprogress = (event: any) => {
      const progress = Math.round(event.lengthComputable ? event.loaded * 100 / event.total : 0);
      this._onProgressItem(item, progress);
    };
    xhr.onload = () => {
      const headers = this._parseHeaders(xhr.getAllResponseHeaders());
      const response = this._transformResponse(xhr.response);
      const gist = this._isSuccessCode(xhr.status) ? 'Success' : 'Error';
      const method = `_on${gist}Item`;
      (this as any)[ method ](item, response, xhr.status, headers);
      this._onCompleteItem(item, response, xhr.status, headers);
    };
    xhr.onerror = () => {
      const headers = this._parseHeaders(xhr.getAllResponseHeaders());
      const response = this._transformResponse(xhr.response);
      this._onErrorItem(item, response, xhr.status, headers);
      this._onCompleteItem(item, response, xhr.status, headers);
    };
    xhr.onabort = () => {
      const headers = this._parseHeaders(xhr.getAllResponseHeaders());
      const response = this._transformResponse(xhr.response);
      this._onCancelItem(item, response, xhr.status, headers);
      this._onCompleteItem(item, response, xhr.status, headers);
    };
    if (item.method && item.url) {
      xhr.open(item.method, item.url, true);
    }
    xhr.withCredentials = item.withCredentials;
    if (this.options.headers) {
      for (const header of this.options.headers) {
        xhr.setRequestHeader(header.name, header.value);
      }
    }
    if (item.headers.length) {
      for (const header of item.headers) {
        xhr.setRequestHeader(header.name, header.value);
      }
    }
    if (this.authToken && this.authTokenHeader) {
      xhr.setRequestHeader(this.authTokenHeader, this.authToken);
    }
    xhr.onreadystatechange = function () {
      if (xhr.readyState == XMLHttpRequest.DONE) {
        that.response.emit(xhr.responseText);
      }
    };
    if (this.options.formatDataFunctionIsAsync) {
      sendable.then(
        (result: any) => xhr.send(JSON.stringify(result))
      );
    } else {
      xhr.send(sendable);
    }
    this._render();
  }

  protected _getTotalProgress(value = 0): number {
    if (this.options.removeAfterUpload) {
      return value;
    }
    const notUploaded = this.getNotUploadedItems().length;
    const uploaded = notUploaded ? this.queue.length - notUploaded : this.queue.length;
    const ratio = 100 / this.queue.length;
    const current = value * ratio / 100;
    return Math.round(uploaded * ratio + current);
  }

  protected _getFilters(filters?: FilterFunction[] | string): FilterFunction[] | [] {
    if (!filters) {
      return this.options?.filters || [];
    }
    if (Array.isArray(filters)) {
      return filters;
    }
    if (typeof filters === 'string') {
      const names = filters.match(/[^\s,]+/g);

      return this.options?.filters || []
        .filter((filter: any) => names?.indexOf(filter.name) !== -1);
    }

    return this.options?.filters || [];
  }

  protected _render(): any {
    return void 0;
  }

  protected _queueLimitFilter(): boolean {
    return this.options.queueLimit === undefined || this.queue.length < this.options.queueLimit;
  }

  protected _isValidFile(file: FileLikeObject, filters: FilterFunction[], options: FileUploaderOptions): boolean {
    this._failFilterIndex = -1;

    return !filters.length ? true : filters.every((filter: FilterFunction) => {
      if (typeof this._failFilterIndex === 'number') {
        this._failFilterIndex++;
      }

      return filter.fn.call(this, file, options);
    });
  }

  protected _isSuccessCode(status: number): boolean {
    return (status >= 200 && status < 300) || status === 304;
  }

  protected _transformResponse(response: string): string {
    return response;
  }

  protected _parseHeaders(headers: string): ParsedResponseHeaders {
    const parsed: any = {};
    let key: any;
    let val: any;
    let i: any;
    if (!headers) {
      return parsed;
    }
    headers.split('\n').map((line: any) => {
      i = line.indexOf(':');
      key = line.slice(0, i).trim().toLowerCase();
      val = line.slice(i + 1).trim();
      if (key) {
        parsed[ key ] = parsed[ key ] ? parsed[ key ] + ', ' + val : val;
      }
    });

    return parsed;
  }

  protected _onWhenAddingFileFailed(item: FileLikeObject, filter: any, options: any): void {
    this.onWhenAddingFileFailed(item, filter, options);
  }

  protected _onAfterAddingFile(item: FileItem): void {
    this.onAfterAddingFile(item);
  }

  protected _onAfterAddingAll(items: any): void {
    this.onAfterAddingAll(items);
  }

  protected _onBeforeUploadItem(item: FileItem): void {
    item._onBeforeUpload();
    this.onBeforeUploadItem(item);
  }

  protected _onBuildItemForm(item: FileItem, form: any): void {
    item._onBuildForm(form);
    this.onBuildItemForm(item, form);
  }

  protected _onProgressItem(item: FileItem, progress: any): void {
    const total = this._getTotalProgress(progress);
    this.progress = total;
    item._onProgress(progress);
    this.onProgressItem(item, progress);
    this.onProgressAll(total);
    this._render();
  }

  protected _onSuccessItem(item: FileItem, response: string, status: number, headers: ParsedResponseHeaders): void {
    item._onSuccess(response, status, headers);
    this.onSuccessItem(item, response, status, headers);
  }

  protected _onCancelItem(item: FileItem, response: string, status: number, headers: ParsedResponseHeaders): void {
    item._onCancel(response, status, headers);
    this.onCancelItem(item, response, status, headers);
  }
}
