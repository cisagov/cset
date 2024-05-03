////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { Component, ElementRef, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { CodeEditorComponent, CodeEditorService, CodeModel } from '@ngstack/code-editor';
import { saveAs } from 'file-saver';
import { editor } from 'monaco-editor/esm/vs/editor/editor.api';
import { Subject, Subscription } from 'rxjs';
import { debounceTime } from 'rxjs/operators';
import * as screenfull from "screenfull";
import { Screenfull } from "screenfull";
import { FileItem, FileUploader } from 'ng2-file-upload';
import { XmlCompletionItemProvider } from '../models/xmlCompletionItemProvider.model';
import { ConfigService } from '../services/config.service';
import { FileUploadClientService, LinkedSet } from '../services/file-client.service';
import { XmlFormatterFactory } from './formatting/xml-formatter';
import { XmlFormattingEditProvider } from './formatting/xml-formatting-edit-provider';

export class ImportFormData {
  public name: string;
  public shortName: string;
}

@Component({
  selector: 'app-import',
  templateUrl: './import.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-11a w-100' }
})
export class ImportComponent implements OnInit, OnDestroy {
  public uploader: FileUploader;
  public hasBaseDropZoneOver: boolean = false;
  public hasModuleBaseDropZoneOver: boolean = false;
  public hasAnotherDropZoneOver: boolean = false;
  public referenceUrl: string;
  public moduleCode: string;
  public state: string = 'Ready';
  public fileOverStateObservable: Subject<boolean> = new Subject<boolean>();
  public fileOverModuleStateObservable: Subject<boolean> = new Subject<boolean>();
  public monaco;
  public errors: Array<string> = [];
  public sets: Array<LinkedSet> = [];
  public lang = 'json';
  public jsonSchema;
  public isFullscreen: boolean = true;
  public codeModel: CodeModel;
  public codeGood: boolean;
  public items: any = {};
  public isDocError: boolean;
  public subscriptions: Array<Subscription> = [];
  @ViewChild('code') codeEditor: CodeEditorComponent;
  @ViewChild('codeContainer') codeContainer: ElementRef;

  public jsonCodeModel: CodeModel = {
    language: 'json',
    uri: 'main.json',
    value:
      // eslint-disable-next-line max-len
      '{ \r\n\t"name": "",\r\n\t"shortName": "",\r\n\t"category": "",\r\n\t"summary": "",\r\n\t"requirements":[\r\n\t\t{\r\n\t\t\t"identifier": "",\r\n\t\t\t"text": "",\r\n\t\t\t"heading": "",\r\n\t\t\t"subheading": "",\r\n\t\t\t"weight": 0\r\n\t\t}\r\n\t]\r\n}',
    schemas: []
  };

  public xmlCodeModel: CodeModel = {
    language: 'xml',
    uri: 'main.json',
    // eslint-disable-next-line max-len
    value: '<?xml version="1.0" encoding="utf-8"?>\r\n<Standard>\r\n\t<Category></Category>\r\n\t<Name></Name>\r\n\t<Requirements>\r\n\t\t<Requirement>\r\n\t\t\t<Heading></Heading>\r\n\t\t\t<Identifier></Identifier>\r\n\t\t\t<SecurityAssuranceLevels></SecurityAssuranceLevels>\r\n\t\t\t<Subheading></Subheading>\r\n\t\t\t<Text></Text>\r\n\t\t\t<Weight></Weight>\r\n\t\t</Requirement>\r\n\t</Requirements>\r\n\t<ShortName></ShortName>\r\n\t<Summary></Summary>\r\n</Standard>',
    schemas: []
  };

  public fileOverBase(e: any): void {
    this.fileOverStateObservable.next(e);
  }

  public fileOverModuleBase(e: any): void {
    this.fileOverModuleStateObservable.next(e);
  }

  public onModelChange(event) {
    this.moduleCode = event;
  }

  public fileOverAnother(e: any): void {
    this.hasAnotherDropZoneOver = e;
  }

