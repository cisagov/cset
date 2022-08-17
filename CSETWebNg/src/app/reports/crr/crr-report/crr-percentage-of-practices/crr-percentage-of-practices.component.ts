import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';
import { ChartService } from './../../../../services/chart.service';
import { Chart } from 'chart.js';

@Component({
  selector: 'app-crr-percentage-of-practices',
  templateUrl: './crr-percentage-of-practices.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrPercentageOfPracticesComponent implements OnChanges {

  @Input() model: CrrReportModel;

  chart: Chart;

  constructor(private chartSvc: ChartService) { }

  ngOnChanges(): void {
    if (this.model) {
      this.chart = this.chartSvc.buildCrrPercentagesOfPracticesBarChart('barChart', this.model.reportChart);
    }
  }
}
