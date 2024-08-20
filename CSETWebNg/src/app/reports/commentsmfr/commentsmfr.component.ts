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
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { QuestionsService } from '../../services/questions.service';
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { MaturityService } from '../../services/maturity.service';
import { AssessmentService } from '../../services/assessment.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-commentsmfr',
  templateUrl: './commentsmfr.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class CommentsMfrComponent implements OnInit {
  translationTabTitle: any;
  response: any = null;
  remarks: string;

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
    private titleService: Title,
    public maturitySvc: MaturityService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.loading = true;
    
    this.translationTabTitle = this.tSvc.selectTranslate('reports.core.rra.cmfr.report title')
    .subscribe(value =>
      this.titleService.setTitle(this.tSvc.translate('reports.core.rra.cmfr.report title') + ' - ' + this.configSvc.behaviors.defaultTitle));
  

    this.maturitySvc.getCommentsMarked().subscribe(
      (r: any) => {
        this.response = r;

        // until we define a singular version in the maturity model database table, just remove (hopefully) the last 's'
        this.questionAliasSingular = this.response?.information.questionsAlias.slice(0, -1);
        this.aliasTranslated = this.tSvc.translate(`titles.${this.response?.information.questionsAlias.toLowerCase()}`);

        this.loading = false;
      },
      error => console.log('Comments Marked Report Error: ' + (<Error>error).message)
    );

    this.assessSvc.getOtherRemarks().subscribe((resp: any) => {
      this.remarks = resp;
    });
  }

  /**
   * Typically the question will have either question_Text or security_Practice.
   */
  getQuestionText(q) {
    const text = ((q.question_Text ?? '') + ' ' + (q.security_Practice ?? '')).trim();
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
