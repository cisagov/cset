import { Component, Input, OnInit } from '@angular/core';
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
  groupings: QuestionGrouping[] = null;
  questionCount: number[] = [];
  
  assessmentOneData: any;
  assessmentTwoData: any;
  
  allConflictsResolved: boolean = false;


  constructor(
    public ncuaSvc: NCUAService,
    private assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public questionSvc: QuestionsService,
    public configSvc: ConfigService,

  ) { }

  ngOnInit(): void {
    this.mergeList = this.ncuaSvc.assessmentsToMerge;
    this.loadStatements();
    this.loadAnswers();
  }

  loadStatements() {
    this.maturitySvc.getQuestionsList(this.configSvc.installationMode, false).subscribe(
      (response: MaturityQuestionResponse) => {
        this.groupings = response.groupings;
        this.questionCount = Array(this.groupings[0].questions.length).fill(1).map((x,i)=>i);
      }
    )
  }

  loadAnswers() {
      this.ncuaSvc.getAnswers(13481).subscribe(
        (response: any) => {
          for (let i = 0; i <= response.length; i++) {
            this.assessmentOneData = response;
            console.log("RESPONSE: " + JSON.stringify(response, null, 4));
          }
        }
      )

      this.ncuaSvc.getAnswers(13482).subscribe(
        (response: any) => {
          for (let i = 0; i <= response.length; i++) {
            this.assessmentTwoData = response;
            console.log("RESPONSE: " + JSON.stringify(response, null, 4));
          }
        }
      )


  }


}