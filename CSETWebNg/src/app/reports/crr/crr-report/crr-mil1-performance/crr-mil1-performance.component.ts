import { CrrService } from './../../../../services/crr.service';
import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-mil1-performance',
  templateUrl: './crr-mil1-performance.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrMil1PerformanceComponent implements OnInit {

  @Input() model: CrrReportModel;
  mil1FullAnswerDistribChart: string = '';
  legend: string = '';
  scoreBarCharts: string[] = [];
  heatMaps: any[] = [];

  constructor(private crrSvc: CrrService) { }

  ngOnInit(): void {
    this.crrSvc.getMil1FullAnswerDistribWidget().subscribe((resp: string) => {
      this.mil1FullAnswerDistribChart = resp;
    })

    this.crrSvc.getMil1PerformanceLegendWidget().subscribe((resp: string) => {
      this.legend = resp;
    })

    this.crrSvc.getMil1PerformanceBodyCharts().subscribe((resp: any) => {
      this.scoreBarCharts = resp.scoreBarCharts;
      this.heatMaps = resp.heatMaps;
    })
  }

  // This function splits strings like
  // "Goal 6 - Post-incident lessons learned are translated into improvement strategies."
  // and
  // "Goal 3-Risks are identified."
  stringSplitter(str: string) {
    return str.split(" - ")[1] ?? str.split("-")[1];
  }

  getHeatMap(goalTitle: string) {
    return this.heatMaps.find(c => c.title === goalTitle).chart;
  }

  filterMilDomainGoals(goals) {
    return goals.filter(g => !g.title.startsWith('MIL'));
  }
}
