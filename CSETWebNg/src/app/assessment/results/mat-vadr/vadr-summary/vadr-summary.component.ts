import { Component, Input, OnInit } from '@angular/core';
import { NgxChartsModule, ColorHelper } from '@swimlane/ngx-charts';
import { VadrDataService } from '../../../../services/vadr-data.service';

@Component({
  selector: 'app-vadr-summary',
  templateUrl: './vadr-summary.component.html',
  styleUrls: ['./vadr-summary.component.scss']
})
export class VadrSummaryComponent implements OnInit {
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
    domain: ['#28A745', '#DC3545', '#c3c3c3']
  };

  legendColors: ColorHelper;

  constructor(public vadrDataSvc: VadrDataService) {
    Object.assign(this.single);
  }

  ngOnInit(): void {
    this.vadrDataSvc.getVADRDetail().subscribe((r: any) => {
      this.createAnswerDistribByLevel(r);
    });
  }

  createAnswerDistribByLevel(r: any) {
    let levelList = [];
    r.vadrSummary.forEach(element => {

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
      r.vadrSummaryOverall.forEach(element => {
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
