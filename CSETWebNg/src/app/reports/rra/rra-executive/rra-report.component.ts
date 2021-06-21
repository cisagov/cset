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
  answerCountsByLevel = [];
  answerDistribByLevel = [];
  complianceByGoal = [];
  topRankedGoals = [];

  goalTable = [];

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

  ngOnInit() {


    // Standards Summary (pie or stacked bar)    
    this.chartStandardsSummary = this.analysisSvc
      .buildStandardsSummary('canvasStandardSummary', this.standardSummaryData);

    this.rraDataSvc.getRRADetail().subscribe(
      (r: any) => {
        this.response = r;

        this.createChart1(r);

        this.createAnswerDistribByGoal(r);

        this.createAnswerCountsByLevel(r);
        this.createAnswerDistribByLevel(r);

        this.createComplianceByGoal(r);
        this.createTopRankedGoals(r);

        this.createGoalTable(r);
      },
      error => console.log('Main RRA report load Error: ' + (<Error>error).message)
    );



    this.titleService.setTitle("Ransomware Readiness Report - CSET");

    this.reportSvc.getReport('rramain').subscribe(
      (r: any) => {
        this.response = r;
        console.log(r);
      },
      error => console.log('Main RRA report load Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   * @param a 
   * @returns 
   */
  getComplianceScore(a: string) {
    const g = this.complianceGraph1.find(x => x.name == a);
    if (!!g) {
      return g.value;
    }
    return '!!!';
  }

  /**
   * 
   * @param r 
   */
  createChart1(r: any) {

    // RRASummaryOverall
    let levelList = [];
    var overall = { 'name': 'Overall', value: 0 };
    levelList.push(overall);


    r.RRASummary.forEach(element => {
      let level = levelList.find(x => x.name == element.Level_Name);
      if (!level) {
        level = {
          'name': element.Level_Name, value: 0
        };
        levelList.push(level);
      }

      if (element.Answer_Text == 'Y') {
        level.value = level.value + element.Percent;
        overall.value = overall.value + element.Percent;
      }
    });

    this.complianceGraph1 = levelList;
  }

  //Pyramid Chart
  getPyramidRowColor(level) {
    let backgroundColor = this.getGradient("blue", .1);
    let textColor = "white";
    return {
      background: backgroundColor,
      color: 'white',
      height: '48px',
      padding: '12px 0'
    };
  }

  getGradient(color, alpha = 1, reverse = false) {
    let vals = {
      color_one: "",
      color_two: ""
    }
    alpha = 1
    switch (color) {
      case "blue":
      case "blue-1": {
        vals["color_one"] = `rgba(31,82,132,${alpha})`
        vals["color_two"] = `rgba(58,128,194,${alpha})`
        break;
      }
      case "blue-2": {
        vals["color_one"] = `rgba(75,116,156,${alpha})`
        vals["color_two"] = `rgba(97,153,206,${alpha})`
        break;
      }
      case "blue-3": {
        vals["color_one"] = `rgba(120,151,156,${alpha})`
        vals["color_two"] = `rgba(137,179,218,${alpha})`
        break;
      }
      case "blue-4": {
        vals["color_one"] = `rgba(165,185,205,${alpha})`
        vals["color_two"] = `rgba(176,204,230,${alpha})`
        break;
      }
      case "blue-5": {
        vals["color_one"] = `rgba(210,220,230,${alpha})`
        vals["color_two"] = `rgba(216,229,243,${alpha})`
        break;
      }
      case "green": {
        vals["color_one"] = `rgba(98,154,109,${alpha})`
        vals["color_two"] = `rgba(31,77,67,${alpha})`
        break;
      }
      case "grey": {
        vals["color_one"] = `rgba(98,98,98,${alpha})`
        vals["color_two"] = `rgba(120,120,120,${alpha})`
        break;
      }
      case "orange": {
        vals["color_one"] = `rgba(255,190,41,${alpha})`
        vals["color_two"] = `rgba(224,217,98,${alpha})`
        break;
      }
    }
    if (reverse) {
      let tempcolor = vals["color_one"]
      vals["color_one"] = vals["color_two"]
      vals["color_two"] = tempcolor
    }
    return `linear-gradient(5deg,${vals['color_one']} 0%, ${vals['color_two']} 100%)`
  }

  /**
   *
   */
  buildSummaryDoughnut(canvasId: string, x: any) {
    return new Chart(canvasId, {
      type: 'doughnut',
      data: {
        labels: [
          this.configSvc.answerLabels['Y'],
          this.configSvc.answerLabels['N'],
          this.configSvc.answerLabels['U']
        ],
        datasets: [
          {
            label: x.label,
            data: x.data,
            backgroundColor: x.Colors
          }
        ],
      },
      options: {
        tooltips: {
          callbacks: {
            label: ((tooltipItem, data) =>
              data.labels[tooltipItem.index] + ': ' + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%')
          }
        },
        title: {
          display: false,
          fontSize: 20,
          text: 'Summary'
        },
        legend: {
          display: true,
          position: 'bottom',
          labels: {
            generateLabels: function (chart) { // Add values to legend labels
              const data = chart.data;
              if (data.labels.length && data.datasets.length) {
                return data.labels.map(function (label, i) {
                  const meta = chart.getDatasetMeta(0);
                  const ds = data.datasets[0];
                  const arc = meta.data[i];
                  const getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
                  const arcOpts = chart.options.elements.arc;
                  const fill = getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
                  const stroke = getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
                  const bw = getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
                  let value = '';
                  if (!!arc) {
                    value = chart.config.data.datasets[arc._datasetIndex].data[arc._index].toString();
                  }
                  return {
                    text: label + ' : ' + value + '%',
                    fillStyle: fill,
                    strokeStyle: stroke,
                    lineWidth: bw,
                    hidden: isNaN(<number>ds.data[i]) || meta.data[i].hidden,
                    index: i
                  };
                });
              } else {
                return [];
              }
            }
          }
        },
        circumference: Math.PI,
        rotation: -Math.PI
      }
    });
  }


  /**
   * Builds the answer distribution broken into goals.
   * TODO:  Sort these in display order in the API before returning.
   */
  createAnswerDistribByGoal(r: any) {
    let goalList = [];
    r.RRASummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.Title);
      if (!goal) {
        goal = {
          'name': element.Title, series: [
            { 'name': 'Yes', value: '' },
            { 'name': 'No', value: '' },
            { 'name': 'Unanswered', value: '' },
          ]
        };
        goalList.push(goal);
      }

      var p = goal.series.find(x => x.name == element.Answer_Full_Name);
      p.value = element.Percent;
    });

    this.answerDistribByGoal = goalList;
    console.log(this.answerDistribByGoal);
  }


  /**
   * 
   * @param r 
   */
  createAnswerCountsByLevel(r: any) {
    let levelList = [];

    r.RRASummary.forEach(element => {
      let level = levelList.find(x => x.name == element.Level_Name);
      if (!level) {
        level = {
          'name': element.Level_Name, series: [
            { 'name': 'Yes', value: '' },
            { 'name': 'No', value: '' },
            { 'name': 'Unanswered', value: '' },
          ]
        };
        levelList.push(level);
      }

      var p = level.series.find(x => x.name == element.Answer_Full_Name);
      p.value = element.qc;
    });

    this.answerCountsByLevel = levelList;
  }

  /**
   * 
   */
  createAnswerDistribByLevel(r: any) {
    let levelList = [];
    r.RRASummary.forEach(element => {
      let level = levelList.find(x => x.name == element.Level_Name);
      if (!level) {
        level = {
          'name': element.Level_Name, series: [
            { 'name': 'Yes', value: '' },
            { 'name': 'No', value: '' },
            { 'name': 'Unanswered', value: '' },
          ]
        };
        levelList.push(level);
      }

      var p = level.series.find(x => x.name == element.Answer_Full_Name);
      p.value = element.Percent;
    });

    this.answerDistribByLevel = levelList;
  }

  /**
   * 
   * @param r 
   */
  createComplianceByGoal(r: any) {
    let goalList = [];
    r.RRASummaryByGoalOverall.forEach(element => {
      var goal = {
        'name': element.Title, 'value': element.Percent
      };
      goalList.push(goal);
    });

    this.complianceByGoal = goalList;
  }

  /**
   * Build a chart sorting the least-compliant goals to the top.
   * @param r 
   */
  createTopRankedGoals(r: any) {
    let goalList = [];
    r.RRASummaryByGoalOverall.forEach(element => {
      var goal = {
        'name': element.Title, 'value': (100 - element.Percent)
      };
      goalList.push(goal);
    });

    goalList.sort((a, b) => { return b.value - a.value; });

    this.topRankedGoals = goalList;
  }

  /**
   * Build an array used to populate the 'RRA Questions Scoring' table
   */
  createGoalTable(r: any) {
    let goalList = [];
    r.RRASummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.Title);
      if (!goal) {
        goal = {
          name: element.Title,
          yes: 0,
          no: 0,
          unanswered: 0
        };
        goalList.push(goal);
      }

      switch (element.Answer_Text) {
        case 'Y':
          goal.yes = element.qc;
            break;
        case 'N':
          goal.no = element.qc;
          break;
        case 'U':
          goal.unanswered = element.qc
          break;
      }
    });

    goalList.forEach(g => {
      g.total = g.yes + g.no + g.unanswered;
      g.percent = ((g.yes / g.total) * 100).toFixed(1);
    });

    this.goalTable = goalList;
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
