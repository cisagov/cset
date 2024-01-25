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
import { QuestionsService } from './../../../../services/questions.service';
import { Component, Input, OnInit } from '@angular/core';
import { Question } from '../../../../models/questions.model';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-crr-results-detail',
  templateUrl: './crr-results-detail.component.html',
  styleUrls: ['../../../../reports/reports.scss']
})
export class CrrResultsDetailComponent implements OnInit {

  @Input()
  domain: any;

  constructor(
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService
  ) { }

  ngOnInit(): void {
  }


  /**
  * Sets the coloring of a cell based on its answer.
  * @param answer
  */
  answerCellClass(answer: string) {
    switch (answer) {
      case 'Y':
        return 'green-score';
      case 'I':
        return 'yellow-score';
      case 'N':
        return 'red-score';
      case 'U':
        return 'default-score';
    }
  }

  /**
   * Actually, "non-child questions"
   * @param q
   */
  parentQuestions(q: Question): Question[] {
    // q might be a single question or might be an array of questions
    var questions = [];

    if (q instanceof Array) {
      questions = q;
    } else {
      questions = [].concat(q);
    }

    return questions.filter(x => !x.parentquestionid);
  }

  /**
   * Until question numbers are broken out into their own data element,
   * we'll parse them from the question text.
   * @param q
   */
  getQuestionNumber(q: any): string {
    const dot = q.questiontext.trim().indexOf('.');
    if (dot < 0) {
      return "Q";
    }
    return "Q" + q.questiontext.trim().substring(0, dot);
  }

  /**
   *
   * @returns
   */
  getDomainRemark(remarks: string) {
    if (remarks?.trim().length > 0) {
      return this.reportSvc.formatLinebreaks(this.domain.remarks);
    }

    return 'No remarks have been entered';
  }
}
