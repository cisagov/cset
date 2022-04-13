////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, NavigationEnd, Router, RouterEvent } from '@angular/router';
import { QuestionGrouping } from '../../../../models/questions.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { QuestionFilterService } from '../../../../services/filtering/question-filter.service';
import { MaturityService } from '../../../../services/maturity.service';
import { NavigationService } from '../../../../services/navigation.service';
import { QuestionsService } from '../../../../services/questions.service';
import { ChartService } from '../../../../services/chart.service';
import { BubbleController, Chart } from 'chart.js';
import { CisService } from '../../../../services/cis.service';
@Component({
  selector: 'app-maturity-questions-cis',
  templateUrl: './maturity-questions-cis.component.html'
})
export class MaturityQuestionsCisComponent implements OnInit {

  section: QuestionGrouping;
  sectionId: Number;

  chartScore: Chart;
  scoreObject: any;
  sectionScore: Number;

  loaded = false;

  constructor(
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public questionsSvc: QuestionsService,
    public filterSvc: QuestionFilterService,
    public navSvc: NavigationService,
    public chartSvc: ChartService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    router.events.subscribe((event) => {
      if (event instanceof NavigationEnd) {
        this.loadQuestions();
      }
    });
  }

  /**
   * 
   */
  ngOnInit(): void {
    this.loadQuestions();

    // listen for score changes caused by questions being answered
    this.cisSvc.cisScore.subscribe((s: number) => {
      this.sectionScore = s;
      this.refreshChart();
    });
  }

  /**
   * Loads the question structure for the current 'section'
   */
  loadQuestions(): void {
    this.section = null;
    this.sectionId = +this.route.snapshot.params['sec'];

    const magic = this.navSvc.getMagic();

    this.cisSvc.getCisSection(this.sectionId).subscribe(
      (response: any) => {
        if (response.groupings.length > 0) {
          this.section = response.groupings[0];
          this.scoreObject = response.groupingScore;
          this.sectionScore = this.scoreObject.groupingScore;
        }

        this.loaded = true;

        this.refreshChart();
      },
      error => {
        console.log(
          'Error getting questions: ' +
          (<Error>error).name +
          (<Error>error).message
        );
        console.log('Error getting questions: ' + (<Error>error).stack);
      }
    );
  }

  /**
   * Refresh the score chart based on the current section score.
   */
  refreshChart() {
    let x = {
      labels: [''],
      datasets: [
        //{
        //  type: 'scatter',
        //  label: 'Comparison High',
        //  pointStyle: 'triangle',
        //  data: [{ x: this.scoreObject?.high, y: 40 }],
        //  radius: 10,
        //  backgroundColor: '#66fa55'
        //},
        //{
        //  type: 'scatter',
        //  label: 'Comparison Median',
        //  radius: 8,
        //  data: [{ x: this.scoreObject?.median, y: 50 }],
        //  backgroundColor: '#fefd54'
        //},
        //{
        //  type: 'scatter',
        // label: 'Comparison Low',
        //  data: [{ x: this.scoreObject?.low, y: 60 }],
        //  pointStyle: 'triangle',
        //  rotation: 180,
        //  radius: 10,
        //  backgroundColor: '#e33e23'
        //},
        {
          type: 'bar',
          label: 'Your Score',
          data: [this.sectionScore],
          backgroundColor: ['#007BFF']
        }]
    };

    let opts = {
      scales: { y: { display: false } },
      plugins: {
        legend: { position: 'right' }
      }
    };

    setTimeout(() => {
      this.chartScore = this.chartSvc.buildHorizBarChart('canvasScore', x, true, true, opts);
      this.chartScore.update();
    }, 10);
    
  }
}
