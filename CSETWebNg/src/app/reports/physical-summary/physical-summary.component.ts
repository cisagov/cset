////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewInit } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { AdminTableData, AdminPageData, HoursOverride } from '../../models/admin-save.model';
import { MaturityService } from '../../services/maturity.service';
import { QuestionsService } from '../../services/questions.service';
import Chart from 'chart.js/auto';
import { AssessmentService } from '../../services/assessment.service';
import { TranslocoService } from '@jsverse/transloco';

@Component({
    selector: 'physical-summary',
    templateUrl: './physical-summary.component.html',
    styleUrls: ['../reports.scss'],
    standalone: false
})
export class PhysicalSummaryComponent implements OnInit, AfterViewInit {
  chartStandardsSummary: Chart;
  chartPercentCompliance: Chart;
  translationSub: any;
  response: any;
  responseResultsByCategory: any;

  networkDiagramImage: SafeHtml;

  pageInitialized = false;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    private titleService: Title,
    private sanitizer: DomSanitizer,
    private maturitySvc: MaturityService,
    public tSvc: TranslocoService
  ) { }

  ngOnInit() {
    this.tSvc.selectTranslate('core.physical summary.report title', {}, { scope: 'reports' })
      .subscribe(title =>
        this.titleService.setTitle(title + ' - ' + this.configSvc.behaviors.defaultTitle));

    this.reportSvc.getReport('physicalsummary').subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Physical Summary report load Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   */
  ngAfterViewInit() {

  }


  ngOnDestroy() {
    this.translationSub.unsubscribe()
  }
}
