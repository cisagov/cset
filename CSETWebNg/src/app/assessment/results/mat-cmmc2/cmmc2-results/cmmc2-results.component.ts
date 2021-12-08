////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { MaturityService } from '../../../../services/maturity.service';
import Chart from 'chart.js/auto';

@Component({
  selector: 'app-cmmc2-results',
  templateUrl: './cmmc2-results.component.html', 
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class Cmmc2ResultsComponent implements OnInit {

  loading = false;


  response: any;
  dataError: boolean;
  cmmcModel: any;

  chart: Chart;

  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    private titleService: Title,
  ) { }


  ngOnInit(): void {

    this.loading = false;

    this.maturitySvc.getResultsData('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;
        if (r.maturityModels) {
          r.maturityModels.forEach(model => {
            if (model.maturityModelName === 'CMMC2') {
              this.cmmcModel = model;
            }
          });
        }
        this.loading = false;
      },
      error => {
        this.dataError = true;
        this.loading = true;
        console.log('Site Summary report load Error: ' + (<Error>error).message)
      }
    ), (finish) => {
    };
  }
  

  setupChart(x: any) {
    let tempChart = Chart.getChart('percentagesByLevel');
    if (tempChart) {
      tempChart.destroy();
    }
    this.chart = new Chart('percentagesByLevel', {
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
