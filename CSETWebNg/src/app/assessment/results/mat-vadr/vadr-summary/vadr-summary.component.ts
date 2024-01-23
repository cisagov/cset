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
import { Component, Input, OnInit } from '@angular/core';
import { ScaleType, Color, ColorHelper } from '@swimlane/ngx-charts';
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
  colorScheme: Color = {
    name: 'vadrSummaryColors',
    selectable: true,
    group: ScaleType.Ordinal,
    domain: ['#28A745', '#DC3545', '#FFC107', '#c3c3c3']
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
            { 'name': 'Alternate', value: '' },
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
    // this.single = levelList.find(x => x.name == this.filter).series;
    // this.buildLegend();
  }

  buildLegend() {
    this.legend = this.single.map((d: any) => Math.round(d.value) + "% " + d.name)
    this.legendColors = new ColorHelper(this.colorScheme, ScaleType.Ordinal, this.single.map((d: any) => d.name), this.colorScheme);
  }
}
