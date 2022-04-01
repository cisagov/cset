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
import { Chart } from 'chart.js';
@Component({
  selector: 'app-maturity-questions-cis',
  templateUrl: './maturity-questions-cis.component.html'
})
export class MaturityQuestionsCisComponent implements OnInit {

  section: QuestionGrouping;
  sectionId: Number;

  sectionScore: Number;
  chartScore: Chart;

  loaded = false;

  constructor(
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public questionsSvc: QuestionsService,
    public filterSvc: QuestionFilterService,
    public navSvc: NavigationService,
    public chartSvc: ChartService,
    private dialog: MatDialog,
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

    // TEMP - need to listen to a score event emitted from somebody....
    this.sectionScore = Math.random() * 100;

    this.refreshChart();
  }
  
  /**
   * Loads the question structure for the current 'section'
   */
  loadQuestions(): void {
    this.section = null;
    this.sectionId = +this.route.snapshot.params['sec'];

    const magic = this.navSvc.getMagic();
    
    this.maturitySvc.getCisSection(this.sectionId).subscribe(
      (response: any) => {
        if (response.groupings.length > 0) {
          this.section = response.groupings[0];
        }
        this.loaded = true;
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
   * 
   */
  refreshChart() {
    let x = {
      labels: [''],
      datasets: [{
        label: 'Your Score',
        data: [this.sectionScore],
        backgroundColor: [
          '#386FB3'
        ],
        borderColor: [
          '#386FB3'
        ],
        borderWidth: 1
      }]
    };

    this.chartScore = this.chartSvc.buildHorizBarChart('canvasScore', x, true, true, {legendPosition: 'right'});
  }

}
