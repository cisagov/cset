////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
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
