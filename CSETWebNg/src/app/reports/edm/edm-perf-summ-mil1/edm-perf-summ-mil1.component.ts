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
