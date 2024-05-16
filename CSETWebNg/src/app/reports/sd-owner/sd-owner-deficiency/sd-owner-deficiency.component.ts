import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'app-sd-owner-deficiency',
  templateUrl: './sd-owner-deficiency.component.html',
  styleUrls: ['../../reports.scss']
})

export class SdOwnerDeficiencyComponent {
  domains: any[] = [];

  loading = false;

  responseU: any;
  responseNo: any;
  responseNa: any;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;

  constructor(
    public maturitySvc: MaturityService,
    public assessSvc: AssessmentService,
    public titleService: Title
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.titleService.setTitle("Deficiency Report");
    this.loading = true;

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.creatorName;
      this.facilityName = assessmentDetail.facilityName;
    });

    this.maturitySvc.getMaturityDeficiencySdOwner().subscribe(
      (r: any) => {
        console.log("results");
        console.log(r);
        console.log(r.unanswered[0]);
        console.log(r.unanswered[1]);
        console.log(r.unanswered[2]);
        console.log(r.unanswered[3]);

        this.loading = false;
        this.responseU = r.unanswered;
        this.responseNo = r.no;
        this.responseNa = r.na;
      });
  }

}