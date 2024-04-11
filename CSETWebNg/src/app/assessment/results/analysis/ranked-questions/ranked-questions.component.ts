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
import { AssessmentService } from '../../../../services/assessment.service';
import { AnalysisService } from '../../../../services/analysis.service';
import { ConfigService } from '../../../../services/config.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { QuestionsService } from '../../../../services/questions.service';

@Component({
  selector: 'app-ranked-questions',
  templateUrl: './ranked-questions.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class RankedQuestionsComponent implements OnInit {
  dataRows: {
    rank: number;
    standard: string;
    category: string;
    questionRef: string;
    question: string;
    answerText: string;
    displayAnswer: string
  }[];
  initialized = false;
  docUrl: string;

  constructor(private analysisSvc: AnalysisService,
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public questionsSvc: QuestionsService,
    private configSvc: ConfigService) { }

  ngOnInit() {
    this.docUrl = this.configSvc.docUrl;
    this.analysisSvc.getRankedQuestions().subscribe(x => this.setupTable(x));
  }

  setupTable(data: any) {
    this.initialized = false;
    this.dataRows = data;

    let i = 1;
    for (const row of this.dataRows) {
      row.rank = i++;
      switch (row.answerText) {
        case 'U':
          row.displayAnswer = this.questionsSvc.answerDisplayLabel('', 'U');
          break;
        case 'N':
          row.displayAnswer = this.questionsSvc.answerDisplayLabel('', 'N');
          break;
      }
    }
    this.initialized = true;
  }
}
