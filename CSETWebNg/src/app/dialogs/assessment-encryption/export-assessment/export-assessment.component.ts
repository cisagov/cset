////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AssessmentService } from '../../../services/assessment.service';

@Component({
    selector: 'app-export-assessment',
    templateUrl: './export-assessment.component.html',
    styleUrls: ['./export-assessment.component.scss'],
    standalone: false
})
export class ExportAssessmentComponent {
  preventEncrypt: any;


  constructor(
    public assessSvc: AssessmentService,
    public dialogRef: MatDialogRef<ExportAssessmentComponent>,
    @Inject(MAT_DIALOG_DATA) public input: any,
  ) {
    dialogRef.disableClose = true;
  }

  data = {
    scrubData: false,
    encryptionData: {
      password: "",
      hint: "",
    }
  };

  password = "";
  passwordHint = "";
  showPassword = false;

  confirm(): void {
    this.data.encryptionData.password = this.password;
    this.data.encryptionData.hint = this.passwordHint;
    this.dialogRef.close(this.data);
  }

  cancel() {
    this.dialogRef.close();
  }

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

  onScrubDataChange(event: Event) {
    const checkbox = event.target as HTMLInputElement;
    this.data.scrubData = checkbox.checked;
  }
}
