import { FileLikeObject } from '../index';

export class FileType {
  /*  MS office  */
  // tslint:disable-next-line:variable-name
  static mime_doc: string[] = [
    'application/msword',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.template',
    'application/vnd.ms-word.document.macroEnabled.12',
    'application/vnd.ms-word.template.macroEnabled.12'
  ];
  // tslint:disable-next-line:variable-name
  static mime_xsl: string[] = [
    'application/vnd.ms-excel',
    'application/vnd.ms-excel',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.template',
    'application/vnd.ms-excel.sheet.macroEnabled.12',
    'application/vnd.ms-excel.template.macroEnabled.12',
    'application/vnd.ms-excel.addin.macroEnabled.12',
    'application/vnd.ms-excel.sheet.binary.macroEnabled.12'
  ];
  // tslint:disable-next-line:variable-name
  static mime_ppt: string[] = [
    'application/vnd.ms-powerpoint',
    'application/vnd.ms-powerpoint',
    'application/vnd.ms-powerpoint',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/vnd.openxmlformats-officedocument.presentationml.template',
    'application/vnd.openxmlformats-officedocument.presentationml.slideshow',
    'application/vnd.ms-powerpoint.addin.macroEnabled.12',
    'application/vnd.ms-powerpoint.presentation.macroEnabled.12',
    'application/vnd.ms-powerpoint.presentation.macroEnabled.12',
    'application/vnd.ms-powerpoint.slideshow.macroEnabled.12'
  ];

  /* PSD */
  // tslint:disable-next-line:variable-name
  static mime_psd: string[] = [
    'image/photoshop',
    'image/x-photoshop',
    'image/psd',
    'application/photoshop',
    'application/psd',
    'zz-application/zz-winassoc-psd'
  ];

  /* Compressed files */
  // tslint:disable-next-line:variable-name
  static mime_compress: string[] = [
    'application/x-gtar',
    'application/x-gcompress',
    'application/compress',
    'application/x-tar',
    'application/x-rar-compressed',
    'application/octet-stream',
    'application/x-zip-compressed',
    'application/zip-compressed',
    'application/x-7z-compressed',
    'application/gzip',
    'application/x-bzip2'
  ];

  static getMimeClass(file: FileLikeObject): string {
    let mimeClass = 'application';
    if (file?.type && this.mime_psd.indexOf(file.type) !== -1) {
      mimeClass = 'image';
    } else if (file?.type?.match('image.*')) {
      mimeClass = 'image';
    } else if (file?.type?.match('video.*')) {
      mimeClass = 'video';
    } else if (file?.type?.match('audio.*')) {
      mimeClass = 'audio';
    } else if (file?.type === 'application/pdf') {
      mimeClass = 'pdf';
    } else if (file?.type && this.mime_compress.indexOf(file.type) !== -1) {
      mimeClass = 'compress';
    } else if (file?.type && this.mime_doc.indexOf(file.type) !== -1) {
      mimeClass = 'doc';
    } else if (file?.type && this.mime_xsl.indexOf(file.type) !== -1) {
      mimeClass = 'xls';
    } else if (file?.type && this.mime_ppt.indexOf(file.type) !== -1) {
      mimeClass = 'ppt';
    }
    if (mimeClass === 'application' && file?.name) {
      mimeClass = this.fileTypeDetection(file.name);
    }

    return mimeClass;
  }

  static fileTypeDetection(inputFilename: string): string {
    const types: { [ key: string ]: string } = {
      jpg: 'image',
      jpeg: 'image',
      tif: 'image',
      psd: 'image',
      bmp: 'image',
      png: 'image',
      nef: 'image',
      tiff: 'image',
      cr2: 'image',
      dwg: 'image',
      cdr: 'image',
      ai: 'image',
      indd: 'image',
      pin: 'image',
      cdp: 'image',
      skp: 'image',
      stp: 'image',
      '3dm': 'image',
      mp3: 'audio',
      wav: 'audio',
      wma: 'audio',
      mod: 'audio',
      m4a: 'audio',
      compress: 'compress',
      zip: 'compress',
      rar: 'compress',
      '7z': 'compress',
      lz: 'compress',
      z01: 'compress',
      bz2: 'compress',
      gz: 'compress',
      pdf: 'pdf',
      xls: 'xls',
      xlsx: 'xls',
      ods: 'xls',
      mp4: 'video',
      avi: 'video',
      wmv: 'video',
      mpg: 'video',
      mts: 'video',
      flv: 'video',
      '3gp': 'video',
      vob: 'video',
      m4v: 'video',
      mpeg: 'video',
      m2ts: 'video',
      mov: 'video',
      doc: 'doc',
      docx: 'doc',
      eps: 'doc',
      txt: 'doc',
      odt: 'doc',
      rtf: 'doc',
      ppt: 'ppt',
      pptx: 'ppt',
      pps: 'ppt',
      ppsx: 'ppt',
      odp: 'ppt'
    };

    const chunks = inputFilename.split('.');
    if (chunks.length < 2) {
      return 'application';
    }
    const extension = chunks[ chunks.length - 1 ].toLowerCase();
    if (types[ extension ] === undefined) {
      return 'application';
    } else {
      return types[ extension ];
    }
  }
}
