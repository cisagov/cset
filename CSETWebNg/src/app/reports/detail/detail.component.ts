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
import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { AcetDashboard } from '../../models/acet-dashboard.model';
import { AdminTableData, AdminPageData, HoursOverride } from '../../models/admin-save.model';
import { ACETService } from '../../services/acet.service';

@Component({
  selector: 'detail',
  templateUrl: './detail.component.html', 
  styleUrls: ['../reports.scss']
})
export class DetailComponent implements OnInit, AfterViewInit, AfterViewChecked {
  response: any = null;
  chartPercentCompliance: Chart;
  chartStandardsSummary: Chart;
  canvasStandardResultsByCategory: Chart;
  responseResultsByCategory: any;
  chartRankedSubjectAreas: Chart;

  numberOfStandards = -1;

  chart1: Chart;
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
  components: AdminTableData[];
  adminPageData: AdminPageData;
  grandTotal: number;
  documentationTotal: number;
  interviewTotal: number;
  reviewedStatementTotal: number;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public acetSvc: ACETService,
    private sanitizer: DomSanitizer
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Site Detail Report - CSET");

    this.reportSvc.getReport('detail').subscribe(
      (r: any) => {
        this.response = r;

        // Break out any CIA special factors now - can't do a find in the template
        let v: any = this.response.nistTypes.find(x => x.cIA_Type === 'Confidentiality');
        if (!!v) {
          this.nistSalC = v.justification;
        }
        v = this.response.nistTypes.find(x => x.cIA_Type === 'Integrity');
        if (!!v) {
          this.nistSalI = v.justification;
        }
        v = this.response.nistTypes.find(x => x.cIA_Type === 'Availability');
        if (!!v) {
          this.nistSalA = v.justification;
        }
      },
      error => console.log('Detail report load Error: ' + (<Error>error).message)
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


    // create an array of discreet datasets for the green bar graphs
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


    // Component Summary
    this.analysisSvc.getComponentSummary().subscribe(x => {
      setTimeout(() => {
        this.chartComponentSummary = this.analysisSvc.buildComponentSummary('canvasComponentSummary', x);
      }, 100);
    });


    // Component Types (stacked bar chart)
    this.analysisSvc.getComponentTypes().subscribe(x => {
      this.componentCount = x.labels.length;
      setTimeout(() => {
        this.chartComponentsTypes = this.analysisSvc.buildComponentTypes('canvasComponentTypes', x);
      }, 100);
    });


    // Component Compliance by Subject Area
    this.analysisSvc.getComponentsResultsByCategory().subscribe(x => {
      this.analysisSvc.buildComponentsResultsByCategory('canvasComponentCompliance', x);
    });

    // Ranked Subject Areas
    this.analysisSvc.getOverallRankedCategories().subscribe(x => {
      this.chartRankedSubjectAreas = this.analysisSvc.buildRankedSubjectAreasChart('canvasRankedSubjectAreas', x);
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

  /**
   *
   */
  ngAfterViewInit() {

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
    this.BuildComponent(this.components, "Pre-exam prep", false);
    this.BuildComponent(this.components, "IRP", false);
    this.BuildComponent(this.components, "Domain 1", false);
    this.BuildComponent(this.components, "Domain 2", false);
    this.BuildComponent(this.components, "Domain 3", false);
    this.BuildComponent(this.components, "Domain 4", false);
    this.BuildComponent(this.components, "Domain 5", false);
    this.BuildComponent(this.components, "Discussing end results with CU", false);
    this.BuildComponent(this.components, "Other (specify)", true);
    this.BuildComponent(this.components, "Additional Other (specify)", true);

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
  BuildComponent(components: AdminTableData[], componentName: string, hasSpecifyField: boolean) {
    const comp = new AdminTableData();
    comp.component = componentName;
    comp.documentationHours = 0;
    comp.interviewHours = 0;
    comp.statementsReviewed = 0;
    comp.hasSpecifyField = hasSpecifyField;
    components.push(comp);
  }
}
