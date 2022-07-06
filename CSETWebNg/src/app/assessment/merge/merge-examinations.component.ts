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

  groupings: QuestionGrouping[] = [];

  mergeList: any[] = [];
  mainAssessmentId: number;
  childStatements: any[] = [];
  parentStatements: any[] = [];
  
  assessmentOneData: any[] = []; assessmentTwoData: any; assessmentThreeData: any;
  assessmentFourData: any; assessmentFiveData: any; assessmentSixData: any;
  assessmentSevenData: any; assessmentEightData: any; assessmentNineData: any;
  assessmentTenData: any;

  conflictCount: number = 0;
  radioAnswers: string[] = [];
  allConflictsResolved: boolean = false;


  constructor(
    public ncuaSvc: NCUAService,
    private assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public questionSvc: QuestionsService,
    public configSvc: ConfigService,

  ) { }

  ngOnInit() {
    this.mergeList = this.ncuaSvc.assessmentsToMerge;
    this.loadStatements();
    this.loadAnswers();
  }

  loadStatements() {
    this.maturitySvc.getQuestionsList(this.configSvc.installationMode, false).subscribe(
      (response: MaturityQuestionResponse) => {
        //this.groupings = response.groupings;
        //console.log("Groupings: " + JSON.stringify(this.groupings, null, 4));

        //for (let i = 0; i < this.groupings[0].questions.length; i++) {
        //  if (this.groupings[0].questions[i].answer === 'Y' /* this.groupings[0].questions[i].answer*/) {
        //    this.conflictCount++;
        //  }
        //}

          /*if (!this.groupings[0].questions[i].isParentQuestion) {
            this.childStatements.push(this.groupings[0].questions[i]);
          } else {
            this.parentStatements.push(this.groupings[0].questions[i]);
          }*/
    })
  }

  loadAnswers() {
    this.ncuaSvc.getAnswers(13493, 13494).subscribe(
      (response: any) => {
        console.log(JSON.stringify("RESPONSE: " + response));
      }
    );
    /*
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
        });
    })
    */
  }

  checkConflicts() {

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

  defaultAnswers(index: number, value: string) {
    if (value === 'yes' && this.assessmentOneData[index].answer_Text === 'Y') {
      this.radioAnswers[index] = value;
      return true;
    } else if (value === 'no' && this.assessmentOneData[index].answer_Text === 'N') {
      this.radioAnswers[index] = value;
      return true;
    } else if (value === 'na' && this.assessmentOneData[index].answer_Text === 'NA') {
      this.radioAnswers[index] = value;
      return true;
    }
  }

  updateAnswers(index: number, value: string) {
    this.radioAnswers[index] = value;
    console.log("Radio Answer Array: " + JSON.stringify(this.radioAnswers, null, 4));
  }

}