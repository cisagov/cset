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
import { QuestionsService } from '../../services/questions.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { AcetDashboard } from '../../models/acet-dashboard.model';
import { AdminTableData, AdminPageData, HoursOverride } from '../../models/admin-save.model';
import { ACETService } from '../../services/acet.service';
import Chart from 'chart.js/auto';
import { AssessmentService } from '../../services/assessment.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'site-detail',
  templateUrl: './site-detail.component.html',
  styleUrls: ['../reports.scss']
})
export class SiteDetailComponent implements OnInit {
  translationSub: any;
  response: any = null;
  chartStandardsSummary: Chart;
  responseResultsByCategory: any;

  networkDiagramImage: SafeHtml;

  pageInitialized = false;


  // Charts for Components
  componentCount = 0;
  chartPercentCompliance: Chart;
  chartComponentsTypes: Chart;
  networkRecommendations = [];
  warnings: any;

  // ACET data
  matDetails: any;
  acetDashboard: AcetDashboard;
  components: AdminTableData[];
  adminPageData: AdminPageData;
  grandTotal: number;
  documentationTotal: number;
  interviewTotal: number;
  reviewedStatementTotal: number;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    private titleService: Title,
    public acetSvc: ACETService,
    private assessmentSvc: AssessmentService,
    private sanitizer: DomSanitizer,
    public tSvc: TranslocoService
  ) { }

  ngOnInit() {
    this.translationSub = this.tSvc.selectTranslate('reports.core.site detail report.report title')
      .subscribe(value =>
        this.titleService.setTitle(this.tSvc.translate('reports.core.site detail report.report title') + ' - ' + this.configSvc.behaviors.defaultTitle));

    this.reportSvc.getReport('detail').subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Detail report load Error: ' + (<Error>error).message)
    );

    // Populate charts


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
      this.networkDiagramImage = this.sanitizer.bypassSecurityTrustHtml(x.diagram);
    });

    this.assessmentSvc.getAssessmentDetail().subscribe(x => {
      if (x['useMaturity'] === true){
          this.acetSvc.getMatDetailList().subscribe(
        (data) => {
          this.matDetails = data;
        },
        error => {
          console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
          console.log('Error getting all documents: ' + (<Error>error).stack);
        });
      }
    })
    

    if (['ACET', 'ISE'].includes(this.assessmentSvc.assessment?.maturityModel?.modelName)) {
      this.acetSvc.getAcetDashboard().subscribe(
        (data: AcetDashboard) => {
          this.acetDashboard = data;

          for (let i = 0; i < this.acetDashboard.irps.length; i++) {
            this.acetDashboard.irps[i].comment = this.acetSvc.interpretRiskLevel(this.acetDashboard.irps[i].riskLevel);
          }
        },
        error => {
          console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
          console.log('Error getting all documents: ' + (<Error>error).stack);
        });

      this.acetSvc.getAdminData().subscribe(
        (data: AdminPageData) => {
          this.adminPageData = data;
          this.processAcetAdminData();
        },
        error => {
          console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
          console.log('Error getting all documents: ' + (<Error>error).stack);
        });
    }
  }

  processAcetAdminData() {
    /// the data type Barry used to load data for this screen would be really, really hard
    /// to work with in angular, with a single row described in multiple entries.
    /// so here i turn barry's model into something more workable.
    this.components = [];

    // the totals at the bottom of the table
    this.grandTotal = this.adminPageData.grandTotal;
    for (let i = 0; i < this.adminPageData.reviewTotals.length; i++) {
      if (this.adminPageData.reviewTotals[i].reviewType === "Documentation") {
        this.documentationTotal = this.adminPageData.reviewTotals[i].total;
      } else if (this.adminPageData.reviewTotals[i].reviewType === "Interview Process") {
        this.interviewTotal = this.adminPageData.reviewTotals[i].total;
      } else if (this.adminPageData.reviewTotals[i].reviewType === "Statements Reviewed") {
        this.reviewedStatementTotal = this.adminPageData.reviewTotals[i].total;
      }
    }

    // Create a framework for the page's values
    this.buildComponent(this.components, "Pre-exam prep", false);
    this.buildComponent(this.components, "IRP", false);
    this.buildComponent(this.components, "Domain 1", false);
    this.buildComponent(this.components, "Domain 2", false);
    this.buildComponent(this.components, "Domain 3", false);
    this.buildComponent(this.components, "Domain 4", false);
    this.buildComponent(this.components, "Domain 5", false);
    this.buildComponent(this.components, "Discussing end results with CU", false);
    this.buildComponent(this.components, "Other (specify)", true);
    this.buildComponent(this.components, "Additional Other (specify)", true);

    // the "meat" of the page, the components list and hours on each
    for (let i = 0; i < this.adminPageData.detailData.length; i++) {
      const detail: HoursOverride = this.adminPageData.detailData[i];

      // find the corresponding Component/Row in the framework
      const c = this.components.find(function (element) {
        return element.component === detail.data.component;
      });

      if (!!c) {
        // drop in the hours
        if (detail.data.reviewType === "Documentation") {
          c.documentationHours = detail.data.hours;
        } else if (detail.data.reviewType === "Interview Process") {
          c.interviewHours = detail.data.hours;
        }

        c.statementsReviewed = detail.statementsReviewed;

        c.otherSpecifyValue = detail.data.otherSpecifyValue;
      }
    }
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
