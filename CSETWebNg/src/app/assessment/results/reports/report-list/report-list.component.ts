import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { TranslocoService } from '@ngneat/transloco';
import { AssessmentService } from '../../../../services/assessment.service';
import { NCUAService } from '../../../../services/ncua.service';
import { ObservationsService } from '../../../../services/observations.service';
import { ACETService } from '../../../../services/acet.service';

@Component({
  selector: 'app-report-list',
  templateUrl: './report-list.component.html',
  styleUrls: ['./report-list.component.scss']
})
export class ReportListComponent implements OnInit {


  @Input()
  confidentiality: any;

  @Input()
  sectionId: string;

  sectionTitle: string;

  @Input()
  list: any[];

  /**
   * 
   */
  constructor(
    public reportSvc: ReportService,
    public tSvc: TranslocoService,
    public assessSvc: AssessmentService,
    public ncuaSvc: NCUAService,
    public observationsSvc: ObservationsService,
    public acetSvc: ACETService
  ) { }

  ngOnInit(): void {
    if (!this.sectionId) {
      return;
    }
    const key = 'reports.launch.' + this.sectionId.toLowerCase() + '.sectionTitle';
    this.sectionTitle = this.tSvc.translate(key);
  }

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
    const key = 'reports.launch.' + section.toLowerCase() + '.' + (index + 1) + '.desc';
    const val = this.tSvc.translate(key);
    return val === key ? '' : val;
  }
}
