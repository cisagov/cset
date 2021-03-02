import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-edm-perf-summ-all-mil',
  templateUrl: './edm-perf-summ-all-mil.component.html',
  styleUrls: ['../../reports.scss']
})
export class EdmPerfSummAllMilComponent implements OnInit {

  @Input()
  domains: any[];

  constructor() { }

  ngOnInit(): void {
  }

  /**
   * Returns the question text for a MIL question.
   * @param mil 
   * @param qNum 
   */
  getText(mil: string, qNum: string): string {    
    // const milDomain = this.domains.find(x => x.Abbreviation == 'MIL');
    // const goal = milDomain.SubGroupings.find(x => x.Title.startsWith(mil));
    // const q = goal.Questions.find(x => x.DisplayNumber == mil + '.' + qNum);
    // console.log(q);
    // return q.QuestionText;
    return "debug";
  }
}
