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
import { AfterContentInit, Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { Title } from '@angular/platform-browser';
import { MaturityService } from '../../../../services/maturity.service';
import { CmmcStyleService } from '../../../../services/cmmc-style.service';
import { ChartService } from '../../../../services/chart.service';


@Component({
  selector: 'app-cmmc2-domain-results',
  templateUrl: './cmmc2-domain-results.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class Cmmc2DomainResultsComponent implements OnInit, AfterContentInit {

  loading = true;
  dataError = false;

  targetLevel = '[unknown]';
  chart: any;
  response: any;


  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    private titleService: Title,
    public cmmcStyleSvc: CmmcStyleService,
    public chartSvc: ChartService
  ) { }



  ngOnInit(): void {
    this.loading = true;

    this.maturitySvc.getTargetLevel().subscribe((r: number) => {
      if (r > 0) {
        this.targetLevel = r.toString();
      }
    });

  }

  ngAfterContentInit(): void {
    this.maturitySvc.getComplianceByDomain().subscribe((r: any) => {
      this.response = r;

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

      this.response.forEach(element => {
        x.labels.push(element.domainName);
        ds.data.push(this.sumCompliantPercentages(element.answerDistribution));
      });


      setTimeout(() => {
        this.chart = this.chartSvc.buildHorizBarChart('domainResults', x, false, true);
        this.loading = false;
      }, 10);
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
