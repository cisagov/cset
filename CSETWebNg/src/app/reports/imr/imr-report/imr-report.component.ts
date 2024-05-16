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
import { Component, OnInit } from '@angular/core';
import { ReportService } from './../../../services/report.service';
import { CmuReportModel } from '../../../models/reports.model';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { CmuService } from '../../../services/cmu.service';

@Component({
  selector: 'app-imr-report',
  templateUrl: './imr-report.component.html',
  styleUrls: ['./imr-report.component.scss']
})
export class ImrReportComponent implements OnInit {
  model: CmuReportModel = {};
  modelReferences;
  any;
  confidentiality: string = '';

  constructor(
    private cmuSvc: CmuService,
    public reportSvc: ReportService,
    private titleSvc: Title,
    public configSvc: ConfigService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    const conf = localStorage.getItem('report-confidentiality');
    localStorage.removeItem('report-confidentiality');

    if (conf) {
      conf !== 'None' ? (this.confidentiality = conf) : (this.confidentiality = '');
    }

    this.titleSvc.setTitle('IMR Report - ' + this.configSvc.behaviors.defaultTitle);
    this.reportSvc.getAssessmentInfoForReport().subscribe((resp: any) => {
      this.model.assessmentDetails = resp;
    });

    this.reportSvc.getModelContent('').subscribe(
      (resp: any) => {
        this.model.structure = resp;
      },
      (error) => console.log('Error loading IMR report: ' + (<Error>error).message)
    );

    this.cmuSvc.getDomainCompliance().subscribe((resp: any) => {
      this.model.reportChart = resp;
    });

    this.cmuSvc.getCsf().subscribe((resp: any) => {
      this.model.cmuScores = resp;
    });
  }

  printReport() {
    window.print();
  }
}
