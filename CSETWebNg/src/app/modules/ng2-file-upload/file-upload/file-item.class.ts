import { FileLikeObject } from './file-like-object.class';
import { FileUploader, ParsedResponseHeaders, FileUploaderOptions } from './file-uploader.class';

export class FileItem {
   file: FileLikeObject;
   _file: File;
   alias?: string;
   url = '/';
   method?: string;
   headers: any = [];
   withCredentials = true;
   formData: any = [];
   isReady = false;
   isUploading = false;
   isUploaded = false;
   isSuccess = false;
   isCancel = false;
   isError = false;
   progress = 0;
   index?: number;
   _xhr?: XMLHttpRequest;
   _form: any;

  protected uploader: FileUploader;
  protected some: File;
  protected options: FileUploaderOptions;

   constructor(uploader: FileUploader, some: File, options: FileUploaderOptions) {
    this.uploader = uploader;
    this.some = some;
    this.options = options;
    this.file = new FileLikeObject(some);
    this._file = some;
    if (uploader.options) {
      this.method = uploader.options.method || 'POST';
      this.alias = uploader.options.itemAlias || 'file';
    }
    this.url = uploader.options.url;
  }

   upload(): void {
    try {
      this.uploader.uploadItem(this);
    } catch (e) {
      this.uploader._onCompleteItem(this, '', 0, {});
      this.uploader._onErrorItem(this, '', 0, {});
    }
  }

   cancel(): void {
    this.uploader.cancelItem(this);
  }

   remove(): void {
    this.uploader.removeFromQueue(this);
  }

   onBeforeUpload(): void {
    return void 0;
  }

   onBuildForm(form: any): any {
    return { form };
  }

   onProgress(progress: number): any {
    return { progress };
  }

   onSuccess(response: string, status: number, headers: ParsedResponseHeaders): any {
    return { response, status, headers };
  }

   onError(response: string, status: number, headers: ParsedResponseHeaders): any {
    return { response, status, headers };
  }

   onCancel(response: string, status: number, headers: ParsedResponseHeaders): any {
    return { response, status, headers };
  }

   onComplete(response: string, status: number, headers: ParsedResponseHeaders): any {
    return { response, status, headers };
  }

   _onBeforeUpload(): void {
    this.isReady = true;
    this.isUploading = true;
    this.isUploaded = false;
    this.isSuccess = false;
    this.isCancel = false;
    this.isError = false;
    this.progress = 0;
    this.onBeforeUpload();
  }

   _onBuildForm(form: any): void {
    this.onBuildForm(form);
  }

   _onProgress(progress: number): void {
    this.progress = progress;
    this.onProgress(progress);
  }

   _onSuccess(response: string, status: number, headers: ParsedResponseHeaders): void {
    this.isReady = false;
    this.isUploading = false;
    this.isUploaded = true;
    this.isSuccess = true;
    this.isCancel = false;
    this.isError = false;
    this.progress = 100;
    this.index = undefined;
    this.onSuccess(response, status, headers);
  }

   _onError(response: string, status: number, headers: ParsedResponseHeaders): void {
    this.isReady = false;
    this.isUploading = false;
    this.isUploaded = true;
    this.isSuccess = false;
    this.isCancel = false;
    this.isError = true;
    this.progress = 0;
    this.index = undefined;
    this.onError(response, status, headers);
  }

   _onCancel(response: string, status: number, headers: ParsedResponseHeaders): void {
    this.isReady = false;
    this.isUploading = false;
    this.isUploaded = false;
    this.isSuccess = false;
    this.isCancel = true;
    this.isError = false;
    this.progress = 0;
    this.index = undefined;
    this.onCancel(response, status, headers);
  }

   _onComplete(response: string, status: number, headers: ParsedResponseHeaders): void {
    this.onComplete(response, status, headers);

    if (this.uploader.options.removeAfterUpload) {
      this.remove();
    }
  }

   _prepareToUploading(): void {
    this.index = this.index || ++this.uploader._nextIndex;
    this.isReady = true;
  }
}
