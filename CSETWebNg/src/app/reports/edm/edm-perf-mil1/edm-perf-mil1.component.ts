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

  scores: Map<string, any> = new Map<string, any>();

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
    this.buildHeaderTripleBarChart();
    this.getEdmScores();
  }

  /**
   * Get the colors for all questions.
   */
  getEdmScores() {
    // * * * * * see if you can get ALL scores in one shot for all domains * * * * * *
    this.maturitySvc.getEdmScores('RF').subscribe(
      (r: any) => {
        this.scores.set('RF', r);
      },
      error => console.log('getEdmScores Error: ' + (<Error>error).message)
    );
    this.maturitySvc.getEdmScores('RMG').subscribe(
      (r: any) => {
        this.scores.set('RMG', r);
      },
      error => console.log('getEdmScores Error: ' + (<Error>error).message)
    );
    this.maturitySvc.getEdmScores('SPS').subscribe(
      (r: any) => {
        this.scores.set('SPS', r);
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
   * Digs out the scores for a domain/goal.
   * This could be improved so that we aren't parsing the goal title to do it.
   * @param goal 
   */
  scoresForGoal(domainAbbrev: string, goal: any) {
    // parse goal name from full goal title.  This is very brittle.
    const l1 = goal.Title.indexOf('-');
    const l2 = goal.Title.indexOf('–');
    const goalName = goal.Title.split((l1 > 0 ? '-' : '–'))[0].trim();

    const domainGoalScores = this.scores.get(domainAbbrev);
    const goalScores = domainGoalScores?.find(x => x.parent.Title_Id == goalName);
    return goalScores;
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

    this.domains?.filter(d => d.Abbreviation !== 'MIL').forEach(d => {
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
        if (!q.IsParentQuestion) {
          this.addAnswerToChart(chart, q.Answer);
        }
      });
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
