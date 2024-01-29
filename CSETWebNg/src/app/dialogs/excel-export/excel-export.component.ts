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
import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { ConfigService } from '../../services/config.service';
import { AssessmentService } from '../../services/assessment.service';

@Component({
  selector: 'excel-export',
  templateUrl: './excel-export.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ExcelExportComponent {

  doNotShow: boolean = false;

  /**
   * Constructor.
   */
  constructor(
    private dialog: MatDialogRef<ExcelExportComponent>,
    public configSvc: ConfigService,
    public assessSvc: AssessmentService,
    @Inject(MAT_DIALOG_DATA) public data: any) {
    dialog.beforeClosed().subscribe(() => dialog.close());
    var doNotShowLocal = localStorage.getItem('doNotShowExcelExport');
    this.doNotShow = doNotShowLocal && doNotShowLocal == 'true' ? true : false;
  }

  close() {
    return this.dialog.close();
  }

  exportToExcel() {
    if (this.assessSvc.isISE()) {
      window.location.href = this.configSvc.apiUrl + 'ExcelExportISE?token=' + localStorage.getItem('userToken');
    } else {
      window.location.href = this.configSvc.apiUrl + 'ExcelExport?token=' + localStorage.getItem('userToken');
    }

    this.dialog.close();
  }

  setDoNotShow() {
    localStorage.setItem('doNotShowExcelExport', this.doNotShow.toString());
  }

}
