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
