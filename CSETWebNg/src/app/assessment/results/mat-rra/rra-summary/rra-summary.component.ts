import { Component, Input, OnInit } from '@angular/core';
import { NgxChartsModule, ColorHelper } from '@swimlane/ngx-charts';
import { RraDataService } from '../../../../services/rra-data.service';

@Component({
  selector: 'app-rra-summary',
  templateUrl: './rra-summary.component.html',
  styleUrls: ['./rra-summary.component.scss']
})
export class RraSummaryComponent implements OnInit {
  @Input() title = "Summary";
  @Input() filter;

  single: any[] = [];

  view: any[] = [300, 300];

  gradient: boolean = false;
  showLegend: boolean = true;
  showLabels: boolean = false;
  isDoughnut: boolean = true;
  legendPosition: string = 'below';
  arcWidth = .5;
  legend: string[] = [];
  colorScheme = {
    domain: ['#006100', '#9c0006', '#888888']
  };

  legendColors: ColorHelper;

  constructor(public rraDataSvc: RraDataService) {
    Object.assign(this.single);
  }

  ngOnInit(): void {
    this.rraDataSvc.getRRADetail().subscribe((r: any) => {
      this.createAnswerDistribByLevel(r);
    });
  }

  createAnswerDistribByLevel(r: any) {
    let levelList = [];
    r.rraSummary.forEach(element => {

      let level = levelList.find(x => x.name == element.level_Name);
      if (!level) {
        level = {
          'name': element.level_Name, series: [
            { 'name': 'Yes', value: '' },
            { 'name': 'No', value: '' },
            { 'name': 'Unanswered', value: '' },
          ]
        };
        levelList.push(level);
      }

      var p = level.series.find(x => x.name == element.answer_Full_Name);
      p.value = element.percent;
    });
    if (this.filter == "Overall") {
      let overall = [];
      r.rraSummaryOverall.forEach(element => {
        overall.push({
          'name': element.answer_Full_Name,
          'value': element.percent
        })
      });
      this.single = overall;
      this.buildLegend();
      return;
    }
    this.single = levelList.find(x => x.name == this.filter).series;
    this.buildLegend();
  }

  buildLegend() {
    this.legend = this.single.map((d: any) => Math.round(d.value) + "% " + d.name)
    this.legendColors = new ColorHelper(this.colorScheme, "ordinal", this.single.map((d: any) => d.name), this.colorScheme);
  }
}
