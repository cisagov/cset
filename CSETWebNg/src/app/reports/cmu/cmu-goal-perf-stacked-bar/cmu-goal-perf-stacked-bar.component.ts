import { Component, Input } from '@angular/core';
import { CmuReportModel } from '../../../models/reports.model';
import { CmuService } from '../../../services/cmu.service';

@Component({
  selector: 'app-cmu-goal-perf-stacked-bar',
  templateUrl: './cmu-goal-perf-stacked-bar.component.html',
  styleUrls: ['./cmu-goal-perf-stacked-bar.component.scss']
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
