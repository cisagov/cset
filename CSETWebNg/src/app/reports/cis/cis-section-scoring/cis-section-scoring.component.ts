import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { CisService } from '../../../services/cis.service';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'app-cis-section-scoring',
  templateUrl: './cis-section-scoring.component.html',
  styleUrls: ['../../../reports/reports.scss']
})
export class CisSectionScoringComponent implements OnInit {

  loading = true;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;

  baselineAssessmentName: string;

  myModel: any;

  /**
   * 
   */
  constructor(
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public assessSvc: AssessmentService,
    public titleService: Title
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.loading = true;
    this.titleService.setTitle("Section Scoring Report - CISA CIS");

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
    });

    this.cisSvc.getCisSectionScoring().subscribe((resp: any) => {
      this.myModel = resp.myModel;
      this.loading = false;
    });
  }

}
