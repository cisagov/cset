import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-performance-summary',
  templateUrl: './crr-performance-summary.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrPerformanceSummaryComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
