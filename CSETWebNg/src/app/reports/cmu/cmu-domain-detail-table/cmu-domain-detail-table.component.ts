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
import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { Question } from '../../../models/questions.model';
import { QuestionsService } from '../../../services/questions.service';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportService } from '../../../services/report.service';
import { CmuService } from '../../../services/cmu.service';

@Component({
  selector: 'app-cmu-domain-detail-table',
  templateUrl: './cmu-domain-detail-table.component.html',
  styleUrls: ['./cmu-domain-detail-table.component.scss', '../../reports.scss']
})
export class CmuResultsDetailComponent implements OnChanges {
  @Input()
    moduleName: string;

  @Input()
    domain: any;

  @Input()
    showRemarks = true;

  heatmapWidget = '';

  constructor(
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    private cmuSvc: CmuService
  ) {}

  /**
   * Get the heatmap as soon as we have a domain
   */
  ngOnChanges(changes: SimpleChanges): void {
    if (changes.domain.firstChange) {
      this.cmuSvc.getDomainHeatmapWidget(this.domain.abbreviation).subscribe((resp: string) => {
        this.heatmapWidget = resp;
      });
    }
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
    let questions = [];

    if (q instanceof Array) {
      questions = q;
    } else {
      questions = [].concat(q);
    }

    return questions.filter((x) => !x.parentQuestionId);
  }

  /**
   * Until question numbers are broken out into their own data element,
   * we'll parse them from the question text.
   * @param q
   */
  getQuestionNumber(q: any): string {
    let dot = -1;

    // try the displaytext and parse off the "Qx" at the end
    dot = q.displayNumber?.lastIndexOf('.');
    if (dot > 0) {
      return q.displayNumber.trim().substring(dot + 1);
    }

    // failing that, assume the question text leads with a number and a dot
    if (q.questionText) {
      dot = q.questionText.trim().indexOf('.');
    }
    if (dot > 0) {
      return 'Q' + q.questionText.trim().substring(0, dot);
    }

    return 'Q';
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
