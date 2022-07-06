import { Component, Input, OnInit } from '@angular/core';
import { merge } from 'rxjs';
import { MaturityQuestionResponse, QuestionGrouping } from '../../models/questions.model';
import { AssessmentService } from '../../services/assessment.service';
import { ConfigService } from '../../services/config.service';
import { MaturityService } from '../../services/maturity.service';
import { NCUAService } from '../../services/ncua.service';
import { QuestionsService } from '../../services/questions.service';

@Component({
  selector: 'merge-examinations',
  templateUrl: './merge-examinations.component.html'
})
export class MergeExaminationsComponent implements OnInit {

  mergeList: any[] = [];
  groupings: any;

  mergeConflicts: any[] = [];
  statementText: string[] = [];

  radioAnswers: string[] = [];



  constructor(
    public ncuaSvc: NCUAService,
    private assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public questionSvc: QuestionsService,
    public configSvc: ConfigService,

  ) { }

  ngOnInit() {
    this.mergeList = this.ncuaSvc.assessmentsToMerge;
    this.getConflicts();
    this.getStatementText();
  }

  getConflicts() {
    this.ncuaSvc.getAnswers(13493, 13494).subscribe(
      (response: any) => {
        this.mergeConflicts = response;
        console.log(JSON.stringify(this.mergeConflicts, null, 4));
      }
    );
  }

  getStatementText() {
    this.maturitySvc.getQuestionsList(this.configSvc.installationMode, false).subscribe(
      (response: MaturityQuestionResponse) => {
        this.groupings = response.groupings;

        for (let i = 0; i < this.mergeConflicts.length; i++) {
          for (let j = 0; j < this.groupings[0].questions.length; j++) {
            if (this.mergeConflicts[i].question_Or_Requirement_Id1 === this.groupings[0].questions[j].questionId) {
              this.statementText.push(this.groupings[0].questions[j].questionText);
            }
          }
        }
      })
  }

  updateAnswers(i: number, value: string) {
    this.radioAnswers[i] = value;
    console.log("User Answers: " + JSON.stringify(this.radioAnswers, null, 4));
  }
  

}