import { Component } from '@angular/core';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-reports-cis',
  templateUrl: './reports-cis.component.html'
})
export class ReportsCisComponent {

  constructor(public reportSvc: ReportService) {}
}
