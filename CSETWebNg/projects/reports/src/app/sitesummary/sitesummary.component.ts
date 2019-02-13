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
import { Component, OnInit, AfterViewChecked } from '@angular/core';
import { AnalysisService } from '../services/analysis.service';
import { ReportService } from '../services/report.service';
import { Title } from '@angular/platform-browser';

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


  constructor(private reportSvc: ReportService, public analysisSvc: AnalysisService, private titleService: Title) { }

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
}
