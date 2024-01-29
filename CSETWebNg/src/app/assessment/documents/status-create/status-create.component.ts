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
import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { HttpEventType } from '@angular/common/http';

import { UntypedFormControl, UntypedFormGroup, Validators, NgForm } from '@angular/forms';
import { FileUploadClientService } from '../../../services/file-client.service';


@Component({
  selector: 'app-status-create',
  templateUrl: './status-create.component.html'
})
export class StatusCreateComponent implements OnInit, OnDestroy {
  statusCreateForm: UntypedFormGroup;
  fileDescription: UntypedFormControl;
  fileToUpload: File = null;
  uploadProgress: number = 0;
  uploadComplete: boolean = false;
  uploadingProgressing: boolean = false;
  fileUploadSub: any;
  serverResponse: any;

  @ViewChild('myInput')
  myFileInput: any;


  constructor(
    private fileUploadService: FileUploadClientService
  ) { }

  ngOnInit() {
    /* initilize the form and/or extra form fields
        Do not initialize the file field
    */
    this.fileDescription = new UntypedFormControl('', [
      Validators.required,
      Validators.minLength(4),
      Validators.maxLength(280)
    ]);
    this.statusCreateForm = new UntypedFormGroup({
      'description': this.fileDescription,
    });
  }

  ngOnDestroy() {
    if (this.fileUploadSub) {
      this.fileUploadSub.unsubscribe();
    }
  }

  handleProgress(event) {
    if (event.type === HttpEventType.DownloadProgress) {
      this.uploadingProgressing = true;
      this.uploadProgress = Math.round(100 * event.loaded / event.total);
    }

    if (event.type === HttpEventType.UploadProgress) {
      this.uploadingProgressing = true;
      this.uploadProgress = Math.round(100 * event.loaded / event.total);
    }

    if (event.type === HttpEventType.Response) {
      this.uploadComplete = true;
      this.serverResponse = event.body;
    }
  }
  handleSubmit(event: any, statusNgForm: NgForm, statusFormGroup: UntypedFormGroup) {
    event.preventDefault();
    if (statusNgForm.submitted) {

      const submittedData = statusFormGroup.value;

      this.fileUploadSub = this.fileUploadService.fileUpload(
        this.fileToUpload,
        submittedData).subscribe(
          event2 => this.handleProgress(event2),
          () => {
            console.log('Server error');
          });

      statusNgForm.resetForm({});
    }
  }


  handleFileInput(files: FileList) {
    const fileItem = files.item(0);
    this.fileToUpload = fileItem;
  }

  resetFileInput() {
    this.myFileInput.nativeElement.value = '';
  }

}
