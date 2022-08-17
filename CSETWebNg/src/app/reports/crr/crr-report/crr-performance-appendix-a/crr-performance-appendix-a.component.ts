import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-performance-appendix-a',
  templateUrl: './crr-performance-appendix-a.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrPerformanceAppendixAComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
