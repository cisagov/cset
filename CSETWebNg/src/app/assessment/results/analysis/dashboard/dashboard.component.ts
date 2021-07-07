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
import { Component, OnInit } from '@angular/core';
import { Chart } from 'chart.js';
import { Router } from '../../../../../../node_modules/@angular/router';
import { AssessmentService } from '../../../../services/assessment.service';
import { AnalysisService } from './../../../../services/analysis.service';
import { ConfigService } from '../../../../services/config.service';
import { NavigationService } from '../../../../services/navigation.service';
declare var $: any;

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class DashboardComponent implements OnInit {

  overallScoreDisplay: string;
  standardBasedScore: number;
  standardBasedScoreDisplay: string;
  componentBasedScore: number;
  componentBasedScoreDisplay: string;

  assessComplChart: Chart;
  topCategChart: Chart;
  stdsSummChart: Chart = null;
  compSummChart: Chart = null;
  compSummInitialized = false;
  componentCount = 0;
  initialized = false;

  constructor(
    private analysisSvc: AnalysisService,
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    private router: Router) { }

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
    this.standardBasedScoreDisplay = this.standardBasedScore > 0 ? this.standardBasedScore.toFixed(0) + '%' : 'No Standards Answers';

    this.componentBasedScore = this.getScore(x.overallBars, 'Components');
    this.componentBasedScoreDisplay = this.componentBasedScore > 0 ? this.componentBasedScore.toFixed(0) + '%' : 'No Components Answers';


    // Assessment Compliance
    this.assessComplChart = this.analysisSvc.buildPercentComplianceChart('canvasAssessmentCompliance', x);


    // Top Categories (only show the top 5 entries for dashboard)
    this.analysisSvc.getTopCategories(5).subscribe(resp => {
      this.topCategChart = this.analysisSvc.buildTopCategories('canvasTopCategories', resp);
    });


    // Standards Summary
    this.analysisSvc.getStandardsSummary().subscribe(resp => {
      this.stdsSummChart = this.analysisSvc.buildStandardsSummary('canvasStandardSummary', resp);
    });


    // Component Summary
    this.analysisSvc.getComponentsSummary().subscribe(resp => {
      this.componentCount = resp.componentCount;
      this.compSummInitialized = true;
      if (this.componentCount > 0) {
        setTimeout(() => {
          this.compSummChart = this.analysisSvc.buildComponentsSummary('canvasComponentSummary', resp);
        }, 10);
      }
    });

    this.initialized = true;
  }


  /**
   * Returns the 'data' element that corresponds to the position of the 'Label.'
   * @param overallBars
   */
  getScore(overallBars, label) {
    for (let i = 0; i < overallBars.labels.length; i++) {
      if (overallBars.labels[i].toLowerCase() === label.toLowerCase()) {
        return overallBars.data[i];
      }
    }

    return 0;
  }
}
