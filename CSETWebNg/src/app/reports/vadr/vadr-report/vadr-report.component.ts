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
import { Component, OnInit, ElementRef, ViewChild } from '@angular/core';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';
import { Title } from '@angular/platform-browser';
import { CmmcStyleService } from '../../../services/cmmc-style.service';
import { BehaviorSubject } from 'rxjs';
import Chart from 'chart.js/auto';
import { ConfigService } from '../../../services/config.service';
import { VadrDataService } from '../../../services/vadr-data.service';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'app-vadr-report',
  templateUrl: './vadr-report.component.html',
  styleUrls: ['../../reports.scss']
  // styleUrls: ['./vadr-report.component.scss']
})
export class VadrReportComponent implements OnInit {
  mainResponse: any;
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
  colorScheme1 = { domain: ['#007BFF'] };
  colorSchemeRed = { domain: ['#DC3545'] };
  answerDistribColorScheme = { domain: ['#28A745', '#DC3545', '#FFC107', '#c8c8c8'] };

  complianceGraph1 = [];
  answerDistribByGoal = [];
  topRankedGoals = [];


  questionReferenceTable = [];

  xAxisTicks = [0, 25, 50, 75, 100];

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
    public vadrDataSvc: VadrDataService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService
  ) {
    this.columnWidthEmitter = new BehaviorSubject<number>(25)
  }

  /**
   *
   */
  ngOnInit() {
    this.maturitySvc.getMaturityDeficiency("VADR").subscribe(
      (r: any) => {
        this.response = r;
        // remove any child questions - they are not Y/N
        this.response.deficienciesList = this.response.deficienciesList.filter(x => x.mat.parent_Question_Id == null);
      },
      error => console.log('Deficiency Report Error: ' + (<Error>error).message)
    );

    // Standards Summary (pie or stacked bar)
    // get the chart raw data and build objects to populate charts
    this.vadrDataSvc.getVADRDetail().subscribe((r: any) => {
      // this should be called first because it creates a normalized object that others use
      this.createAnswerDistribByGoal(r);

      this.createChart1(r);

      this.createTopRankedGoals(r);
    },
      error => console.log('Main RRA report load Error: ' + (<Error>error).message)
    );


    // get the question/reference data
    this.vadrDataSvc.getVADRQuestions().subscribe((r: any) => {
      this.createQuestionReferenceTable(r);
    });


    this.titleService.setTitle("Validated Architecture Design Review Report - VADR");

    this.vadrDataSvc.getReport('vadrmain').subscribe(
      (r: any) => {
        this.mainResponse = r;
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

    const yesPercent = r.vadrSummaryOverall.find(x => x.answer_Text == 'Y').percent;
    const altPercent = r.vadrSummaryOverall.find(x => x.answer_Text == 'A').percent;

    var overall = {
      name: 'Overall',
      value: Math.round(yesPercent + altPercent)
    };
    levelList.push(overall);

    this.complianceGraph1 = levelList;
  }


  /**
   * Builds the answer distribution broken into goals.
   */
  createAnswerDistribByGoal(r: any) {
    let goalList = [];

    // sort by title for readability
    r.vadrSummaryByGoal.sort((a, b) => {
      if (a.title < b.title) {
        return -1;
      }
      if (a.title > b.title) {
        return 1;
      }
      return 0;
    });

    r.vadrSummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.title);
      if (!goal) {
        goal = {
          name: element.title, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Alternate', value: 0 },
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
      var altPercent = element.series.find(x => x.name == 'Alternate').value;

      var goal = {
        name: element.name, value: (100 - Math.round(yesPercent + altPercent))
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

    this.vadrDataSvc.getVADRQuestions().subscribe((r: any) => {
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
