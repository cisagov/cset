import { Component, OnInit, ViewChild } from '@angular/core';
import { CrrService } from '../../../../services/crr.service';
import  Chart  from 'chart.js/auto';
@Component({
  selector: 'app-crr-summary-results',
  templateUrl: './crr-summary-results.component.html'
})
export class CrrSummaryResultsComponent implements OnInit {

  chart: Chart;
  initialized = false;
  summaryResult: any = '';
  constructor(private crrSvc: CrrService) { 
    
  }
 
  ngOnInit(): void {
    this.crrSvc.getCrrModel().subscribe((data:any) =>{
      let chartData = data;
      console.log(data);
      this.setupChart(data.reportChart)
    });

    this.crrSvc.getCrrHtml("_CrrResultsSummary").subscribe((data:any)=>{
      this.summaryResult = data.html;
    })
  }

  setupChart(x: any) {
    this.initialized = false;
    let tempChart = Chart.getChart('percentagePractices');
    if(tempChart){
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
              callback: function(value, index, values){
                return value + "%";
              }
            }
          }
        }
      }
    });
    this.initialized = true;
  }
}
