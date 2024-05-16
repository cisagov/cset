import { Component } from '@angular/core';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-reports-cmmc2',
  templateUrl: './reports-cmmc2.component.html'
})
export class ReportsCmmc2Component {

  constructor(public reportSvc: ReportService) {}
}
