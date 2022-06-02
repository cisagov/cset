import { Component, Input, OnInit } from '@angular/core';
import { ChartService } from '../../../../services/chart.service';

@Component({
  selector: 'app-cis-scoring-chart',
  templateUrl: './cis-scoring-chart.component.html',
  styleUrls: ['../../../../reports/reports.scss']
})
export class CisScoringChartComponent implements OnInit {

  @Input()
  g: any;

  chartScore: any;

  /**
   * 
   */
  constructor(
    public chartSvc: ChartService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    let x = this.g.chart;

    let opts = {
      scales: { y: { display: false } },
      plugins: {
        legend: { position: 'right' }
      }
    };

    setTimeout(() => {
      this.chartScore = this.chartSvc.buildHorizBarChart('canvasScore-' + this.g.groupingId, x, true, true, opts);
    }, 800);
  }

}
