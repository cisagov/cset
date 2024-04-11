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
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { QuestionsService } from './../../services/questions.service';
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-acet-compensatingcontrols',
  templateUrl: './acet-compensatingcontrols.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetCompensatingcontrolsComponent implements OnInit {
  response: any = null;

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    private titleService: Title,
    private tSvc: TranslocoService
  ) { }

  ngOnInit(): void {
    this.reportSvc.getAltList().subscribe(
      (r: any) => {
        this.response = r;
        this.titleService.setTitle(this.tSvc.translate('reports.acet.compensating controls.tab title'));
      },
      error => console.log('Compensating Controls Report Error: ' + (<Error>error).message)
    );
  }

}
