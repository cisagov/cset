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
  listAsString: string = '';
  groupings: QuestionGrouping[] = null;
  questionCount: number[] = [];
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
    this.listAsString = JSON.stringify(this.mergeList, null, 4);
    this.loadQuestions();
  }

  loadQuestions() {
    this.maturitySvc.getQuestionsList(this.configSvc.installationMode, false).subscribe(
      (response: MaturityQuestionResponse) => {
        this.groupings = response.groupings;
        console.log("Response: " + JSON.stringify(this.groupings, null, 4));
        this.questionCount = Array(this.groupings[0].questions.length).fill(1).map((x,i)=>i);
      }
    )
  }

  
  
}