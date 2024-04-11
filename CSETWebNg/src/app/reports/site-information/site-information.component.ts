import { Component, Input } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { AssessmentService } from '../../services/assessment.service';

@Component({
  selector: 'app-site-information',
  templateUrl: './site-information.component.html',
  styleUrls: ['../reports.scss']
})
export class SiteInformationComponent {

  @Input()
  response: any;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService
  ) { }
}
