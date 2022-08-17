import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-nist-csf-summary',
  templateUrl: './crr-nist-csf-summary.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrNistCsfSummaryComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
