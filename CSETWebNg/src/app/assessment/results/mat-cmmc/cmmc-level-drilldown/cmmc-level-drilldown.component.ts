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
import { Component, HostListener, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { MaturityService } from '../../../../../app/services/maturity.service';
import { ChartService } from '../../../../services/chart.service';
import { LayoutService } from '../../../../services/layout.service';
import { Chart } from 'chart.js';

@Component({
  selector: 'app-cmmc-level-drilldown',
  templateUrl: './cmmc-level-drilldown.component.html',
  styleUrls: ['../../../../../sass/cmmc-results.scss'],
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CmmcLevelDrilldownComponent implements OnInit {

  initialized = false;
  dataError = false;

  response: any;
  cmmcModel: any;
  statsByLevel: any;


  chartLevelScores: Chart;

  //Level descriptions for pie charts
  levelDescriptions = {
    1: "Safeguard Federal Contract Information (FCI)",
    2: "Serves as a transition step in cybersecurity maturity progression to protect CUI",
    3: "Protect Controlled Unclassified Information (CUI)",
    4: "Protect CUI and reduce risk of Advanced Persistent Threats (APTs)",
    5: "Protect CUI and reduce risk of Advanced Persistent Threats (APTs)",
  }

  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.renderPieCharts();
  }

  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    public chartSvc: ChartService,
    public layoutSvc: LayoutService
  ) { }


  ngOnInit(): void {
    this.maturitySvc.getResultsData('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;

        const modelCmmc = r.maturityModels?.find(m => m.maturityModelName === 'CMMC');
        this.cmmcModel = modelCmmc;
        this.statsByLevel = this.generateStatsByLevel(this.cmmcModel.statsByLevel);

        this.renderBarChart();

        this.renderPieCharts();

        this.initialized = true;
      },
      error => {
        this.dataError = true;
        this.initialized = true;
        console.log('CMMC level drilldown load Error: ' + (<Error>error).message);
      }
    ), (finish) => { };
  }

  /**
   * 
   */
  generateStatsByLevel(data) {
    let outputData = data?.filter(obj => obj.modelLevel != "Aggregate");
    outputData?.sort((a, b) => (a.modelLevel < b.modelLevel) ? 1 : -1);
    let totalAnsweredCount = 0;
    let totalUnansweredCount = 0;

    outputData?.forEach(element => {
      totalUnansweredCount += element.questionUnAnswered;
      totalAnsweredCount += element.questionAnswered;
      element["totalUnansweredCount"] = totalUnansweredCount;
      element["totalAnsweredCount"] = totalAnsweredCount;
    });

    return outputData;
  }

  /**
   * Build the data object to populate the level compliance bar chart.
   * Then build the chart.
   */
  renderBarChart() {
    let x = {
      labels: [],
      datasets: []
    };

    const ds = {
      type: 'bar',
      label: 'Level Compliance',
      data: [],
      backgroundColor: ['#1f5284']
    };
    x.datasets.push(ds);

    this.statsByLevel.forEach(l => {
      const levelScore = Math.round(l.questionAnswered / l.questionCount * 100);
      ds.data.push(levelScore);
      x.labels.push('Level ' + l.modelLevel);
    });

    let opts = {};

    setTimeout(() => {
      this.chartLevelScores = this.chartSvc.buildHorizBarChart('canvasLevelScores', x, false, true, opts, true);
    }, 800);
  }

  /**
   * 
   */
  renderPieCharts() {
    this.statsByLevel.forEach(level => {
      if (this.isWithinModelLevel(level)) {
        this.buildPieChart(level);
      }
    });
  }

  /**
   * Builds the data object for Chart
   */
  buildPieChart(level: any) {
    var x: any = {};
    x.label = '';
    x.labels = ['Compliant', 'Noncompliant'];
    x.data = [100 * (level.questionAnswered / level.questionCount), 100 * (level.questionUnAnswered / level.questionCount)];
    x.colors = [this.chartSvc.segmentColor('Y'), this.chartSvc.segmentColor('U')];

    var canvasId = 'level' + level.modelLevel;

    setTimeout(() => {
      level.chart = this.chartSvc.buildDoughnutChart(canvasId, x);
    }, 10);
  }

  /**
   * 
   */
  isWithinModelLevel(level) {
    if (level.modelLevel == 'CMMC') { return false; }
    let val = Number(level.modelLevel)
    if (!isNaN(val)) {
      if (val <= this.cmmcModel.targetLevel) {
        return true;
      }
    }
    return false;
  }

}
