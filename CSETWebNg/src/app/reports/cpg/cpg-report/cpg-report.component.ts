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
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { CpgService } from '../../../services/cpg.service';
import { RraDataService } from '../../../services/rra-data.service';

@Component({
  selector: 'app-cpg-report',
  templateUrl: './cpg-report.component.html',
  styleUrls: ['./cpg-report.component.scss', '../../reports.scss']
})
export class CpgReportComponent implements OnInit {

  loading = false;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;

  answerDistribByDomain: any;

  /**
   * 
   */
  constructor(
    public rraDataSvc: RraDataService,
    public titleSvc: Title,
    private assessSvc: AssessmentService,
    public cpgSvc: CpgService,
    public configSvc: ConfigService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.titleSvc.setTitle("CPGs Report - CSET");

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.creatorName;
    });

    this.cpgSvc.getAnswerDistrib().subscribe((resp: any) => {
      resp.forEach(r => {
        r.series.forEach(element => {
          if (element.name == 'U') {
            element.name = 'Unanswered';
          } else {
            element.name = this.configSvc.config.answersCPG.find(x => x.code == element.name).answerLabel;
          }
        });
      });

      this.answerDistribByDomain = resp;
    });
  }
}
