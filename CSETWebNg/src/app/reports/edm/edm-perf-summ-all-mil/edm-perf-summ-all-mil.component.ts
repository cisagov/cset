import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'app-edm-perf-summ-all-mil',
  templateUrl: './edm-perf-summ-all-mil.component.html',
  styleUrls: ['../../reports.scss']
})
export class EdmPerfSummAllMilComponent implements OnInit, OnChanges {

  @Input()
  domains: any[];

  scores: any[];

  domainMil: any;

  constructor(
    private maturitySvc: MaturityService
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.maturitySvc.getEdmScores('MIL').subscribe(
      (r: any) => {
        this.scores = r;
        console.log(this.scores);
      },
      error => console.log('RF Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   */
  ngOnChanges(): void {
    if (!!this.domains) {
      this.domainMil = this.domains.find(x => x.Abbreviation == 'MIL');
    }
  }

  /**
   * Returns the question text for a MIL question.
   * @param mil 
   * @param qNum 
   */
<<<<<<< HEAD
  getText(mil: string, qNum: string): string {    
    // const milDomain = this.domains.find(x => x.Abbreviation == 'MIL');
    // const goal = milDomain.SubGroupings.find(x => x.Title.startsWith(mil));
    // const q = goal.Questions.find(x => x.DisplayNumber == mil + '.' + qNum);
    // console.log(q);
    // return q.QuestionText;
    return "debug";
=======
  getText(mil: string, qNum: string): string {
    const goal = this.domainMil?.SubGroupings.find(x => x.Title.startsWith(mil));
    const q = goal?.Questions.find(x => x.DisplayNumber == mil + '.' + qNum);
    return q?.QuestionText;
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

    const p = this.scores.find(s => s.parent.Title_Id == mil);
    if (p != null) {
      if (qNum == '') {
        return this.colorToClass(p.parent.Color);
      }

      const q = p.children.find(c => c.Title_Id == qNum);
      if (q != null) {
        return this.colorToClass(q.Color);
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
>>>>>>> develop
  }
}
