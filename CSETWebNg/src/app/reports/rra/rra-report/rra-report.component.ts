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
import { Component, OnInit, ElementRef, ViewChild, HostListener } from '@angular/core';
import { ReportService } from '../../../services/report.service';
import { Title } from '@angular/platform-browser';
import { CmmcStyleService } from '../../../services/cmmc-style.service';
import { BehaviorSubject } from 'rxjs';
import { RraDataService } from '../../../services/rra-data.service';
import Chart from 'chart.js/auto';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'rra-report',
  templateUrl: './rra-report.component.html',
  styleUrls: ['../../reports.scss']
})
export class RraReportComponent implements OnInit {
  response: any;
  translationTabTitle: any;

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
  colorScheme1 = { domain: ['#007BFF'] };
  colorSchemeRed = { domain: ['#DC3545'] };
  answerDistribColorScheme = { domain: ['#28A745', '#DC3545', '#c8c8c8'] };

  complianceGraph1 = [];
  answerDistribByGoal = [];
  topRankedGoals = [];


  questionReferenceTable = [];

  xAxisTicks = [0, 25, 50, 75, 100];
  view: any[] = [800, 350];
  animation: boolean = false;

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
    private titleService: Title,
    public cmmcStyleSvc: CmmcStyleService,
    public rraDataSvc: RraDataService,
    public configSvc: ConfigService, 
    public tSvc: TranslocoService
  ) {
    this.columnWidthEmitter = new BehaviorSubject<number>(25)
  }

  /**
   *
   */
  ngOnInit() {
    // Standards Summary (pie or stacked bar)
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


    this.reportSvc.getReport('rramain').subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Main RRA report load Error: ' + (<Error>error).message)
    );

    this.translationTabTitle = this.tSvc.selectTranslate('reports.core.rra.tab title')
      .subscribe(value =>
        this.titleService.setTitle(this.tSvc.translate('reports.core.rra.tab title') + ' - ' + this.configSvc.behaviors.defaultTitle));
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
    for (let i of this.complianceGraph1){
      i.name = this.tSvc.translate('level.'+ i.name.toLowerCase())
     }
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
    for (let i of this.answerDistribByGoal){
      for (let j of i.series){
        j.name = this.tSvc.translate('answer-options.button-labels.'+ j.name.toLowerCase())
      }
    }
  }

  /**
   * Build a chart sorting the least-compliant goals to the top.
   * Must build answerDistribByGoal before calling this function.
   * @param r
   */
  createTopRankedGoals(r: any) {
    let goalList = [];
    this.answerDistribByGoal.forEach(element => {
      var yesPercent = element.series.find(x => x.name == this.tSvc.translate('answer-options.button-labels.yes')).value;
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

  @HostListener('window:beforeprint')
  beforePrint() {
    this.view = [1300, 600];
  }

  @HostListener('window:afterprint')
  afterPrint() {
    this.view = null;
  }
}
