import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { CisService } from '../../../services/cis.service';

@Component({
  selector: 'app-cis-ranked-deficiency',
  templateUrl: './cis-ranked-deficiency.component.html',
  styleUrls: ['./cis-ranked-deficiency.component.scss', '../../../reports/reports.scss']
})
export class CisRankedDeficiencyComponent implements OnInit {

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;

  baselineAssessmentName: string;

  constructor(
    public cisSvc: CisService,
    public assessSvc: AssessmentService,
    public titleService: Title
  ) { }


  ngOnInit(): void {
    this.titleService.setTitle("Deficiency Report - CISA CIS");

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
    });
  }

}
