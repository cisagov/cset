////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { AnalysisService } from '../services/analysis.service';
import { ReportService } from '../services/report.service';
import { ReportsConfigService } from '../services/config.service';
import { Title } from '@angular/platform-browser';
import { AcetDashboard } from '../../../../../src/app/models/acet-dashboard.model';
import { AdminTableData, AdminPageData, HoursOverride } from '../../../../../src/app/models/admin-save.model';
import { ACETService } from '../../../../../src/app/services/acet.service';

@Component({
  selector: 'rapp-sitesummary',
  templateUrl: './sitesummary.component.html',
  styleUrls: ['./sitesummary.component.scss']
})
export class SitesummaryComponent implements OnInit, AfterViewChecked {
  chartStandardsSummary: Chart;
  chartRankedSubjectAreas: Chart;
  chartPercentCompliance: Chart;
  chartStandardResultsByCategory: Chart;
  response: any;
  responseResultsByCategory: any;

  // FIPS SAL answers
  nistSalC = '';
  nistSalI = '';
  nistSalA = '';


  chart1: Chart;
  numberOfStandards = -1;
  complianceGraphs: any[] = [];

  pageInitialized = false;

  // ACET data
  matDetails: any;
  acetDashboard: AcetDashboard;
  Components: AdminTableData[];
  adminPageData: AdminPageData;
  GrandTotal: number;
  DocumentationTotal: number;
  InterviewTotal: number;
  ReviewedStatementTotal: number;


