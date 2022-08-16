import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-nist-csf-cat-performance',
  templateUrl: './crr-nist-csf-cat-performance.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrNistCsfCatPerformanceComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
