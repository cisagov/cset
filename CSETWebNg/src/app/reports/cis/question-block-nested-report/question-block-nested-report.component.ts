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
import { Component, Input, OnInit } from '@angular/core';
import { CisService } from '../../../services/cis.service';
import { ConfigService } from '../../../services/config.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-question-block-nested-report',
  templateUrl: './question-block-nested-report.component.html',
  styleUrls: ['../../reports.scss']
})
export class QuestionBlockNestedReportComponent implements OnInit {

  @Input() grouping: any;
  @Input() questions: any[];

  questionList: any[];

  // temporary debug aid
  showIdTag = false;

  constructor(
    public questionsSvc: QuestionsService,
    public cisSvc: CisService,
    private configSvc: ConfigService
  ) { }

  ngOnInit(): void {
    if (!!this.grouping) {
      this.questionList = this.grouping.questions;
    }

    if (!!this.questions) {
      this.questionList = this.questions;
    }

    this.showIdTag = this.configSvc.showQuestionAndRequirementIDs();
  }

  /**
   * 
   */
  getTimespanDisplay(val: string) {
    let num = '';
    let unit = '';

    if (!val) {
      return '';
    }
    let p = val.split('|');
    if (p.length > 0) {
      num = p[0];
    }
    if (p.length > 1) {
      let u = p[1];
      switch (u) {
        case 'min':
          unit = 'minutes';
          break;
        case 'hr':
          unit = 'hours';
          break;
        case 'day':
          unit = 'days';
          break;
      }
    }

    return (num + ' ' + unit).trim();
  }
}
