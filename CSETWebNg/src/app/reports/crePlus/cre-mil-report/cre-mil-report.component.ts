import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';
import { ConfigService } from '../../../services/config.service';
import { Title } from '@angular/platform-browser';

@Component({
  selector: 'app-cre-mil-report',
  standalone: false,
  templateUrl: './cre-mil-report.component.html',
  styleUrls: ['../../reports.scss']
})
export class CreMilReportComponent implements OnInit {

  title = 'CISA Cyber Resilience Essentials (CRE+) MIL Report';
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
