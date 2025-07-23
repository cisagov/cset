import { Directive, EventEmitter, ElementRef, HostListener, Input, Output } from '@angular/core';

import { FileUploader, FileUploaderOptions } from './file-uploader.class';

@Directive({ selector: '[ng2FileDrop]', standalone: false })
export class FileDropDirective {
  @Input()  uploader?: FileUploader;
  @Output()  fileOver: EventEmitter<any> = new EventEmitter();
  // eslint-disable-next-line @angular-eslint/no-output-on-prefix
  @Output()  onFileDrop: EventEmitter<File[]> = new EventEmitter<File[]>();

  protected element: ElementRef;

  constructor(element: ElementRef) {
    this.element = element;
  }

  getOptions(): FileUploaderOptions | void {
    return this.uploader?.options;
  }

  getFilters(): string {
    return '';
  }

  @HostListener('drop', [ '$event' ])
  onDrop(event: MouseEvent): void {
    const transfer = this._getTransfer(event);
    if (!transfer) {
      return;
    }

    const options = this.getOptions();
    const filters = this.getFilters();
    this._preventAndStop(event);
    if (options) {
      this.uploader?.addToQueue(transfer.files, options, filters);
    }
    this.fileOver.emit(false);
    this.onFileDrop.emit(transfer.files);
  }

  @HostListener('dragover', [ '$event' ])
  onDragOver(event: MouseEvent): void {
    const transfer = this._getTransfer(event);
    if (!this._haveFiles(transfer.types)) {
      return;
    }

    transfer.dropEffect = 'copy';
    this._preventAndStop(event);
    this.fileOver.emit(true);
  }

  @HostListener('dragleave', [ '$event' ])
  onDragLeave(event: MouseEvent): void {
    if ((this as any).element) {
      if (event.currentTarget === (this as any).element[ 0 ]) {
        return;
      }
    }

    this._preventAndStop(event);
    this.fileOver.emit(false);
  }

  protected _getTransfer(event: any): any {
    return event.dataTransfer ? event.dataTransfer : event.originalEvent.dataTransfer; // jQuery fix;
  }

  protected _preventAndStop(event: MouseEvent): void {
    event.preventDefault();
    event.stopPropagation();
  }

  protected _haveFiles(types: any): boolean {
    if (!types) {
      return false;
    }

    if (types.indexOf) {
      return types.indexOf('Files') !== -1;
    } else if (types.contains) {
      return types.contains('Files');
    } else {
      return false;
    }
  }
}
