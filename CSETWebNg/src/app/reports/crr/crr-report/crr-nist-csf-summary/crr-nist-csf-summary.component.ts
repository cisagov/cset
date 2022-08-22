import { CrrService } from './../../../../services/crr.service';
import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-nist-csf-summary',
  templateUrl: './crr-nist-csf-summary.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrNistCsfSummaryComponent implements OnInit {

  @Input() model: CrrReportModel;
  chartAll: string = '';
  legend: string = '';

  constructor(private crrSvc: CrrService) { }

  ngOnInit(): void {

    this.crrSvc.getNistCsfSummaryChartWidget().subscribe((resp: string) => {
      this.chartAll = resp;
    })

    this.crrSvc.getMil1PerformanceSummaryLegendWidget().subscribe((resp: string) => {
      this.legend = resp;
    })
  }

}
