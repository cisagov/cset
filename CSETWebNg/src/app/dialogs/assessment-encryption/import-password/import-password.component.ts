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
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ImportAssessmentService } from '../../../services/import-assessment.service';

@Component({
  selector: 'app-import-password',
  templateUrl: './import-password.component.html',
  styleUrls: ['./import-password.component.scss'],
  standalone: false
})
export class ImportPasswordComponent implements OnInit {

  constructor(
    private importSvc: ImportAssessmentService,
    public dialogRef: MatDialogRef<ImportPasswordComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) { }

  dialogTitle: string = "Unlock Assessment";
  password = "";
  passwordHint = "";
  showPassword = false;

  ngOnInit() {
    if (this.data && this.data.hint) {
      this.passwordHint = this.data.hint;
    }
  }

  confirm(): void {
    this.dialogRef.close(this.password);
  }

  cancel(): void {
    this.dialogRef.close();
  }

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

  getAssessmentHint(fileName: string) {
    let hintMap = this.importSvc.hintMap;

    let hint = hintMap.get(fileName);
    if (hint != undefined) {
      return hint;
    } else {
      return "";
    }
  }
}
