import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-mil1-performance',
  templateUrl: './crr-mil1-performance.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrMil1PerformanceComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