  constructor(
    public reportSvc: ReportService,
    public analysisSvc: AnalysisService,
    public configSvc: ReportsConfigService,
    private titleService: Title,
    public acetSvc: ACETService
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Site Summary Report - CSET");

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

    this.analysisSvc.getDashboard().subscribe(x => {
      this.chartPercentCompliance = this.analysisSvc.buildPercentComplianceChart('canvasCompliance', x);
    });


    this.analysisSvc.getStandardsSummaryOverall().subscribe(x => {
      this.chartStandardsSummary = this.analysisSvc.buildStandardsSummary('canvasStandardsSummary', x);
    });


    this.analysisSvc.getStandardsResultsByCategory().subscribe(x => {
      this.responseResultsByCategory = x;

      // Standard or Question Set (multi-bar graph)
      this.chartStandardResultsByCategory = this.analysisSvc.buildStandardResultsByCategoryChart('chartStandardResultsByCategory', x);

      // Set up arrays for green bar graphs
      this.numberOfStandards = x.multipleDataSets.length;
      x.multipleDataSets.forEach(element => {
        this.complianceGraphs.push(element);
      });
    });

    this.analysisSvc.getOverallRankedCategories().subscribe(x => {
      this.chartRankedSubjectAreas = this.analysisSvc.buildRankedSubjectAreasChart('canvasRankedSubjectAreas', x);
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
    let i = 0;
    this.complianceGraphs.forEach(x => {
      this.chart1 = this.analysisSvc.buildRankedCategoriesChart("complianceGraph" + i++, x);
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

/*Analysis of Network Components */
var chart = new CanvasJS.Chart("chartContainer2",
    {
        animationEnabled: true,
        title: {
            text: "Combined Component Summary",
			backgroundColor: '#367190',
			fontFamily: 'Verdana',
			fontColor: 'white',
			fontSize: 16,
			padding: 7,
        },
        data: [
        {
            type: "pie",
            showInLegend: true,
            dataPoints: [
                { y: 75, legendText: "Yes", color: "#006000"},
                { y: 10, legendText: "No", color: "#990000"},
                { y: 5, legendText: "N/A", color: "rgb(0, 94, 166)"},
                { y: 5, legendText: "Alternate", color: "#F9CE15"},
                { y: 5, legendText: "Unanswered", color: "#bfbfbf"}
            ]
        },
        ]
    });
chart.render();
	
var chart = new CanvasJS.Chart("chartContainer4",
    {
        animationEnabled: true,
        title: {
            text: ""
        },
        axisX: {
            interval: 10,	
        },
        data: [
        {
            type: "stackedBar",
            color: '#006000',
            showInLegend: false,
			label: 'Yes',
			fontFamily: 'Verdana',
			fontSize: '16',
            dataPoints: [
                { x: 160, y: 75, label: "Active Directory" },
                { x: 150, y: 75, label: "DB Server" },
                { x: 140, y: 75, label: "Firewall" },
                { x: 130, y: 75, label: "Handheld Wireless Device" },
                { x: 120, y: 75, label: "HMI" },
                { x: 110, y: 75, label: "IDS" },
                { x: 100, y: 75, label: "IP Camera" },
                { x: 90, y: 75, label: "IP Phone" },
			        	{ x: 80, y: 75, label: "Network Printer" },
			        	{ x: 70, y: 75, label: "Optical Ring" },
			        	{ x: 60, y: 75, label: "RAS" },
			        	{ x: 50, y: 75, label: "Router" },
			         	{ x: 40, y: 75, label: "Server" },
			        	{ x: 30, y: 75, label: "Switch" },
			        	{ x: 20, y: 75, label: "Terminal Server" },
			        	{ x: 10, y: 75, label: "Wireless Modem" }
            ]
        }, {
            type: "stackedBar",
            color: '#990000',
            showInLegend: false,
			label: 'No',
            dataPoints: [
                { x: 160, y: 10, label: "Active Directory" },
                { x: 150, y: 10, label: "DB Server" },
                { x: 140, y: 10, label: "Firewall" },
                { x: 130, y: 10, label: "Handheld Wireless Device" },
                { x: 120, y: 10, label: "HMI" },
                { x: 110, y: 10, label: "IDS" },
                { x: 100, y: 10, label: "IP Camera" },
                { x: 90, y: 10, label: "IP Phone" },
			        	{ x: 80, y: 10, label: "Network Printer" },
			        	{ x: 70, y: 10, label: "Optical Ring" },
			        	{ x: 60, y: 10, label: "RAS" },
			        	{ x: 50, y: 10, label: "Router" },
			        	{ x: 40, y: 10, label: "Server" },
			        	{ x: 30, y: 10, label: "Switch" },
			        	{ x: 20, y: 10, label: "Terminal Server" },
			        	{ x: 10, y: 10, label: "Wireless Modem" }
            ]
        }, {
            type: "stackedBar",
            color: 'rgb(0, 94, 166)',
            showInLegend: false,
			label: 'N/A',
            dataPoints: [
                { x: 160, y: 5, label: "Active Directory" },
                { x: 150, y: 5, label: "DB Server" },
                { x: 140, y: 5, label: "Firewall" },
                { x: 130, y: 5, label: "Handheld Wireless Device" },
                { x: 120, y: 5, label: "HMI" },
                { x: 110, y: 5, label: "IDS" },
                { x: 100, y: 5, label: "IP Camera" },
                { x: 90, y: 5, label: "IP Phone" },
			        	{ x: 80, y: 5, label: "Network Printer" },
			        	{ x: 70, y: 5, label: "Optical Ring" },
			        	{ x: 60, y: 5, label: "RAS" },
			        	{ x: 50, y: 5, label: "Router" },
			         	{ x: 40, y: 5, label: "Server" },
			        	{ x: 30, y: 5, label: "Switch" },
			        	{ x: 20, y: 5, label: "Terminal Server" },
			        	{ x: 10, y: 5, label: "Wireless Modem" }
            ]
        }, {
            type: "stackedBar",
            color: '#F9CE15',
            showInLegend: false,
			label: 'Alternate',
            dataPoints: [
                { x: 160, y: 5, label: "Active Directory" },
                { x: 150, y: 5, label: "DB Server" },
                { x: 140, y: 5, label: "Firewall" },
                { x: 130, y: 5, label: "Handheld Wireless Device" },
                { x: 120, y: 5, label: "HMI" },
                { x: 110, y: 5, label: "IDS" },
                { x: 100, y: 5, label: "IP Camera" },
                { x: 90, y: 5, label: "IP Phone" },
			        	{ x: 80, y: 5, label: "Network Printer" },
			        	{ x: 70, y: 5, label: "Optical Ring" },
			        	{ x: 60, y: 5, label: "RAS" },
			        	{ x: 50, y: 5, label: "Router" },
			        	{ x: 40, y: 5, label: "Server" },
			        	{ x: 30, y: 5, label: "Switch" },
			        	{ x: 20, y: 5, label: "Terminal Server" },
			        	{ x: 10, y: 5, label: "Wireless Modem" }
            ]
        }, {
            type: "stackedBar",
            color: '#bfbfbf',
            showInLegend: false,
			label: 'Unanswered',
            dataPoints: [
                { x: 160, y: 5, label: "Active Directory" },
                { x: 150, y: 5, label: "DB Server" },
                { x: 140, y: 5, label: "Firewall" },
                { x: 130, y: 5, label: "Handheld Wireless Device" },
                { x: 120, y: 5, label: "HMI" },
                { x: 110, y: 5, label: "IDS" },
                { x: 100, y: 5, label: "IP Camera" },
                { x: 90, y: 5, label: "IP Phone" },
			        	{ x: 80, y: 5, label: "Network Printer" },
			        	{ x: 70, y: 5, label: "Optical Ring" },
			        	{ x: 60, y: 5, label: "RAS" },
			        	{ x: 50, y: 5, label: "Router" },
			        	{ x: 40, y: 5, label: "Server" },
			        	{ x: 30, y: 5, label: "Switch" },
			        	{ x: 20, y: 5, label: "Terminal Server" },
			        	{ x: 10, y: 5, label: "Wireless Modem" }
            ]
        }
        ]
    });
chart.render();

/*Component Compliance by Subject Area */
var chart = new CanvasJS.Chart("chartContainer1",
    {
        animationEnabled: true,
        title: {
            text: ""
        },
        axisX: {
            interval: 10,
        },
        data: [
            {
            type: "stackedBar",
            color: 'forestgreen',
            showInLegend: false,
			label: '',
            dataPoints: [
                { x: 250, y: 75, label: "Access Control" },
			        	{ x: 240, y: 60, label: "Acount Management" },
			        	{ x: 230, y: 80, label: "Audit and Accountability" },
			        	{ x: 220, y: 80, label: "Boundary Protection" },
			        	{ x: 210, y: 100, label: "Communication Protection" },
			        	{ x: 200, y: 90, label: "Configuration Management" },
			        	{ x: 190, y: 95, label: "Disaster Recovery" },
			        	{ x: 180, y: 85, label: "Encryption" },
			        	{ x: 170, y: 90, label: "Firewall" },
			        	{ x: 160, y: 90, label: "Logging" },
                { x: 150, y: 95, label: "Management" },
                { x: 140, y: 65, label: "Management Practices" },
                { x: 130, y: 85, label: "Password" },
                { x: 120, y: 75, label: "Physical Access" },
                { x: 110, y: 100, label: "Policies & Procedures General" },
                { x: 100, y: 100, label: "Portable/Mobile/Wireless" },
                { x: 90, y: 90, label: "Remote Access Control" },
			        	{ x: 80, y: 80, label: "Securing Content" },
			        	{ x: 70, y: 65, label: "Securing the Component" },
			        	{ x: 60, y: 80, label: "Securing the Router" },
			        	{ x: 50, y: 75, label: "Securing the System" },
			        	{ x: 40, y: 95, label: "System and Communications Protection" },
			        	{ x: 30, y: 90, label: "System Integrity" },
			        	{ x: 20, y: 100, label: "System Protections" },
			        	{ x: 10, y: 100, label: "User Authentication" }
            ]
        }
        ]
    });
chart.render();