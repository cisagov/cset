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
import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { FileUploadClientService } from '../../../../services/file-client.service';

@Component({
  selector: 'app-awwa-standard',
  templateUrl: './awwa-standard.component.html'
})
export class AwwaStandardComponent implements OnInit {

  // 1 - before upload
  // 2 - uploading/importing data
  // 3 - import complete
  importStatus = 1;
  errorMessage: string = "";

  constructor(
    public dialogRef: MatDialogRef<AwwaStandardComponent>,
    public fileSvc: FileUploadClientService
  ) { }

  ngOnInit() {
  }

  /**
   * 
   */
  openAwwaSite() {
    this.dialogRef.close();
    window.open('http://www.awwa.org/cyber');
  }

  /**
   * Reads the contents of the event's file.
   * @param e The 'file' event
   */
  fileSelectAwwa(e: any) {
    const file: any = e.target.files[0];

    this.importStatus = 2;

    const options = {
      methodology: "AWWA"
    };
    this.fileSvc.uploadAwwaSpreadsheet(file, options).subscribe(result => {
      // pop an alert here confirming the upload
      if (result.hasOwnProperty('ok')) {
        this.importStatus = 3;
      }
    },
      err => {
        this.errorMessage = "Error importing excel.  Check that AWWA file is valid.";
        this.importStatus = 1;
      });
  }

  /**
 * Programatically clicks the corresponding file upload element.
 * @param event
 */
  openFileBrowser(event: any) {
    event.preventDefault();
    const element: HTMLElement = document.getElementById('awwaUpload') as HTMLElement;
    element.click();
  }

  /**
   * 
   */
  close() {
    this.dialogRef.close();
  }
}
