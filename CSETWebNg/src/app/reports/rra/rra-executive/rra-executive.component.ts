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
  selector: 'executive',
  templateUrl: './rra-executive.component.html', 
  styleUrls: ['../../reports.scss']
})
export class RraExecutiveComponent implements OnInit, AfterViewChecked {
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
  
  

  responseResultsByCategory = {"dataSets":[{"dataSets":[],"label":"RRA Basic",
  "backgroundColor":"#0000FF","borderColor":null,"borderWidth":null,
  "data":[80.0,80.0, 83.333, 100.0, 0.0, 0.0, 100.0, 100.0, 100.0, 33.333],
  "Labels":["Robust Data Backup",
  "Web Browser Management and DNS Filtering",
  "Network Perimeter Monitoring",
  "Phishing Prevention and Awareness",
  "Patch and Update Management",
  "User and Access Management",
  "Application Integrity",
  "Incident Response",
  "Risk Management",
  "Asset Management"],"ComponentCount":0,"DataRows":[],"DataRowsPie":null,"Colors":null}]};



  standardSummaryData = {"dataSets":[],"label":"Standards Summary",
  "backgroundColor":null,"borderColor":"transparent","borderWidth":"0",
  "data":[33,19.0,23.0,30.0,0.0],"Labels":["Yes","No","Unanswered"],"ComponentCount":0,"DataRows":[],"DataRowsPie":[{"Answer_Full_Name":"Yes","Short_Name":"CFATS","Answer_Text":"Y","qc":16,"Total":57,"Percent":28,"Answer_Order":null},{"Answer_Full_Name":"No","Short_Name":"CFATS","Answer_Text":"N","qc":11,"Total":57,"Percent":19,"Answer_Order":null},{"Answer_Full_Name":"Not Applicable","Short_Name":"CFATS","Answer_Text":"NA","qc":13,"Total":57,"Percent":23,"Answer_Order":null},{"Answer_Full_Name":"Alternate","Short_Name":"CFATS","Answer_Text":"A","qc":17,"Total":57,"Percent":30,"Answer_Order":null},{"Answer_Full_Name":"Unanswered","Short_Name":"CFATS","Answer_Text":"U","qc":0,"Total":0,"Percent":0,"Answer_Order":null}],"Colors":["#006000","#990000","#0063B1","#B17300","#CCCCCC"]};

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
    
    
    //  // Top Categories (only show the top 5 entries for dashboard)
    //  this.analysisSvc.getTopCategories(5).subscribe(resp => {
    //   this.topCategChart = this.analysisSvc.buildTopCategories('canvasTopCategories', resp);
    // });

    this.titleService.setTitle("Executive Summary RRA - CSET");

    this.response = this.rraDataSvc.getData();
    // this.reportSvc.getReport('rraexecutive').subscribe(
    //   (r: any) => {
    //     this.response = r;
    //   },
    //   error => console.log('Executive report load Error: ' + (<Error>error).message)
    // );
    this.columnWidthEmitter.subscribe(item => {
      $(".gridCell").css("width",`${item}px`)
    });
  }

  ngAfterViewInit(){
    this.getcolumnWidth();
  }

  ngAfterViewChecked() {
    this.getcolumnWidth();    
  }
  //horizontalDomainBarChat
  getcolumnWidth(){    
    this.columnWidthPx = this.gridChartData.nativeElement.clientWidth / this.gridColumns.length;
    this.columnWidthEmitter.next(this.columnWidthPx)
  }
  getBarWidth(data){
    return { 
      'flex-grow': data.questionAnswered / data.questionCount,
      'background': this.cmmcStyleSvc.getGradient("blue")
    }
  }

  @HostListener ('window:resize',['$event'])
  onResize(event) {
    this.getcolumnWidth();
  }

  //Pyramid Chart
  getPyramidRowColor(level) {
    let backgroundColor = this.getGradient("blue", .1);
    let textColor = "white";    
    return {          
      background: backgroundColor,
      color: 'white',
      height:'48px',
      padding:'12px 0'
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
}
