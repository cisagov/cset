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
import { Component, OnInit, ElementRef, AfterContentInit, HostListener } from '@angular/core';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { Title } from '@angular/platform-browser';
import { MaturityService } from '../../../../services/maturity.service';
import { ChartService } from '../../../../services/chart.service';
import { LayoutService } from '../../../../services/layout.service';

@Component({
  selector: 'app-cmmc2-level-results',
  templateUrl: './cmmc2-level-results.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class Cmmc2LevelResultsComponent implements OnInit, AfterContentInit {


  loading = false;

  response: any;
  dataError: boolean;
  cmmcModel: any;


  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.evaluateWindowSize();
  }

  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    private titleService: Title,
    private elementRef: ElementRef,
    public chartSvc: ChartService,
    public layoutSvc: LayoutService
  ) { }

  ngOnInit(): void {
    this.loading = true;
  }

  ngAfterContentInit(): void {
    this.refreshChart();
  }

  evaluateWindowSize() {
    this.refreshChart();
  }

  refreshChart() {
    this.maturitySvc.getComplianceByLevel().subscribe((r: any) => {
      this.response = r;
      this.response.reverse();

      r.forEach(level => {
        let g = level.answerDistribution.find(a => a.value == 'Y');
        level.compliancePercent = !!g ? g.percent.toFixed() : 0;
        level.nonCompliancePercent = 100 - level.compliancePercent;

        // build the data object for Chart
        var x: any = {};
        x.label = '';
        x.labels = [];
        x.data = [];
        x.colors = [];
        level.answerDistribution.forEach(element => {
          x.data.push(element.percent);
          x.labels.push(element.value);
          x.colors.push(this.chartSvc.segmentColor(element.value));
        });

        setTimeout(() => {
          level.chart = this.chartSvc.buildDoughnutChart('level' + level.levelValue, x);
        }, 10);
      });

      this.loading = false;
    });
  }
}
