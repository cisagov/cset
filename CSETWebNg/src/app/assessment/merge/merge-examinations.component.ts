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

  groupings: QuestionGrouping[] = [];
  questionCount: number[] = [];

  mergeList: any[] = [];
  childStatements: any[] = [];
  parentStatements: any[] = [];
  
  assessmentOneData: any; assessmentTwoData: any; assessmentThreeData: any;
  assessmentFourData: any; assessmentFiveData: any; assessmentSixData: any;
  assessmentSevenData: any; assessmentEightData: any; assessmentNineData: any;
  assessmentTenData: any;
  
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
        console.log("RESPONSE: " + JSON.stringify(response, null, 4));

        for (let i = 0; i < this.groupings[0].questions.length; i++) {
          if (!this.groupings[0].questions[i].isParentQuestion) {
            this.childStatements.push(this.groupings[0].questions[i]);
          } else {
            this.parentStatements.push(this.groupings[0].questions[i]);
          }
        }

        console.log("CHILDREN: " + JSON.stringify(this.childStatements, null, 4));
        console.log("PARENT: " + JSON.stringify(this.parentStatements, null, 4));
        this.questionCount = Array(this.groupings[0].questions.length).fill(1).map((x,i)=>i);
      }
    )
  }

  loadAnswers() {
    this.mergeList.forEach((id, index) => {
      this.ncuaSvc.getAnswers(id).subscribe(
        (response: any) => {
          for (let i = 0; i <= response.length; i++) {
            if (index === 0) {
              this.assessmentOneData = response;
            } else if (index === 1) {
              this.assessmentTwoData = response;
            } else if (index === 2) {
              this.assessmentThreeData = response;
            } else if (index === 3) {
              this.assessmentFourData = response;
            } else if (index === 4) {
              this.assessmentFiveData = response;
            } else if (index === 5) {
              this.assessmentSixData = response;
            } else if (index === 6) {
              this.assessmentSevenData = response;
            } else if (index === 7) {
              this.assessmentEightData = response;
            } else if (index === 8) {
              this.assessmentNineData = response;
            } else if (index === 9) {
              this.assessmentTenData = response;
            }
          }
      })
    })
  }

  getParentText(parentId: number) {
    let parentText = "";

    for (let i = 0; i < this.parentStatements.length; i++) {
      if (parentId === this.parentStatements[i].questionId) {
        parentText = this.parentStatements[i].questionText;
      }
    }
    
    return parentText;
  }

}