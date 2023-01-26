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
import { CpgService } from '../../../../services/cpg.service';
import { MaturityService } from '../../../../services/maturity.service';

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
    public cpgSvc: CpgService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.model = this.cpgSvc.getStructure().subscribe((resp: any) => {
      this.model = resp.Model;
      console.log(this.model);
    });
  }

  /**
   * Returns the color for the CSF function of the group.
   * This is specific to the CPG groupings.
   */
  csfFunctionColor(groupId: string): string {
    switch (groupId) {
      case '200':
        // identify
        return '#45A7DD';
      case '201':
        // protect
        return '#855196';
      case '202':
        // detect
        return '#F99F14';
      case '203':
        // respond
        return '#ED3643';
      case '204':
        // recover
        return '#36B649';
      default:
        return '#6BA443';
    }
  }
}
