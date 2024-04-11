////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { CmuService } from './../../../../services/cmu.service';
import { Component, Input, OnInit } from '@angular/core';
import { CmuReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-mil1-performance',
  templateUrl: './crr-mil1-performance.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrMil1PerformanceComponent implements OnInit {
  @Input() model: CmuReportModel;
  mil1FullAnswerDistribChart: string = '';
  legend: string = '';
  scoreBarCharts: string[] = [];
  heatMaps: any[] = [];

  constructor(private cmuSvc: CmuService) {}

  ngOnInit(): void {
    this.cmuSvc.getMil1FullAnswerDistribWidget().subscribe((resp: string) => {
      this.mil1FullAnswerDistribChart = resp;
    });

    this.cmuSvc.getMil1PerformanceLegendWidget(false).subscribe((resp: string) => {
      this.legend = resp;
    });

    this.cmuSvc.getMil1PerformanceBodyCharts().subscribe((resp: any) => {
      this.scoreBarCharts = resp.scoreBarCharts;
      this.heatMaps = resp.heatMaps;
    });
  }

  // This function splits strings like
  // "Goal 6 - Post-incident lessons learned are translated into improvement strategies."
  // and
  // "Goal 3-Risks are identified."
  stringSplitter(str: string) {
    return str.split(' - ')[1] ?? str.split('-')[1];
  }

  getHeatMap(goalTitle: string) {
    return this.heatMaps.find((c) => c.title === goalTitle).chart;
  }

  filterMilDomainGoals(goals) {
    return goals.filter((g) => !g.title.startsWith('MIL'));
  }
}
