////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { Component, OnInit, ViewChild, Inject } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material';
import { MatDialogRef, MatListModule, MatProgressBarModule } from '@angular/material';
import { AssessmentService } from '../../services/assessment.service';
import { Router } from '@angular/router';
import { forkJoin } from 'rxjs/observable/forkJoin';

@Component({
  selector: 'app-upload-export',
  templateUrl: './upload-export.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a w-100 h-100'}
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
    private assessSvc: AssessmentService,
    private router: Router,
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
      this.closeDialog();
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
    // if everything was uploaded already, just close the dialog
    if (this.uploadSuccessful) {
      return this.dialog.close();
    }

    // set the component state to "uploading"
    this.uploading = true;

    // start the upload and save the progress map

    this.progress = this.importSvc.upload(this.files, this.data.IsNormalLoad);

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

    // Hide the cancel-button
    this.showCancelButton = false;
    // When all progress-observables are completed...
    forkJoin(allProgressObservables).subscribe(end => {
      // ... the dialog can be closed again...
      this.canBeClosed = true;
      this.dialog.disableClose = false;
      // ... the upload was successful...
      this.uploadSuccessful = true;
      // ... and the component is no longer uploading
      this.uploading = false;
      this.dialog.close();
    });
  }
}