  public onModuleFileChanged(event) {
    Array.from(event).forEach((fileItem: File) => {
      const fileReader = new FileReader();
      fileReader.onload = e => {
        (this.codeModel = {
          language: fileItem.name.endsWith('.xml') ? 'xml' : 'json',
          uri: fileItem.name.endsWith('.xml') ? 'main.xml' : 'main.json',
          value: fileReader.result.toString(),
          schemas: fileItem.name.endsWith('.xml')
            ? this.xmlCodeModel.schemas
            : this.jsonCodeModel.schemas
        }),
          (this.lang = fileItem.name.endsWith('.xml') ? 'xml' : 'json');
      };
      fileReader.readAsText(fileItem);
    });
  }

  get configOptions(): editor.IEditorConstructionOptions {
    return {
      formatOnPaste: true,
      formatOnType: true,
      automaticLayout: true,
      quickSuggestions: true
    };
  }
  get codeChecked(): boolean {
    return this.monaco && this.monaco.editor && !this.monaco.editor.getModelMarkers().length;
  }

  switchToJson() {
    this.codeModel = { ...this.jsonCodeModel };
    this.lang = 'json';
  }

  switchToXml() {
    this.codeModel = { ...this.xmlCodeModel };
    this.lang = 'xml';
  }

  clickXMLLink(setName: string) {
    this.fileClient.getXMLExportSet(setName).subscribe(s => {
      saveAs(new Blob([s], { type: 'application/xml' }), setName + '.xml');
    });
  }

  clickJSONLink(setName: string) {
    this.fileClient.getJSONExportSet(setName).subscribe(s => {
      saveAs(new Blob([s], { type: 'application/json' }), setName + '.json');
    });
  }

  loadJSONLink(setName: string) {
    this.state = 'Ready';

    if (this.lang === 'json') {
      this.fileClient.getJSONExportSet(setName).subscribe(s => {
        this.codeModel = {
          language: 'json',
          uri: 'main.json',
          value: JSON.stringify(JSON.parse(s), null, '\t'),
          schemas: this.jsonCodeModel.schemas
        };


      });
    } else {
      this.fileClient.getXMLExportSet(setName).subscribe(s => {
        this.codeModel = {
          language: 'xml',
          uri: 'main.xml',
          value: s,
          schemas: this.xmlCodeModel.schemas
        };
      });
    }
  }

  getXSD() {
    this.fileClient.download('assets/Standard.xsd').subscribe(s => {
      saveAs(s, 'standard.xsd');
    });
  }

  getJsonSchema() {
    saveAs(new Blob([JSON.stringify(this.jsonCodeModel.schemas[0].schema)]), 'standard.schema.json');
  }

  public submitForm() {
    this.isDocError = false;
    if (this.uploader.getNotUploadedItems().length) {
      this.uploader.uploadAll();
    } else {
      this.submitCode();
    }
  }

  public submitCode() {
    this.errors = [];
    this.state = 'Processing';
    this.fileClient.moduleUpload(this.moduleCode).subscribe(
      r => {
        if (r.status === 200) {
          this.state = 'Succeeded';
        } else {
          this.state = 'failed';
        }
      },
      e => {
        console.error(e)
        for (let key in e.error.errors) {
          this.errors.push(`${e.error.errors[key]}`);
        }
        this.state = 'Failed';
      }
    );
  }

  public clearForm() {
    this.uploader.clearQueue();
    this.moduleCode = '';
    this.codeModel = { ...this.jsonCodeModel };
    this.state = 'Ready';
    this.errors = [];
    this.subscriptions.forEach(s => s.unsubscribe());
  }

  public getFullScreen() {
    return screenfull && (screenfull as Screenfull).isFullscreen;
  }

  public fullScreen() {
    if (screenfull) {
      if (!(screenfull as Screenfull).isFullscreen) {
        (screenfull as Screenfull).request(this.codeContainer.nativeElement);
      } else {
        (screenfull as Screenfull).exit();
      }
    }
  }

