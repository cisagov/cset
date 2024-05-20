import { Component, Input } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-report-list',
  templateUrl: './report-list.component.html',
  styleUrls: ['./report-list.component.scss']
})
export class ReportListComponent {


  @Input()
  confidentiality: any;

  @Input()
  sectionId: string;

  @Input()
  sectionTitle: string;

  @Input()
  list: any[];


  /**
   * 
   */
  constructor(
    public reportSvc: ReportService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  onSelectSecurity(val) {
    this.confidentiality = val;
    this.reportSvc.confidentiality = val;
  }

  /**
   * Returns the translation, or an empty string
   */
  translateDesc(section: string, index: number): string {
    const key = 'reports.launch.' + section.toLowerCase() + '.' + (index + 1) + '.desc'
    const val = this.tSvc.translate(key);
    return val === key ? '' : val;
  }
}
