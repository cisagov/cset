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
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogActions } from '@angular/material/dialog';

@Component({
  selector: 'app-malcolm-upload-error',
  templateUrl: './malcolm-upload-error.component.html'
})
export class MalcolmUploadErrorComponent implements OnInit {
  isFileMode: boolean=true;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<MalcolmUploadErrorComponent>
  ) { }

  iconClass: string = "cset-icons-bell";
  dialogTitle: string = "Upload Error(s)";

  errors: any[] = [];

  have400errors: boolean = false;
  errorCode400Files: any[] = [];

  have415errors: boolean = false;
  errorCode415Files: any[] = [];


  ngOnInit() {
    this.errors = this.data.error;
    this.isFileMode = this.data.isFile;
    this.checkErrors();

  }

  checkErrors() {
    // Check each error we got back, and save the file name
    if(this.isFileMode){
      this.errors.forEach(error => {
        if (error.statusCode == 400) {
          this.errorCode400Files.push(error);
        }
        if (error.statusCode == 415) {
          this.errorCode415Files.push(error);
        }
      });
  
      // Show the files that caused HTTP code 400
      if (this.errorCode400Files.length > 0) {
        this.have400errors = true;
      } else {
        this.have400errors = false;
      }
  
      // Show the files that caused HTTP code 415
      if (this.errorCode415Files.length > 0) {
        this.have415errors = true;
      } else {
        this.have415errors = false;
      }
    }    
  }

}
