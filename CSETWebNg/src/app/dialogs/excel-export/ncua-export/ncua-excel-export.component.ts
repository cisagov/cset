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
import { ConfigService } from '../../../services/config.service';

@Component({
  selector: 'ncua-excel-export',
  templateUrl: './ncua-excel-export.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class NcuaExcelExportComponent {

  acetCount: number = 0;
  iseCount: number = 0;

  acetTooltip: string = "";
  iseTooltip: string = "";


  constructor(
    private dialog: MatDialogRef<NcuaExcelExportComponent>,
    public configSvc: ConfigService,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) { }

  ngOnInit() {
    this.checkAssessmentTypes();
  }


  checkAssessmentTypes() {
    for (let i = 0; i < this.data.assessments.length; i++) {
      if (this.data.assessments[i].type == "ACET") {
        this.acetCount++;
      } else if (this.data.assessments[i].type == "ISE") {
        this.iseCount++;
      }
    }

    if (this.acetCount == 0) {
      this.acetTooltip = "There are no ACET assessments to export.";
    }

    if (this.iseCount == 0) {
      this.iseTooltip = "There are no ISE assessments to export.";
    }

  }


  close() {
    return this.dialog.close();
  }


  exportIseToExcel() {
    this.dialog.close('ISE');
  }


  exportAcetToExcel() {
    this.dialog.close('ACET');
  }

  getAcetTooltip() {
    return this.acetTooltip;
  }

  getIseTooltip() {
    return this.iseTooltip;
  }


}
