import { Component, Input, OnInit } from '@angular/core';
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
  parentQuestions(questionList: any[]) {
    return questionList.filter(x => !x.parentQuestionId);
  }

  /**
   * Until question numbers are broken out into their own data element,
   * we'll parse them from the question text.
   * @param q 
   */
  getQuestionNumber(q: any) {
    const dot = q.questionText.trim().indexOf('.');
    if (dot < 0) {
      return "Q";
    }
    return "Q" + q.questionText.trim().substring(0, dot);
  }

  /**
   * Looks up the Options For Consideration from the collection held by
   * the MaturityService.  
   * @param questionId 
   */
  getOfc(questionId: number) {
    if (!this.maturitySvc.ofc) {
      return '';
    }

    const questionOption = this.maturitySvc.ofc.find(x => x.mat_Question_Id == questionId);
    if (!!questionOption && !!questionOption.reference_Text) {
      return questionOption.reference_Text;
    }

    return '';
  }



  /**
 * 
 * @returns 
 */
  getDomainRemark() {
    if (!!this.domain && !!this.domain.domainRemark) {
      return this.reportSvc.formatLinebreaks(this.domain.domainRemark);
    }

    return 'No remarks have been entered';
  }
}
