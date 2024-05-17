import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'app-sd-owner-deficiency',
  templateUrl: './sd-owner-deficiency.component.html',
  styleUrls: ['../../reports.scss', './sd-owner-deficiency.component.scss']
})

export class SdOwnerDeficiencyComponent {
  loading = false;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;

  responseYes: any;
  responseNo: any;
  responseNa: any;
  responseU: any;
  
  yesAnswers = 0;
  noAnswers = 0;
  naAnswers = 0;
  unanswered = 0;
  
  yesPercent = 0;
  noPercent = 0;
  naPercent = 0;
  unansweredPercent = 0;

  // chart options
  view: any[] = [600, 350];
  gradient: boolean = true;
  showLegend: boolean = true;
  showLabels: boolean = true;
  isDoughnut: boolean = false;
  legendPosition: string = 'below';
  graphData: any = [];

  colorScheme = {
    domain: ['#5AA454', '#A10A28', '#C7B42C', '#AAAAAA']
  };

  constructor(
    public maturitySvc: MaturityService,
    public assessSvc: AssessmentService,
    public titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Deficiency Report");
    this.loading = true;

    this.getAssessmentDetails();
    this.getQuestionAnswers();
  }

  getAssessmentDetails() {
    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.creatorName;
      this.facilityName = assessmentDetail.facilityName;
    });
  }

  getQuestionAnswers() {
    this.maturitySvc.getMaturityDeficiencySdOwner().subscribe(
      (r: any) => {
        this.responseYes = r.yes;
        this.responseNo = r.no;
        this.responseNa = r.na;
        this.responseU = r.unanswered;

        this.getAnswerBreakdown(r);
    });
  }

  getAnswerBreakdown(data: any) {
    this.yesAnswers = 0;
    this.noAnswers = 0;
    this.naAnswers = 0;
    this.unanswered = 0;

    for (let i = 0; i < this.responseYes.length; i++) {
      for (let j = 0; j < this.responseYes[i].questions.length; j++) {
        this.yesAnswers++;
      }
      if (i == this.responseYes.length - 1) {
        this.graphData.push({"name": "Yes", "value": this.yesAnswers});
      }
    }

    for (let i = 0; i < this.responseNo.length; i++) {
      for (let j = 0; j < this.responseNo[i].questions.length; j++) {
        this.noAnswers++;
      }
      if (i == this.responseNo.length - 1) {
        this.graphData.push({"name": "No", "value": this.noAnswers});
      }
    }

    for (let i = 0; i < this.responseNa.length; i++) {
      for (let j = 0; j < this.responseNa[i].questions.length; j++) {
        this.naAnswers++;
      }
      if (i == this.responseNa.length - 1) {
        this.graphData.push({"name": "N/A", "value": this.naAnswers});
      }
    }

    for (let i = 0; i < this.responseU.length; i++) {
      for (let j = 0; j < this.responseU[i].questions.length; j++) {
        this.unanswered++;
      }
      if (i == this.responseU.length - 1) {
        this.graphData.push({"name": "Unanswered", "value": this.unanswered});
      }
    }

    this.getAnswerPercentages();
  }

  getAnswerPercentages() {
    var totalCount = (this.yesAnswers + this.noAnswers + this.naAnswers + this.unanswered);
    this.yesPercent = Math.round((this.yesAnswers / totalCount) * 100);
    this.noPercent = Math.round((this.noAnswers / totalCount) * 100);
    this.naPercent = Math.round((this.naAnswers / totalCount) * 100);
    this.unansweredPercent = Math.round((this.unanswered / totalCount) * 100);

    this.loading = false;
  }

}