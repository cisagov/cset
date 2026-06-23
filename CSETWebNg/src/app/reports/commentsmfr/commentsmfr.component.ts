////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { QuestionsService } from '../../services/questions.service';
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { MaturityService } from '../../services/maturity.service';
import { AssessmentService } from '../../services/assessment.service';
import { TranslocoService } from '@jsverse/transloco';
import { AssessmentDetail } from '../../models/assessment-info.model';
import { firstValueFrom } from 'rxjs';

@Component({
  selector: 'app-commentsmfr',
  templateUrl: './commentsmfr.component.html',
  styleUrls: ['../reports.scss'],
  standalone: false,
  // eslint-disable-next-line
  host: {
    'class': 'force-light-mode',
    '[attr.data-theme]': '"light"',
    '[attr.data-bs-theme]': '"light"'
  }
})
export class CommentsMfrComponent implements OnInit {
  response: any = null;

  comments: any[] | undefined = undefined;
  markedForReview: any[] | undefined = undefined;

  remarks: string;
  info: AssessmentDetail;
  loading: boolean = false;

  questionAliasSingular: string;

  aliasTranslated: string;

  /**
   * 
   */
  constructor(
    public analysisSvc: ReportAnalysisService,
    public assessSvc: AssessmentService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    private readonly titleService: Title,
    public maturitySvc: MaturityService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.initAsync();
  }

  /**
   * 
   */
  async initAsync() {
    this.loading = true;

    this.tSvc.selectTranslate('comments and marked for review', {}, { scope: 'reports' })
      .subscribe(title =>
        this.titleService.setTitle(title + ' - ' + this.configSvc.behaviors.defaultTitle));

    this.assessSvc.getAssessmentDetail().subscribe(
      (r: AssessmentDetail) => {
        this.info = r;
      }
    );

    // get comments
    try {
      this.response = await firstValueFrom(this.maturitySvc.getReportComments());
      this.comments = this.response.comments;

      this.questionAliasSingular = this.response?.information.questionsAlias.slice(0, -1);
      this.aliasTranslated = this.tSvc.translate(`titles.${this.response?.information.questionsAlias.toLowerCase()}`);
      this.loading = false;
    } catch (error) {
      console.error('Comments Marked Report Error: ' + (<Error>error).message);
    }

    // get marked for review
    try {
      const respMfr: any = await firstValueFrom(this.maturitySvc.getMarkedForReview());
      this.markedForReview = respMfr.markedForReviewList;
      this.loading = false;
    } catch (error) {
      console.error('Comments Marked Report Error: ' + (<Error>error).message);
    }


    this.assessSvc.getOtherRemarks().subscribe((resp: any) => {
      this.remarks = resp;
    });
  }

  /**
   * Typically the question will have either question_Text or security_Practice.
   */
  getQuestionText(q) {
    let text = q.question_Text.trim();

    if (q.security_Practice) {
      text = q.security_Practice.trim();
    }

    return this.reportSvc.scrubGlossaryMarkup(text);
  }

  translateNoCommentsOrMFR(questionsAlias: string, lookupKey: string) {
    if (!questionsAlias) {
      return '';
    }

    const alias = this.tSvc.translate('titles.' + questionsAlias.toLowerCase());
    return this.tSvc.translate(`reports.core.rra.cmfr.${lookupKey}`, { questionsAliasLower: alias.toLowerCase() });
  }
}
