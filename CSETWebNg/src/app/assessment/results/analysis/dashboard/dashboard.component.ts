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
import { Component, OnInit } from '@angular/core';
import Chart from 'chart.js/auto';
import { AssessmentService } from '../../../../services/assessment.service';
import { AnalysisService } from './../../../../services/analysis.service';
import { ConfigService } from '../../../../services/config.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { TranslocoService } from '@ngneat/transloco';
declare var $: any;

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class DashboardComponent implements OnInit {

  overallScoreDisplay: string;
  standardBasedScore: number;
  standardBasedScoreDisplay: string;
  componentBasedScore: number;
  componentBasedScoreDisplay: string;

  assessComplChart: Chart;
  showTopCategChart = false;
  topCategChart: Chart;
  stdsSummChart: Chart = null;
  compSummChart: Chart = null;
  compSummInitialized = false;
  componentCount = 0;
  initialized = false;

  constructor(
    private analysisSvc: AnalysisService,
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    private tSvc: TranslocoService) { }

  ngOnInit() {
    this.analysisSvc.getDashboard().subscribe(x => this.setupPage(x));

    // even up the score container widths
    $("#overall-score").css("width", $("#component-score").width() + "px");
  }


  setupPage(x: any) {
    this.initialized = false;

    // score boxes
    this.overallScoreDisplay = this.getScore(x.overallBars, 'Overall').toFixed(0) + '%';

    this.standardBasedScore = this.getScore(x.overallBars, 'Standards');
    this.standardBasedScoreDisplay = this.standardBasedScore > 0 ? 
      this.standardBasedScore.toFixed(0) + '%' : this.tSvc.translate('reports.core.dashboard.no standards answers');

    this.componentBasedScore = this.getScore(x.overallBars, 'Components');
    this.componentBasedScoreDisplay = this.componentBasedScore > 0 ? 
      this.componentBasedScore.toFixed(0) + '%' : this.tSvc.translate('reports.core.dashboard.no components answers');


    // Assessment Compliance
    if (this.assessComplChart) {
      this.assessComplChart.destroy();
    }
    this.assessComplChart = this.analysisSvc.buildPercentComplianceChart('canvasAssessmentCompliance', x);


    // Top Categories (only show the top 5 entries for dashboard)
    if (this.topCategChart) {
      this.topCategChart.destroy();
    }
    this.analysisSvc.getTopCategories(5).subscribe((resp: any) => {
      this.topCategChart = this.analysisSvc.buildTopCategories('canvasTopCategories', resp);

      // only show the chart if there is some non-zero data to show
      this.showTopCategChart = resp.data.some(x => x > 0);
    });


    // Standards Summary
    if (this.stdsSummChart) {
      this.stdsSummChart.destroy();
    }
    this.analysisSvc.getStandardsSummary().subscribe(resp => {
      this.stdsSummChart = <Chart>this.analysisSvc.buildStandardsSummary('canvasStandardSummary', resp);
    });


    // Component Summary
    if (this.compSummChart) {
      this.compSummChart.destroy();
    }
    this.analysisSvc.getComponentsSummary().subscribe(resp => {
      this.componentCount = resp.componentCount;
      this.compSummInitialized = true;
      if (this.componentCount > 0) {
        setTimeout(() => {
          this.compSummChart = <Chart>this.analysisSvc.buildComponentsSummary('canvasComponentSummary', resp);
        }, 10);
      }
    });

    this.initialized = true;
    setTimeout(function () {
      document.getElementById("analysisDiv").scrollIntoView();
    }, 250);
  }


  /**
   * Returns the 'data' element that corresponds to the position of the English 'Label.'
   * @param overallBars
   */
  getScore(overallBars, label) {
    for (let i = 0; i < overallBars.englishLabels.length; i++) {
      if (overallBars.englishLabels[i].toLowerCase() === label.toLowerCase()) {
        return overallBars.data[i];
      }
    }

    return 0;
  }
}
