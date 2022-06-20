import { Component, OnInit, ViewChild } from '@angular/core';
import { CrrService } from '../../../../services/crr.service';
import Chart from 'chart.js/auto';
import { ConfigService } from '../../../../services/config.service';
import { DomSanitizer, SafeUrl } from '@angular/platform-browser';

@Component({
  selector: 'app-crr-summary-results',
  templateUrl: './crr-summary-results.component.html'
})
export class CrrSummaryResultsComponent implements OnInit {

  chart: Chart;
  summaryResult: any = '';
  stylesheetUrl: SafeUrl;

  chartLoaded: boolean = false;
  summaryResultLoaded: boolean = false;

  constructor(
    private crrSvc: CrrService,
    private configSvc: ConfigService,
    private domSanitizer: DomSanitizer
    ) {
  }

  ngOnInit(): void {
    this.stylesheetUrl = this.domSanitizer.bypassSecurityTrustResourceUrl(this.configSvc.reportsUrl + 'css/CRRResults.css');

    this.crrSvc.getCrrModel().subscribe((data: any) => {
      this.setupChart(data.reportChart)
      this.chartLoaded = true;
    });

    this.crrSvc.getCrrHtml("_CrrResultsSummary").subscribe((data: any) => {
      this.summaryResult = data.html;
      this.summaryResultLoaded = true;
    })
  }

  setupChart(x: any) {
    let tempChart = Chart.getChart('percentagePractices');
    if (tempChart) {
      tempChart.destroy();
    }
    this.chart = new Chart('percentagePractices', {
      type: 'bar',
      data: {
        labels: x.labels.$values,
        datasets: [{
          data: x.values.$values,
          backgroundColor: "rgb(21, 124, 142)",
          borderColor: "rgb(21,124,142)",
          borderWidth: 0
        }],
      },
      options: {
        indexAxis: 'y',
        hover: { mode: null },
        events: [],
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            min: 0,
            max: 100,
            beginAtZero: true,
            ticks: {
              stepSize: 10,
              callback: function (value, index, values) {
                return value + "%";
              }
            }
          }
        }
      }
    });
  }
}
