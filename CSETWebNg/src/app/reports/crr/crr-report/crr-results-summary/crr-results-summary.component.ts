import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-results-summary',
  templateUrl: './crr-results-summary.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrResultsSummaryComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
