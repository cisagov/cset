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
import { Component, Input, OnInit } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';

@Component({
  selector: 'app-sal-section',
  templateUrl: './sal-section.component.html',
  styleUrls: ['../reports.scss']
})
export class SalSectionComponent implements OnInit {

  @Input()
  response: any;

  // FIPS SAL answers
  nistSalC = '';
  nistSalI = '';
  nistSalA = '';

  /**
   * 
   * @param analysisSvc 
   */
  constructor(
    public analysisSvc: ReportAnalysisService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    // Break out any CIA special factors now - can't do a find in the template
    let v: any = this.response.nistTypes.find(x => x.ciA_Type === 'Confidentiality');
    if (!!v) {
      this.nistSalC = v.justification;
    }
    v = this.response.nistTypes.find(x => x.ciA_Type === 'Integrity');
    if (!!v) {
      this.nistSalI = v.justification;
    }
    v = this.response.nistTypes.find(x => x.ciA_Type === 'Availability');
    if (!!v) {
      this.nistSalA = v.justification;
    }
  }
}
