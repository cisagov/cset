import { Component, Input } from '@angular/core';
import { ReportService } from '../../services/report.service';

@Component({
  selector: 'app-site-information',
  templateUrl: './site-information.component.html',
  styleUrls: ['../reports.scss']
})
export class SiteInformationComponent {

  @Input()
  response: any;

  constructor (
    public reportSvc: ReportService
  ) { }
}
