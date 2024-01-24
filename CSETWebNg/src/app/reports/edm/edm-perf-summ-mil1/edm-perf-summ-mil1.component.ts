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
import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { EDMBarChartModel } from '../edm-bar-chart.model';

@Component({
  selector: 'app-edm-perf-summ-mil1',
  templateUrl: './edm-perf-summ-mil1.component.html',
  styleUrls: ['./edm-perf-summ-mil1.component.scss', '../../reports.scss']
})
export class EdmPerfSummMil1Component implements OnInit, OnChanges {


  @Input()
  domains: any[];


  /**
   * Constructor.
   */
  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {
  }

  ngOnChanges(): void {
    this.buildHeaderTripleBarChart();
  }

  /**
   * Returns the list of domains in MIL-1.  This section does not
   * display MIL2-5.
   */
  getDomainsForDisplay() {
    return this.domains?.filter(x => x.abbreviation != "MIL");
  }

  /**
   * Returns the goals for the specified domain.
   * @param domain 
   */
  getGoals(domain: any) {
    return domain.subGroupings.filter(x => x.groupingType == "Goal");
  }

  /**
   * Constructs an answer distribution 'grand total' object
   */
  buildHeaderTripleBarChart() {
    const chart = new EDMBarChartModel();
    chart.title = 'EDM MIL-1 Summary';
    chart.green = 0;
    chart.yellow = 0;
    chart.red = 0;

    // total up the non-MIL domains
    this.domains?.filter(d => d.abbreviation !== 'MIL').forEach(d => {
      const totals = this.buildTriple(d);
      chart.green += totals.green;
      chart.yellow += totals.yellow;
      chart.red += totals.red;
    });

    return chart;
  }

  /**
   * Builds the object for the vertical bar chart
   */
  buildTriple(d: any) {
    const chart = new EDMBarChartModel();
    chart.title = d.title;
    chart.green = 0;
    chart.yellow = 0;
    chart.red = 0;

    const goals = this.getGoals(d);
    goals?.forEach(g => {
      g.questions?.forEach(q => {
        if (!q.isParentQuestion) {
          this.addAnswerToChart(chart, q.answer);
        }
      });
    });

    return chart;
  }

  /**
   * Returns an object with the answer distribution for a goal
   */
  buildHoriz(g: any) {
    const chart = new EDMBarChartModel();
    chart.title = g.title;
    chart.green = 0;
    chart.yellow = 0;
    chart.red = 0;

    g.questions.forEach(q => {
      if (!q.isParentQuestion) {
        this.addAnswerToChart(chart, q.answer);
      }
    });

    return chart;
  }

  /**
   * 
   */
  addAnswerToChart(chart, answer) {
    switch (answer) {
      case "Y":
        chart.green++;
        break;
      case "I":
        chart.yellow++;
        break;
      case "N":
      default:
        chart.red++;
        break;
    }
  }
}
