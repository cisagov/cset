////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewChecked } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { AcetDashboard } from '../../models/acet-dashboard.model';
import { AdminTableData, AdminPageData, HoursOverride } from '../../models/admin-save.model';
import { ACETService } from '../../services/acet.service';
import { MaturityService } from '../../services/maturity.service';

@Component({
  selector: 'sitesummary',
  templateUrl: './sitesummary.component.html',
  styleUrls: ['../reports.scss']
})
export class SitesummaryComponent implements OnInit, AfterViewChecked {
  chartStandardsSummary: Chart;
  chartRankedSubjectAreas: Chart;
  chartPercentCompliance: Chart;
  canvasStandardResultsByCategory: Chart;
  response: any;
  responseResultsByCategory: any;


  chart1: Chart;
  numberOfStandards = -1;
  complianceGraphs: any[] = [];
  networkDiagramImage: SafeHtml;

  pageInitialized = false;

  // FIPS SAL answers
  nistSalC = '';
  nistSalI = '';
  nistSalA = '';

  // Charts for Components
  componentCount = 0;
  chartComponentSummary: Chart;
  chartComponentsTypes: Chart;
  networkRecommendations = [];
  canvasComponentCompliance: Chart;
  warnings: any;

  // ACET data
  matDetails: any;
  acetDashboard: AcetDashboard;
  Components: AdminTableData[];
  adminPageData: AdminPageData;
  GrandTotal: number;
  DocumentationTotal: number;
  InterviewTotal: number;
  ReviewedStatementTotal: number;

