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
import { Component, OnInit, AfterViewChecked, HostListener, ElementRef, ViewChild } from '@angular/core';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';
import { Title } from '@angular/platform-browser';
import { CmmcStyleService } from '../../../services/cmmc-style.service';
import { BehaviorSubject } from 'rxjs';
import { RraDataService } from '../../../services/rra-data.service';
import * as Chart from 'chart.js';
import { ConfigService } from '../../../services/config.service';

@Component({
  selector: 'rra-report',
  templateUrl: './rra-report.component.html',
  styleUrls: ['../../reports.scss']
})
export class RraReportComponent implements OnInit {
  response: any;

  overallScoreDisplay: string;
  standardBasedScore: number;
  standardBasedScoreDisplay: string;
  chartPercentCompliance: Chart;
  chartStandardsSummary: Chart;
  canvasStandardResultsByCategory: Chart;
  assessComplChart: Chart;
  topCategChart: Chart;
  stdsSummChart: Chart = null;

  // 
  colorScheme1 = { domain: ['#0A5278'] };
  colorSchemeRed = { domain: ['#9c0006'] };
  answerDistribColorScheme = { domain: ['#006100', '#9c0006', '#888888'] };

  complianceGraph1 = [];
  answerDistribByGoal = [];
  topRankedGoals = [];


  questionReferenceTable = [];

  xAxisTicks = [0, 25, 50, 75, 100];


  responseResultsByCategory = {
    "dataSets": [{
      "dataSets": [], "label": "RRA Basic",
      "backgroundColor": "#0000FF", "borderColor": null, "borderWidth": null,
      "data": [80.0, 80.0, 83.333, 100.0, 0.0, 0.0, 100.0, 100.0, 100.0, 33.333],
      "Labels": ["Robust Data Backup",
        "Web Browser Management and DNS Filtering",
        "Network Perimeter Monitoring",
        "Phishing Prevention and Awareness",
        "Patch and Update Management",
        "User and Access Management",
        "Application Integrity",
        "Incident Response",
        "Risk Management",
        "Asset Management"], "ComponentCount": 0, "DataRows": [], "DataRowsPie": null, "Colors": null
    }]
  };



  standardSummaryData = {
    "dataSets": [], "label": "Standards Summary",
    "backgroundColor": null, "borderColor": "transparent", "borderWidth": "0",
    "data": [33, 19.0, 23.0, 30.0, 0.0], "Labels": ["Yes", "No", "Unanswered"], "ComponentCount": 0, "DataRows": [], "DataRowsPie": [{ "Answer_Full_Name": "Yes", "Short_Name": "CFATS", "Answer_Text": "Y", "qc": 16, "Total": 57, "Percent": 28, "Answer_Order": null }, { "Answer_Full_Name": "No", "Short_Name": "CFATS", "Answer_Text": "N", "qc": 11, "Total": 57, "Percent": 19, "Answer_Order": null }, { "Answer_Full_Name": "Not Applicable", "Short_Name": "CFATS", "Answer_Text": "NA", "qc": 13, "Total": 57, "Percent": 23, "Answer_Order": null }, { "Answer_Full_Name": "Alternate", "Short_Name": "CFATS", "Answer_Text": "A", "qc": 17, "Total": 57, "Percent": 30, "Answer_Order": null }, { "Answer_Full_Name": "Unanswered", "Short_Name": "CFATS", "Answer_Text": "U", "qc": 0, "Total": 0, "Percent": 0, "Answer_Order": null }], "Colors": ["#006000", "#990000", "#0063B1", "#B17300", "#CCCCCC"]
  };

  // Charts for Components
  componentCount = 0;
  chartComponentSummary: Chart;
  chartComponentsTypes: Chart;
  warningCount = 0;
  chart1: Chart;

  numberOfStandards = -1;

  pageInitialized = false;


  columnWidthPx: number;
  gridColumnCount = 10
  gridColumns = new Array(this.gridColumnCount);
  columnWidthEmitter: BehaviorSubject<number>;
  @ViewChild("gridChartDataDiv") gridChartData: ElementRef;
  @ViewChild("gridTiles") gridChartTiles: Array<any>;

