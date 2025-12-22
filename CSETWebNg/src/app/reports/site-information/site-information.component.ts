import { Component, Input } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { AssessmentService } from '../../services/assessment.service';
import { AssessmentDetail } from '../../models/assessment-info.model';

@Component({
    selector: 'app-site-information',
    templateUrl: './site-information.component.html',
    styleUrls: ['../reports.scss'],
    standalone: false
})
export class SiteInformationComponent {

  @Input()
  assessDetail?: AssessmentDetail;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService
  ) { }
}
