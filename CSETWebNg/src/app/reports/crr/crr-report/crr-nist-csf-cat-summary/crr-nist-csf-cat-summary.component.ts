import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-nist-csf-cat-summary',
  templateUrl: './crr-nist-csf-cat-summary.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrNistCsfCatSummaryComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
