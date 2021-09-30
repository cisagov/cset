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
    public reportSvc: ReportService
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
  parentQuestions(q: Question):Question[] {
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
  getQuestionNumber(q: any) {
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
    if (remarks.trim().length > 0) {
      return this.reportSvc.formatLinebreaks(this.domain.remarks);
    }

    return 'No remarks have been entered';
  }
}
