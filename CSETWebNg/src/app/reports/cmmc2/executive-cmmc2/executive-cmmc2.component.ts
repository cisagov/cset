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
import { Component, OnInit, AfterViewInit } from '@angular/core';
import { ReportService } from '../../../services/report.service';
import { Title } from '@angular/platform-browser';
import Chart from 'chart.js/auto';
import { ChartService } from '../../../services/chart.service';
import { MaturityService } from '../../../services/maturity.service';
import { ConfigService } from '../../../services/config.service';


@Component({
  selector: 'executive',
  templateUrl: './executive-cmmc2.component.html',
  styleUrls: ['../../reports.scss']
})
export class ExecutiveCMMC2Component implements OnInit, AfterViewInit {
  loadingLevels = true;
  loadingDomains = true;

  targetLevel = 0;

  responseGeneral: any;
  responseLevels: any;
  responseDomains: any;

  responseSprs: any;
  sprsGauge = '';

  // Charts
  chartDomain: Chart;


  /**
   *
   */
  constructor(
    public reportSvc: ReportService,
    public chartSvc: ChartService,
    private maturitySvc: MaturityService,
    private titleService: Title,
    public configSvc: ConfigService
  ) {

  }

  /**
   *
   */
  ngOnInit() {
    this.titleService.setTitle("Executive Summary - " + this.configSvc.behaviors.defaultTitle);

    this.targetLevel = 0;
    this.reportSvc.getReport('executivematurity').subscribe(
      (r: any) => {
        this.responseGeneral = r;

        this.targetLevel = r.maturityModels.find(m => m.maturityModelName == 'CMMC2')?.targetLevel;
      },
      error => console.log('Executive report load Error: ' + (<Error>error).message)
    );

    this.maturitySvc.getSPRSScore().subscribe((r: any) => {
      this.responseSprs = r;
      this.sprsGauge = this.responseSprs.gaugeSvg;
    });
  }

  /**
   *
   */
  ngAfterViewInit() {
    this.populateLevelsCharts();
    this.populateDomainChart();
  }

  /**
   *
   */
  populateLevelsCharts() {
    this.maturitySvc.getComplianceByLevel().subscribe((r: any) => {
      this.responseLevels = r;

      this.responseLevels.reverse();

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

      this.loadingLevels = false;
    });
  }

  /**
   *
   */
  populateDomainChart() {
    this.maturitySvc.getComplianceByDomain().subscribe((r: any) => {
      this.responseDomains = r;

      // build the object to populate the chart
      var x: any = {};
      x.labels = [];
      x.datasets = [];
      var ds = {
        label: '',
        backgroundColor: '#245075',
        data: []
      };
      x.datasets.push(ds);

      this.responseDomains.forEach(element => {
        x.labels.push(element.domainName);
        ds.data.push(this.sumCompliantPercentages(element.answerDistribution));
      });


      setTimeout(() => {
        this.chartDomain = this.chartSvc.buildHorizBarChart('domainResults', x, false, true);
        this.loadingDomains = false;
      }, 100);
    });
  }

  /**
   * Returns the sum of the Y and NA percentages
   */
  sumCompliantPercentages(distrib: any): number {
    var total = 0;
    distrib.forEach(element => {
      if (element.value == 'Y' || element.value == 'NA') {
        total += element.percent;
      }
    });
    return total;
  }

}
