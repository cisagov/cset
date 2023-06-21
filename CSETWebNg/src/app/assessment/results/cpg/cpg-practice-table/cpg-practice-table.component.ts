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
import { Component, OnInit } from '@angular/core';
import { ColorService } from '../../../../services/color.service';
import { CpgService } from '../../../../services/cpg.service';

@Component({
  selector: 'app-cpg-practice-table',
  templateUrl: './cpg-practice-table.component.html',
  styleUrls: ['./cpg-practice-table.component.scss', '../../../../reports/reports.scss']
})
export class CpgPracticeTableComponent implements OnInit {

  model: any;


  /**
   * 
   */
  constructor(
    public cpgSvc: CpgService,
    public colorSvc: ColorService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.model = this.cpgSvc.getStructure().subscribe((resp: any) => {
      this.model = resp;
    });
  }

  /**
   * White text for all except DETECT (yellow)
   */
  textColor(groupId: number): string {
    if (groupId == 202) {
      return '#000';
    }
    return '#fff';
  }

  /**
   * Returns the color for the CSF function of the group.
   * This is specific to CPG grouping IDs.
   */
  backgroundColor(groupId: number): string {
    switch (groupId) {
      case 200:
        // identify
        return this.colorSvc.nistCsfFuncColor('ID');
      case 201:
        // protect
        return this.colorSvc.nistCsfFuncColor('PR');
      case 202:
        // detect
        return this.colorSvc.nistCsfFuncColor('DE');
      case 203:
        // respond
        return this.colorSvc.nistCsfFuncColor('RS');
      case 204:
        // recover
        return this.colorSvc.nistCsfFuncColor('RC');
      default:
        return '#6BA443';
    }
  }
}
