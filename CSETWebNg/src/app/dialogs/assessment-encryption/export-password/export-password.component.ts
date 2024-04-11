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
import { Component } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-export-password',
  templateUrl: './export-password.component.html',
  styleUrls: ['./export-password.component.scss']
})
export class ExportPasswordComponent {

  constructor(public dialogRef: MatDialogRef<ExportPasswordComponent>) {
    dialogRef.disableClose = true;
  }

  dialogTitle: string = "Encrypt Assessment";

  encryptionData = {
    password: "",
    hint: "",
  };

  password = "";
  passwordHint = "";
  showPassword = false;

  confirm(): void {
    this.encryptionData.password = this.password;
    this.encryptionData.hint = this.passwordHint;

    this.dialogRef.close(this.encryptionData);
  }

  cancel() {
    this.dialogRef.close();
  }

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

}
