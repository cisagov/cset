////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { Title } from '@angular/platform-browser';
import { ReportService } from '../services/report.service';
import { AnalysisService } from '../services/analysis.service';

@Component({
  selector: 'rapp-securityplan',
  templateUrl: './securityplan.component.html',
  styleUrls: ['./securityplan.component.scss']
})
export class SecurityplanComponent implements OnInit {

  response: any;

  // FIPS SAL answers
  nistSalC = '';
  nistSalI = '';
  nistSalA = '';

  public constructor(private titleService: Title,
    private reportSvc: ReportService,
    public analysisSvc: AnalysisService
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.titleService.setTitle("Site Cybersecurity Plan - CSET");

    this.reportSvc.getReport('securityplan').subscribe(
      (r: any) => {
        this.response = r;

        // Break out any CIA special factors now - can't do a find in the template
        let v: any = this.response.nistTypes.find(x => x.CIA_Type === 'Confidentiality');
        if (!!v) {
          this.nistSalC = v.Justification;
        }
        v = this.response.nistTypes.find(x => x.CIA_Type === 'Integrity');
        if (!!v) {
          this.nistSalI = v.Justification;
        }
        v = this.response.nistTypes.find(x => x.CIA_Type === 'Availability');
        if (!!v) {
          this.nistSalA = v.Justification;
        }

        // convert line breaks to HTML
        this.response.ControlList.forEach(control => {
          control.ControlDescription = control.ControlDescription.replace('\r', '<br/>');
        });
      },
      error => console.log('Security Plan report load Error: ' + (<Error>error).message)
    );
  }


  public fixNewline(text: string) {
    return text.replace('\n', '<br/>');
  }
}
