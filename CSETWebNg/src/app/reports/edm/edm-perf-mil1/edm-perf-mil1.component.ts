import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../services/maturity.service';
import { EDMBarChartModel } from '../edm-bar-chart.model';

@Component({
  selector: 'app-edm-perf-mil1',
  templateUrl: './edm-perf-mil1.component.html',
  styleUrls: ['./edm-perf-mil1.component.scss', '../../reports.scss']
})
export class EdmPerfMil1Component implements OnInit {


  @Input()
  domains: any[];

  domainScores: any[] = [];

  /**
   * Constructor.
   */
  constructor(
    private maturitySvc: MaturityService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.buildLegendTriple();
    this.domains?.forEach(d => {
      this.getEdmScores(d.Abbreviation);
    });
  }

  /**
   * Get the colors for the MIL1 questions.
   */
  getEdmScores(domainAbbrev: string) {
    this.maturitySvc.getEdmScores(domainAbbrev).subscribe(
      (r: any) => {
        r = r.filter(function (value, index, arr) { 
          return value.parent.Title_Id != "MIL1" 
        });
        r.Abbreviation = domainAbbrev;
        this.domainScores.push(r);
      },
      error => console.log('getEdmScores Error: ' + (<Error>error).message)
    );
  }

  /**
   * Returns the list of domains in MIL-1.  This section does not
   * display MIL2-5.
   */
  getDomainsForDisplay() {
    return this.domains?.filter(x => x.Abbreviation != "MIL");
  }

  /**
   * Returns the goals for the specified domain.
   * @param domain 
   */
  getGoals(domain: any) {
    return domain.SubGroupings.filter(x => x.GroupingType == "Goal");
  }

  /**
   * 
   * @param goal 
   */
  scoresForGoal(goal: any) {
    return {};
  }

  /**
   * Constructs an answer distribution 'grand total' object
   */
  buildLegendTriple() {
    const chart = new EDMBarChartModel();
    chart.title = 'EDM MIL-1 Summary';
    chart.green = 0;
    chart.yellow = 0;
    chart.red = 0;

    this.domains?.forEach(d => {
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
    chart.title = d.Title;
    chart.green = 0;
    chart.yellow = 0;
    chart.red = 0;

    const goals = this.getGoals(d);
    goals?.forEach(g => {
      g.Questions.forEach(q => {
        switch (q.Answer) {
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
      });
    });

    return chart;
  }
}
