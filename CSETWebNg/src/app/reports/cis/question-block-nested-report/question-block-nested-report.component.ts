import { Component, Input, OnInit } from '@angular/core';
import { CisService } from '../../../services/cis.service';
import { ConfigService } from '../../../services/config.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-question-block-nested-report',
  templateUrl: './question-block-nested-report.component.html',
  styleUrls: ['./question-block-nested-report.component.scss']
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

  getMhdNum(val: string) {
    if (!val) {
      return '';
    }
    let p = val.split('|');
    if (p.length > 0) {
      return p[0];
    }
  }

  getMhdUnit(val: string) {
    if (!val) {
      return '';
    }
    let p = val.split('|');
    if (p.length > 1) {
      return p[1];
    }
  }


}
