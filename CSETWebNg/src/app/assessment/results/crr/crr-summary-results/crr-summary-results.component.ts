import { Component, OnInit, ViewChild } from '@angular/core';
import { CrrService } from '../../../../services/crr.service';
import { Chart } from 'chart.js';
@Component({
  selector: 'app-crr-summary-results',
  templateUrl: './crr-summary-results.component.html'
})
export class CrrSummaryResultsComponent implements OnInit {

  chart: Chart;
  initialized = false;
  constructor(private crrSvc: CrrService) { 
    
  }
 
  ngOnInit(): void {
    this.crrSvc.getCrrModel().subscribe((data:any) =>{
      let chartData = data;
      console.log(data);
      this.setupChart(data.reportChart)
    });
  }

  setupChart(x: any) {
    this.initialized = false;
    this.chart = new Chart('percentagePractices', {
      type: 'horizontalBar',
      data: {
        labels: x.labels.$values,
        datasets: [{
          label: 'Your Results', 
          data: x.values.$values, 
          backgroundColor: ["rgba(21, 124, 142, 0.7)"], 
          borderColor: ["rgb(21,124,142)"],
                        borderWidth: 2
        }],
      },
      options: {
        title: {
          display: false,
          fontSize: 20,
          text: 'Your Results'
        },
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            ticks: {
              min: 0, 
              max: 100,
              stepSize: 10,
              beginAtZero: true,
              callback: function(value, index, values){
                return value + "%";
              }
            }
          }]
        }
      }
    });
    this.initialized = true;
  }
}
