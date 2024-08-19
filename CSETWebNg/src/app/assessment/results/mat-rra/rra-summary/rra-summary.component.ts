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
import { Component, HostListener, Input, OnInit } from '@angular/core';
import { Color, ColorHelper, ScaleType } from '@swimlane/ngx-charts';
import { RraDataService } from '../../../../services/rra-data.service';
import { TranslocoService } from '@ngneat/transloco';

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
  animation: boolean = false;

  gradient: boolean = false;
  showLegend: boolean = true;
  showLabels: boolean = false;
  isDoughnut: boolean = true;
  legendPosition: string = 'below';
  arcWidth = .5;
  legend: string[] = [];
  colorScheme: Color = {
    name: 'rraSummaryColors',
    selectable: true,
    group: ScaleType.Ordinal,
    domain: ['#28A745', '#DC3545', '#c3c3c3']
  };

  legendColors: ColorHelper;

  constructor(
    public rraDataSvc: RraDataService, 
    public tSvc: TranslocoService
    ) {
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

      for (let i of this.single){
       i.name = this.tSvc.translate('answer-options.button-labels.' + (i.name).toLowerCase())
      }
      this.buildLegend();
      return;
    }
    this.single = levelList.find(x => this.tSvc.translate('level.' + (x.name).toLowerCase()) == this.filter).series;

    for (let i of levelList){
      for (let j of i.series){
        j.name = this.tSvc.translate('answer-options.button-labels.' + (j.name).toLowerCase())
      }
    }

    this.buildLegend();
  }

  buildLegend() {
    this.legend = this.single.map((d: any) => Math.round(d.value) + "% " + d.name)
    this.legendColors = new ColorHelper(this.colorScheme, ScaleType.Ordinal, this.single.map((d: any) => d.name), this.colorScheme);
  }

  @HostListener('window:beforeprint')
  beforePrint() {
    this.view = [500, 500];
  }

  @HostListener('window:afterprint')
  afterPrint() {
    this.view = null;
  }
}
