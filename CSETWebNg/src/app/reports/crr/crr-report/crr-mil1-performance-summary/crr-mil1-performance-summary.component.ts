import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-mil1-performance-summary',
  templateUrl: './crr-mil1-performance-summary.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrMil1PerformanceSummaryComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
