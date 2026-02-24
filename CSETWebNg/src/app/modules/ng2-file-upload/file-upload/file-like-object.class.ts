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
export class FileLikeObject {
  lastModifiedDate: any;
  size: any;
  type?: string;
  name?: string;
  rawFile: HTMLInputElement | File;

  constructor(fileOrInput: HTMLInputElement | File) {
    this.rawFile = fileOrInput;
    const fakePathOrObject =  fileOrInput instanceof HTMLInputElement ? fileOrInput.value : fileOrInput;
    const postfix = typeof fakePathOrObject === 'string' ? 'FakePath' : 'Object';
    const method = `_createFrom${postfix}`;
    (this as any)[ method ](fakePathOrObject);
  }

  _createFromFakePath(path: string): void {
    this.lastModifiedDate = void 0;
    this.size = void 0;
    this.type = `like/${path.slice(path.lastIndexOf('.') + 1).toLowerCase()}`;
    this.name = path.slice(path.lastIndexOf('/') + path.lastIndexOf('\\') + 2);
  }

  _createFromObject(object: { size: number, type: string, name: string }): void {
    this.size = object.size;
    this.type = object.type;
    this.name = object.name;
  }
}
