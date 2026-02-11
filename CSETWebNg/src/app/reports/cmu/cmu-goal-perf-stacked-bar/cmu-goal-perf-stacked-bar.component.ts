////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Component, Input } from '@angular/core';
import { CmuReportModel } from '../../../models/reports.model';
import { CmuService } from '../../../services/cmu.service';

@Component({
    selector: 'app-cmu-goal-perf-stacked-bar',
    templateUrl: './cmu-goal-perf-stacked-bar.component.html',
    styleUrls: ['./cmu-goal-perf-stacked-bar.component.scss'],
    standalone: false
})
export class CmuGoalPerfStackedBarComponent {
  @Input() moduleName: string;
  @Input() model: CmuReportModel;

  fullAnswerDistribChart: string = '';
  legend: string = '';
  scoreBarCharts: string[] = [];
  stackedBarCharts: any[] = [];

  constructor(private cmuSvc: CmuService) {}

  ngOnInit(): void {
    this.cmuSvc.getFullAnswerDistribWidget().subscribe((resp: string) => {
      this.fullAnswerDistribChart = resp;
    });

    this.cmuSvc.getMil1PerformanceSummaryLegendWidget().subscribe((resp: string) => {
      this.legend = resp;
    });

    this.cmuSvc.getGoalPerformanceSummaryBodyCharts().subscribe((resp: any) => {
      this.scoreBarCharts = resp.scoreBarCharts;
      this.stackedBarCharts = resp.stackedBarCharts;
    });
  }

  // This function splits strings like
  // "Goal 6 - Post-incident lessons learned are translated into improvement strategies."
  // and
  // "Goal 3-Risks are identified."
  stringSplitter(str: string) {
    return str.split(' - ')[1] ?? str.split('-')[1];
  }

  getStackedBarChart(goalTitle: string) {
    return this.stackedBarCharts.find((c) => c.title === goalTitle)?.chart;
  }

  filterMilDomainGoals(goals) {
    return goals.filter((g) => !g.title.startsWith('MIL'));
  }
}
