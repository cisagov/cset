import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';
import { CrrService } from '../../../../services/crr.service';

@Component({
  selector: 'app-crr-performance-summary',
  templateUrl: './crr-performance-summary.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrPerformanceSummaryComponent implements OnInit {

  @Input() model: CrrReportModel;

  legend: string = '';
  charts: any[] = [];

  constructor(private crrSvc: CrrService) { }

  ngOnInit(): void {
    this.crrSvc.getCrrPerformanceSummaryLegendWidget().subscribe((resp: string) => {
      this.legend = resp;
    });

    this.crrSvc.getCrrPerformanceSummaryBodyCharts().subscribe((resp: any[]) => {
      this.charts = resp;
    });
  }

  getChart(i, j) {
    return this.charts[i][j];
  }

}
