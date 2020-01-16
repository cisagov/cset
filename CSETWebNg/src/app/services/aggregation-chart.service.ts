////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Chart } from 'chart.js';


@Injectable()
export class AggregationChartService {

  colorSequence = [
    '#0000FF',
    '#FFD700',
    '#008000',
    '#6495ED',
    '#006400',
    '#F0E68C',
    '#00008B',
    '#008B8B',
    '#FFFACD',
    '#483D8B',
    '#2F4F4F',
    '#9400D3',
    '#1E90FF',
    '#B22222',
    '#FFFAF0',
    '#228B22',
    '#DAA520',
    '#ADFF2F',
    '#4B0082',
    '#000080'
  ];
  nextColor: number = 0;

  /**
   * Constructor.
   * @param http
   * @param configSvc
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
  ) { }


  /**
  * Builds a horizontal bar chart from the Dashboard API response.
  * @param canvasId
  * @param x
  */
  buildPercentComplianceChart(canvasId: string, x: any) {
    return new Chart(canvasId, {
      'type': 'line',
      'data': {
        'labels': ['10/23/2018', '10/23/2019'],
        'datasets': [{
          'label': 'Overall',
          'data': [65, 59],
          'fill': false,
          'borderColor': '#3e7bc4',
          'backgroundColor': '#3e7bc4',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Components',
          'data': [35, 29],
          'fill': false,
          'borderColor': '#81633f',
          'backgroundColor': '#81633f',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Standards',
          'data': [45, 39],
          'fill': false,
          'borderColor': '#9ac04a',
          'backgroundColor': '#9ac04a',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Framework',
          'data': [35, 49],
          'fill': false,
          'borderColor': '#7c5aa6',
          'backgroundColor': '#7c5aa6',
          'pointRadius': 8,
          'lineTension': 0
        }
        ]
      },
      'options': {
        'legend': { 'position': 'left' }
      }
    });
  }


  /**
  * Builds a horizontal bar chart from the Dashboard API response.
  * @param canvasId
  * @param x
  */
  buildTop5Chart(canvasId: string, x: any) {
    return new Chart(canvasId, {
      'type': 'line',
      'data': {
        'labels': ['10/23/2018', '10/23/2019'],
        'datasets': [{
          'label': 'System Protection',
          'data': [65, 59],
          'fill': false,
          'borderColor': '#3e7bc4',
          'backgroundColor': '#3e7bc4',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Training',
          'data': [35, 29],
          'fill': false,
          'borderColor': '#81633f',
          'backgroundColor': '#81633f',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Incident Response',
          'data': [35, 29],
          'fill': false,
          'borderColor': '#9ac04a',
          'backgroundColor': '#9ac04a',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Physical Security',
          'data': [35, 49],
          'fill': false,
          'borderColor': '#7c5aa6',
          'backgroundColor': '#7c5aa6',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Access Control',
          'data': [38, 89],
          'fill': false,
          'borderColor': '#38adcc',
          'backgroundColor': '#38adcc',
          'pointRadius': 8,
          'lineTension': 0
        }
        ]
      },
      'options': {
        'legend': { 'position': 'left' }
      }
    });
  }

  /**
  * Builds a horizontal bar chart from the Dashboard API response.
  * @param canvasId
  * @param x
  */
  buildBottom5Chart(canvasId: string, x: any) {
    return new Chart(canvasId, {
      'type': 'line',
      'data': {
        'labels': ['10/23/2018', '10/23/2019'],
        'datasets': [{
          'label': 'Information Protection',
          'data': [65, 59],
          'fill': false,
          'borderColor': '#3e7bc4',
          'backgroundColor': '#3e7bc4',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Communication Protection',
          'data': [35, 29],
          'fill': false,
          'borderColor': '#81633f',
          'backgroundColor': '#81633f',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Monitoring & Malware',
          'data': [37, 39],
          'fill': false,
          'borderColor': '#9ac04a',
          'backgroundColor': '#9ac04a',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Continuity',
          'data': [35, 49],
          'fill': false,
          'borderColor': '#7c5aa6',
          'backgroundColor': '#7c5aa6',
          'pointRadius': 8,
          'lineTension': 0
        },
        {
          'label': 'Configuration Management',
          'data': [38, 69],
          'fill': false,
          'borderColor': '#38adcc',
          'backgroundColor': '#38adcc',
          'pointRadius': 8,
          'lineTension': 0
        }
        ]
      },
      'options': {
        'legend': { 'position': 'left' }
      }
    });
  }


  /**
  * Builds a horizontal bar chart from the Dashboard API response.
  * @param canvasId
  * @param x
  */
  buildCategoryPercentChart(canvasId: string, x: any) {
    this.nextColor = 0;

    for (let i = 0; i < x.datasets.length; i++) {
      const ds = x.datasets[i];
      if (ds.label === '') {
        ds.label = 'A';
      }
      ds.borderColor = this.colorSequence[this.nextColor];
      ds.backgroundColor = ds.borderColor;
      this.nextColor++;
    }


    return new Chart(canvasId, {
      type: 'horizontalBar',
      data: {
        labels: x.categories,
        datasets: x.datasets
      },
      options: {
        maintainAspectRatio: false
      }
    });
  }

}