  constructor(
    public reportSvc: ReportService,
    private analysisSvc: ReportAnalysisService,
    private titleService: Title,
    public cmmcStyleSvc: CmmcStyleService,
    public rraDataSvc: RraDataService,
    private configSvc: ConfigService
  ) {
    this.columnWidthEmitter = new BehaviorSubject<number>(25)
  }

  /**
   * 
   */
  ngOnInit() {
    // Standards Summary (pie or stacked bar)    
    this.chartStandardsSummary = this.analysisSvc
      .buildStandardsSummary('canvasStandardSummary', this.standardSummaryData);

    // get the chart raw data and build objects to populate charts
    this.rraDataSvc.getRRADetail().subscribe((r: any) => {
      this.response = r;

      // this should be called first because it creates a normalized object that others use
      this.createAnswerDistribByGoal(r);

      this.createChart1(r);

      this.createTopRankedGoals(r);

    },
      error => console.log('Main RRA report load Error: ' + (<Error>error).message)
    );


    // get the question/reference data
    this.rraDataSvc.getRRAQuestions().subscribe((r: any) => {
      this.createQuestionReferenceTable(r);
    });


    this.titleService.setTitle("Ransomware Readiness Report - CSET");

    this.reportSvc.getReport('rramain').subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Main RRA report load Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   * @param a 
   * @returns 
   */
  getComplianceScore(a: string): Number {
    const g = this.complianceGraph1.find(x => x.name == a);
    if (!!g) {
      return g.value;
    }
    return -1;
  }

  /**
   * The horizontal bar chart representing performance for levels
   * near the top of the report.
   * @param r 
   */
  createChart1(r: any) {
    let levelList = [];

    var overall = { 
      name: 'Overall', 
      value: Math.round(r.rraSummaryOverall.find(x => x.answer_Text == 'Y').percent)
    };
    levelList.push(overall);


    r.rraSummary.forEach(element => {
      let level = levelList.find(x => x.name == element.level_Name);
      if (!level) {
        level = { name: element.level_Name, value: 0 };
        levelList.push(level);
      }

      if (element.answer_Text == 'Y') {
        level.value = level.value + Math.round(element.percent);
      }
    });

    this.complianceGraph1 = levelList;
  }


  /**
   * Builds the answer distribution broken into goals.
   */
  createAnswerDistribByGoal(r: any) {
    let goalList = [];
    r.rraSummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.title);
      if (!goal) {
        goal = {
          name: element.title, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Unanswered', value: 0 },
          ]
        };
        goalList.push(goal);
      }

      var p = goal.series.find(x => x.name == element.answer_Full_Name);
      p.value = element.percent;
    });

    this.answerDistribByGoal = goalList;
  }

  /**
   * Build a chart sorting the least-compliant goals to the top.
   * Must build answerDistribByGoal before calling this function.
   * @param r 
   */
  createTopRankedGoals(r: any) {
    let goalList = [];
    this.answerDistribByGoal.forEach(element => {
      var yesPercent = element.series.find(x => x.name == 'Yes').value;
      var goal = {
        name: element.name, value: (100 - Math.round(yesPercent))
      };
      goalList.push(goal);
    });

    goalList.sort((a, b) => { return b.value - a.value; });

    this.topRankedGoals = goalList;
  }
  
  /**
   * 
   */
  createQuestionReferenceTable(r: any) {
    this.questionReferenceTable = [];

    this.rraDataSvc.getRRAQuestions().subscribe((r: any) => {
      this.questionReferenceTable = r;
    });
  }

  /**
   * 
   * @returns 
   */
  zeroDeficiencies(): boolean {    
    return this.questionReferenceTable 
    && this.questionReferenceTable.length > 0
    && this.questionReferenceTable.every(q => q.answer.answer_Text == 'Y');
  }

  /**
    * 
    * @param x 
    * @returns 
    */
  formatPercent(x: any) {
    return x + '%';
  }
}