  constructor(
    private configSvc: ConfigService,
    private fileClient: FileUploadClientService,
    private editorService: CodeEditorService
  ) {
    // hardcoding the polyfill here, as ugly as that is TODO:  Remove
    Promise.all = function (values: any): Promise<any> {
      let resolve: (v: any) => void;
      let reject: (v: any) => void;
      const promise = new Promise((res, rej) => {
        resolve = res;
        reject = rej;
      });

      // Start at 2 to prevent prematurely resolving if .then is called immediately.
      let unresolvedCount = 2;
      let valueIndex = 0;

      const resolvedValues: any[] = [];
      for (let value of values) {
        if (!(value && value.then)) {
          value = this.resolve(value);
        }

        const curValueIndex = valueIndex;
        value.then((val: any) => {
          resolvedValues[curValueIndex] = val;
          unresolvedCount--;
          if (unresolvedCount === 0) {
            if (resolve !== null) {
              resolve(resolvedValues);
            }
          }
        },
          () => {
            if (reject !== null) {
              reject(null);
            }
          });

        unresolvedCount++;
        valueIndex++;
      }

      // Make the unresolvedCount zero-based again.
      unresolvedCount -= 2;

      if (unresolvedCount === 0) {
        if (resolve !== null) {
          resolve(resolvedValues);
        }
      }

      return promise;
    };
    this.initializeUploader();
    this.codeModel = { ...this.jsonCodeModel };

  }

  ngOnInit() {
    if (this.uploader === undefined) {
      this.initializeUploader();
    };
  }

  ngOnDestroy() {
    this.subscriptions.forEach(s => s.unsubscribe());
  }

  private initializeUploader() {
    this.referenceUrl = this.configSvc.refDocUrl;

    this.uploader = new FileUploader({
      url: this.referenceUrl,
      authToken: localStorage.getItem('userToken')
    });
    this.uploader.onBuildItemForm = (fileItem: FileItem, form: any) => {
      Object.keys(fileItem.formData).forEach(prop => form.append(prop, fileItem.formData[prop]));
    };
    this.uploader.onAfterAddingAll = (fileItems: FileItem[]) => {
      fileItems.forEach((fileItem: FileItem) => {
        const data = new ImportFormData();
        fileItem.formData = data;
        this.items[fileItem.file.name] = data;
      });
    };
    this.uploader.onBeforeUploadItem = item => {
      item.withCredentials = false;
    };
    this.uploader.onErrorItem = (item) => {
      this.isDocError = true;
    };
    this.uploader.onCompleteAll = () => {
      this.uploader.queue.forEach((item, index, arr) => {
        if (item.isError) {
          item.isUploading = false;
          item.isUploaded = false;
        }
      });
      if (this.isDocError) {
        this.state = 'Failed';
      } else {
        this.submitCode();
      }
    };
    this.fileClient.getExports().subscribe(t => {
      this.sets = t;
    });
    this.codeModel = { ...this.jsonCodeModel };
    this.editorService.loaded.subscribe(t => {
      this.fileClient.getSchema().subscribe(s => {
        this.jsonCodeModel.schemas.push({
          uri: 'http://custom/schema.json',
          schema: s
        });
        this.codeModel = { ...this.jsonCodeModel };
      });
      this.fileClient.getText('assets/Standard.xsd').subscribe(s => {
        this.xmlCodeModel.schemas.push({
          uri: 'http://custom/schema.xsd',
          schema: s
        });
        this.monaco = t.monaco;
        t.monaco.languages.registerCompletionItemProvider(
          'xml',
          new XmlCompletionItemProvider(t, s)
        );
        t.monaco.languages.registerDocumentFormattingEditProvider(
          'xml',
          new XmlFormattingEditProvider(XmlFormatterFactory.getXmlFormatter())
        );
        t.monaco.languages.registerDocumentRangeFormattingEditProvider(
          'xml',
          new XmlFormattingEditProvider(XmlFormatterFactory.getXmlFormatter())
        );
      });
    });

    this.fileOverModuleStateObservable.pipe(debounceTime(10)).subscribe(t => {
      this.hasModuleBaseDropZoneOver = t;
    });

    this.fileOverStateObservable.pipe(debounceTime(10)).subscribe(t => {
      this.hasBaseDropZoneOver = t;
    });
  }

  public showError() {
    return this.state != 'Processing' && editor && editor.getModelMarkers({}).length || this.errors.length;
  }
}
