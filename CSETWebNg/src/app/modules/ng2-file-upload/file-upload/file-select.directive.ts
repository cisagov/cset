import { Directive, EventEmitter, ElementRef, Input, HostListener, Output } from '@angular/core';

import { FileUploader, FileUploaderOptions } from './file-uploader.class';

@Directive({ selector: '[ng2FileSelect]', standalone: false })
export class FileSelectDirective {
  @Input() uploader?: FileUploader;
  // eslint-disable-next-line @angular-eslint/no-output-on-prefix
  @Output() onFileSelected: EventEmitter<File[]> = new EventEmitter<File[]>();

  protected element: ElementRef;

  constructor(element: ElementRef) {
    this.element = element;
  }

  getOptions(): FileUploaderOptions | undefined {
    return this.uploader?.options;
  }

  getFilters(): string {
    return '';
  }

  isEmptyAfterSelection(): boolean {
    return !!this.element.nativeElement.attributes.multiple;
  }

  @HostListener('change')
  onChange(): void {
    const files = this.element.nativeElement.files;
    const options = this.getOptions();
    const filters = this.getFilters();
    this.uploader?.addToQueue(files, options, filters);

    this.onFileSelected.emit(files);
    if (this.isEmptyAfterSelection()) {
      this.element.nativeElement.value = '';
    }
  }
}
