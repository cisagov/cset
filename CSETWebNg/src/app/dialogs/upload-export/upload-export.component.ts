////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { ImportAssessmentService } from './../../services/import-assessment.service';
import { FileUploadClientService } from '../../services/file-client.service';
import { DiagramService } from './../../services/diagram.service';
import { Component, OnInit, ViewChild, Inject } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-upload-export',
  templateUrl: './upload-export.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100 h-100' }
})
export class UploadExportComponent implements OnInit {

  loading: boolean = false;

  @ViewChild('file') file;
  public files: Set<File> = new Set();
  progress;
  canBeClosed = true;
  primaryButtonText = 'Import Assessment File';
  showCancelButton = true;
  uploading = false;
  uploadSuccessful = false;
  statusText = "";

  constructor(private dialog: MatDialogRef<UploadExportComponent>,
    private importSvc: ImportAssessmentService,
    private fileSvc: FileUploadClientService,
    private diagramSvc: DiagramService,
    @Inject(MAT_DIALOG_DATA) public data: any) {
  }

  close() {
    return this.dialog.close();
  }

  ngOnInit() {
    if (this.data) {
      const files: { [key: string]: File } = this.data.files;
      for (const key in files) {
        if (!isNaN(parseInt(key, 10))) {
          this.files.add(files[key]);
        }
      }
      this.progressDialog();
    }
  }

  addFiles() {
    this.file.nativeElement.click();
  }

  onFilesAdded() {
    const files: { [key: string]: File } = this.file.nativeElement.files;
    for (const key in files) {
      if (!isNaN(parseInt(key, 10))) {
        this.files.add(files[key]);
      }
    }
  }

  closeDialog() {
    this.dialog.close();
    this.fileSvc.continueUpload = true;
  }

  cancelUpload() {
    this.fileSvc.continueUpload = false;
    this.canBeClosed = true;
    this.dialog.disableClose = false;
    this.statusText = "Import process canceled. Further importing has ceased."
  }

  progressDialog() {
    // if everything was uploaded already, just close the dialog
    if (this.uploadSuccessful) {
      return this.dialog.close();
    }

    // set the component state to "uploading"
    this.uploading = true;

    // start the upload and save the progress map

    if (this.data.isCsafUpload) {
      this.progress = this.fileSvc.uploadCsafFiles(this.files);
    } else {
      this.progress = this.importSvc.upload(this.files, this.data.isNormalLoad);
    }

    // convert the progress map into an array
    const allProgressObservables = [];
    for (const key in this.progress) {
      if (this.progress.hasOwnProperty(key)) {
        allProgressObservables.push(this.progress[key].progress);
      }
    }

    // Adjust the state variables
    // The OK-button should have the text "Finish" now
    // this.primaryButtonText = 'Finish';
    this.statusText = "Running import process please wait...";

    // The dialog should not be closed while uploading
    this.canBeClosed = false;
    this.dialog.disableClose = true;

    // Show cancel button if CSAF upload
    if (this.data.isCsafUpload) {
      this.showCancelButton = true;
    } else {
      this.showCancelButton = false;
    }

    // When all progress-observables are completed...
    let count = 0
    allProgressObservables.forEach(element => {
      element.subscribe(
        succ => {
          // console.log(succ)
        },
        fail => {
          if (fail && fail.message) {
            this.canBeClosed = true;
            this.dialog.disableClose = false;
            this.statusText = fail.message;
          }
        },
        comp => {
          count += 1
          if(count >= allProgressObservables.length){
            if (this.data.isCsafUpload) {
              this.canBeClosed = true;
              this.dialog.disableClose = false;
              this.statusText = 'File upload successful'
            } else {
              this.dialog.close();
            }
          }
        }
      )
    });

    // forkJoin(allProgressObservables).subscribe(end => {
    //   // ... the dialog can be closed again...
    //   this.canBeClosed = true;
    //   this.dialog.disableClose = false;
    //   // ... the upload was successful...
    //   this.uploadSuccessful = true;
    //   // ... and the component is no longer uploading
    //   this.uploading = false;
    //   this.dialog.close();
    // });
  }
}
