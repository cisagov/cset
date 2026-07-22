////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { AssessmentService } from '../../services/assessment.service';
import { TranslocoService } from '@jsverse/transloco';
import Chart from 'chart.js/auto';
import { AssessmentDetail } from '../../models/assessment-info.model';
import DOMPurify from 'dompurify';

@Component({
  selector: 'site-summary',
  templateUrl: './site-summary.component.html',
  styleUrls: ['../reports.scss'],
  standalone: false,
  // eslint-disable-next-line
  host: {
    'class': 'force-light-mode',
    '[attr.data-theme]': '"light"',
    '[attr.data-bs-theme]': '"light"'
  }
})
export class SiteSummaryComponent implements OnInit, AfterViewInit {
  chartStandardsSummary: Chart;
  chartPercentCompliance: Chart;
  translationSub: any;
  response: any;
  info: AssessmentDetail;
  responseResultsByCategory: any;

  networkDiagramImage: SafeHtml;

  pageInitialized = false;


  // Charts for Components
  componentCount = 0;
  chartComponentSummary: Chart;
  chartComponentsTypes: Chart;
  networkRecommendations = [];
  warnings: any;

  // ACET data
  components: AdminTableData[];
  adminPageData: AdminPageData;
  grandTotal: number;
  documentationTotal: number;
  interviewTotal: number;
  reviewedStatementTotal: number;

  isCmmc: boolean = false;



  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    private titleService: Title,
    private sanitizer: DomSanitizer,
    private maturitySvc: MaturityService,
    private assessSvc: AssessmentService,
    public tSvc: TranslocoService
  ) { }

  ngOnInit() {
    this.isCmmc = this.maturitySvc.maturityModelIsCMMC();

    this.reportSvc.getReport('sitesummary').subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.error('Site Summary report load Error: ' + (<Error>error).message)
    );

    // Populate charts


    // Component Summary
    this.analysisSvc.getComponentSummary().subscribe(x => {
      setTimeout(() => {
        this.chartComponentSummary = <Chart>this.analysisSvc.buildComponentSummary('canvasComponentSummary', x);
      }, 100);
    });


    // Component Types (stacked bar chart)
    this.analysisSvc.getComponentTypes().subscribe(x => {
      this.componentCount = x.labels.length;
      setTimeout(() => {
        this.chartComponentsTypes = this.analysisSvc.buildComponentTypes('canvasComponentTypes', x);
      }, 100);
    });


    // Network Warnings
    this.analysisSvc.getNetworkWarnings().subscribe(x => {
      this.warnings = x;
    });

    this.reportSvc.getNetworkDiagramImage().subscribe(x => {
      this.networkDiagramImage = DOMPurify.sanitize(x.diagram);
    });

    this.assessSvc.getAssessmentDetail().subscribe(
      (r: AssessmentDetail) => {
        this.info = r;
        const assessmentTitle = r.assessmentName || `assessment-${r.id}`;
        this.tSvc.selectTranslate('core.site summary.report title', {}, { scope: 'reports' })
          .subscribe(reportTitle =>
            this.titleService.setTitle(`${reportTitle} - ${assessmentTitle}`));
      }
    );
  }

  /**
   * 
   */
  ngAfterViewInit() {

  }

  /**
   * Builds one 'row/component'.
   */
  buildComponent(components: AdminTableData[], componentName: string, hasSpecifyField: boolean) {
    const comp = new AdminTableData();
    comp.component = componentName;
    comp.documentationHours = 0;
    comp.interviewHours = 0;
    comp.statementsReviewed = 0;
    comp.hasSpecifyField = hasSpecifyField;
    components.push(comp);
  }

  usesRAC() {
    return !!this.responseResultsByCategory?.dataSets.find(e => e.label === 'RAC');
  }

  ngOnDestroy() {
    this.translationSub.unsubscribe()
  }
}
