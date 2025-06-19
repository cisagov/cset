import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';
import { ConfigService } from '../../../services/config.service';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';

@Component({
  selector: 'app-cre-core-report',
  templateUrl: './cre-core-report.component.html',
  styleUrls: ['../../reports.scss'],
  standalone: false
})
export class CreCoreReportComponent implements OnInit {

  title = 'CISA Cyber Resilience Essentials (CRE+) Final Report';
  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;

  constructor(
    public assessSvc: AssessmentService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    public titleService: Title
  ) {

  }

  ngOnInit(): void {
    this.titleService.setTitle(this.title);

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;
    });
  }

 
}
