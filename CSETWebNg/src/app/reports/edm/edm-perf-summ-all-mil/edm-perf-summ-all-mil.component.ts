import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../services/maturity.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-edm-perf-summ-all-mil',
  templateUrl: './edm-perf-summ-all-mil.component.html',
  styleUrls: ['./edm-perf-summ-all-mil.component.scss', '../../reports.scss']
})
export class EdmPerfSummAllMilComponent implements OnInit, OnChanges {

  @Input()
  domains: any[];

  scores: any[];

  domainMil: any;

  constructor(
    private maturitySvc: MaturityService,
    public reportSvc: ReportService
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.maturitySvc.getEdmScores('MIL').subscribe(
      (r: any) => {
        this.scores = r;
      },
      error => console.log('RF Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   */
  ngOnChanges(): void {
    if (!!this.domains) {
      this.domainMil = this.domains.find(x => x.abbreviation == 'MIL');
    }
  }

  /**
   * Returns the question text for a MIL question.
   * @param mil 
   * @param qNum 
   */
  getText(mil: string, qNum: string): string {
    const goal = this.domainMil?.subGroupings.find(x => x.title.startsWith(mil));
    const q = goal?.questions.find(x => x.displayNumber == mil + '.' + qNum);
    return this.reportSvc.scrubGlossaryMarkup(q?.questionText);
  }

  /**
   * Returns the CSS class for the question's score.
   * @param mil 
   * @param qNum 
   */
  scoreClass(mil: string, qNum: string): string {
    if (!this.scores) {
      return '';
    }

    const p = this.scores.find(s => s.parent.title_Id == mil);
    if (p != null) {
      if (qNum == '') {
        return this.colorToClass(p.parent.color);
      }

      const q = p.children.find(c => c.title_Id == qNum);
      if (q != null) {
        return this.colorToClass(q.color);
      }
    }

    return '';
  }

  /**
   * 
   * @param color 
   */
  colorToClass(color: string) {
    if (!color) {
      return '';
    }
    switch (color.toLowerCase()) {
      case 'green':
        return 'green-score';
      case 'yellow':
        return 'yellow-score';
      case 'red':
        return 'red-score';
    }
    return '';
  }
}