  isCmmc: boolean = false;



  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public acetSvc: ACETService,
    private sanitizer: DomSanitizer, 
    private maturitySvc: MaturityService
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Site Summary Report - CSET");
    this.isCmmc = this.maturitySvc.maturityModelIsCMMC();
    this.reportSvc.getReport('sitesummary').subscribe(
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
      },
      error => console.log('Site Summary report load Error: ' + (<Error>error).message)
    );

    // Populate charts

    // Summary Percent Compliance
    this.analysisSvc.getDashboard().subscribe(x => {
      this.chartPercentCompliance = this.analysisSvc.buildPercentComplianceChart('canvasCompliance', x);
    });


    // Standards Summary (pie or stacked bar)
    this.analysisSvc.getStandardsSummary().subscribe(x => {
      this.chartStandardsSummary = this.analysisSvc.buildStandardsSummary('canvasStandardSummary', x);
    });


    // Standards By Category
    this.analysisSvc.getStandardsResultsByCategory().subscribe(x => {
      this.responseResultsByCategory = x;

      // Standard Or Question Set (multi-bar graph)
      this.canvasStandardResultsByCategory = this.analysisSvc.buildStandardResultsByCategoryChart('canvasStandardResultsByCategory', x);

      // Set up arrays for green bar graphs
      this.numberOfStandards = !!x.dataSets ? x.dataSets.length : 0;
      if (!!x.dataSets) {
        x.dataSets.forEach(element => {
          this.complianceGraphs.push(element);
        });
      }
    });


    // Ranked Subject Areas
    this.analysisSvc.getOverallRankedCategories().subscribe(x => {
      this.chartRankedSubjectAreas = this.analysisSvc.buildRankedSubjectAreasChart('canvasRankedSubjectAreas', x);
    });


    // Component Summary
    this.analysisSvc.getComponentSummary().subscribe(x => {
      setTimeout(() => {
        this.chartComponentSummary = this.analysisSvc.buildComponentSummary('canvasComponentSummary', x);
      }, 100);
    });


    // Component Types (stacked bar chart)
    this.analysisSvc.getComponentTypes().subscribe(x => {
      this.componentCount = x.Labels.length;
      setTimeout(() => {
        this.chartComponentsTypes = this.analysisSvc.buildComponentTypes('canvasComponentTypes', x);
      }, 100);
    });


    // Component Compliance by Subject Area
    this.analysisSvc.getComponentsResultsByCategory().subscribe(x => {
      this.analysisSvc.buildComponentsResultsByCategory('canvasComponentCompliance', x);
    });


    // Network Warnings
    this.analysisSvc.getNetworkWarnings().subscribe(x => {
      this.warnings = x;
    });

    this.reportSvc.getNetworkDiagramImage().subscribe(x => {
      this.networkDiagramImage = this.sanitizer.bypassSecurityTrustHtml(x);
    });


    // ACET-specific content
    this.reportSvc.getACET().subscribe((x: boolean) => {
      this.reportSvc.hasACET = x;
    });

    this.acetSvc.getMatDetailList().subscribe(
      (data) => {
        this.matDetails = data;
      },
      error => {
        console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error getting all documents: ' + (<Error>error).stack);
      });

    this.acetSvc.getAcetDashboard().subscribe(
      (data: AcetDashboard) => {
        this.acetDashboard = data;

        for (let i = 0; i < this.acetDashboard.IRPs.length; i++) {
          this.acetDashboard.IRPs[i].Comment = this.acetSvc.interpretRiskLevel(this.acetDashboard.IRPs[i].RiskLevel);
        }
      },
      error => {
        console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error getting all documents: ' + (<Error>error).stack);
      });

    this.acetSvc.getAdminData().subscribe(
      (data: AdminPageData) => {
        this.adminPageData = data;
        this.ProcessAcetAdminData();
      },
      error => {
        console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error getting all documents: ' + (<Error>error).stack);
      });
  }

  /**
   *
   */
  ngAfterViewChecked() {
    if (this.pageInitialized) {
      return;
    }

    // There's probably a better way to do this ... we have to wait until the
    // complianceGraphs array has been built so that the template can bind to it.
    if (this.complianceGraphs.length === this.numberOfStandards && this.numberOfStandards >= 0) {
      this.pageInitialized = true;
    }

    // at this point the template should know how big the complianceGraphs array is
    let cg = 0;
    this.complianceGraphs.forEach(x => {
      this.chart1 = this.analysisSvc.buildRankedCategoriesChart("complianceGraph" + cg++, x);
    });
  }


  ProcessAcetAdminData() {
    /// the data type Barry used to load data for this screen would be really, really hard
    /// to work with in angular, with a single row described in multiple entries.
    /// so here i turn barry's model into something more workable.
    this.Components = [];

    // the totals at the bottom of the table
    this.GrandTotal = this.adminPageData.GrandTotal;
    for (let i = 0; i < this.adminPageData.ReviewTotals.length; i++) {
      if (this.adminPageData.ReviewTotals[i].ReviewType === "Documentation") {
        this.DocumentationTotal = this.adminPageData.ReviewTotals[i].Total;
      } else if (this.adminPageData.ReviewTotals[i].ReviewType === "Interview Process") {
        this.InterviewTotal = this.adminPageData.ReviewTotals[i].Total;
      } else if (this.adminPageData.ReviewTotals[i].ReviewType === "Statements Reviewed") {
        this.ReviewedStatementTotal = this.adminPageData.ReviewTotals[i].Total;
      }
    }

    // Create a framework for the page's values
    this.BuildComponent(this.Components, "Pre-exam prep", false);
    this.BuildComponent(this.Components, "IRP", false);
    this.BuildComponent(this.Components, "Domain 1", false);
    this.BuildComponent(this.Components, "Domain 2", false);
    this.BuildComponent(this.Components, "Domain 3", false);
    this.BuildComponent(this.Components, "Domain 4", false);
    this.BuildComponent(this.Components, "Domain 5", false);
    this.BuildComponent(this.Components, "Discussing end results with CU", false);
    this.BuildComponent(this.Components, "Other (specify)", true);
    this.BuildComponent(this.Components, "Additional Other (specify)", true);

    // the "meat" of the page, the components list and hours on each
    for (let i = 0; i < this.adminPageData.DetailData.length; i++) {
      const detail: HoursOverride = this.adminPageData.DetailData[i];

      // find the corresponding Component/Row in the framework
      const c = this.Components.find(function (element) {
        return element.Component === detail.Data.Component;
      });

      if (!!c) {
        // drop in the hours
        if (detail.Data.ReviewType === "Documentation") {
          c.DocumentationHours = detail.Data.Hours;
        } else if (detail.Data.ReviewType === "Interview Process") {
          c.InterviewHours = detail.Data.Hours;
        }

        c.StatementsReviewed = detail.StatementsReviewed;

        c.OtherSpecifyValue = detail.Data.OtherSpecifyValue;
      }
    }
  }

  /**
   * Builds one 'row/component'.
   */
  BuildComponent(components: AdminTableData[], componentName: string, hasSpecifyField: boolean) {
    const comp = new AdminTableData();
    comp.Component = componentName;
    comp.DocumentationHours = 0;
    comp.InterviewHours = 0;
    comp.StatementsReviewed = 0;
    comp.HasSpecifyField = hasSpecifyField;
    components.push(comp);
  }
}
