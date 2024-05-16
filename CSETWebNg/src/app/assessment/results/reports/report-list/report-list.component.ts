import { Component, Input } from '@angular/core';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-report-list',
  templateUrl: './report-list.component.html',
  styleUrls: ['./report-list.component.scss']
})
export class ReportListComponent {


  @Input()
  confidentiality: any;

  @Input()
  sectionTitle: string;

  @Input()
  list: any[];


  /**
   * 
   */
  constructor(public reportSvc: ReportService) { }

  /**
   * 
   */
  onSelectSecurity(val) {
    this.confidentiality = val;
    this.reportSvc.confidentiality = val;
  }
}
