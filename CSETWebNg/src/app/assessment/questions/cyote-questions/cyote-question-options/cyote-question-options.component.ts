import { Component, Input, OnInit } from '@angular/core';
import { CyoteService } from '../../../../services/cyote.service';
import { Utilities } from '../../../../services/utilities.service';

@Component({
  selector: 'app-cyote-question-options',
  templateUrl: './cyote-question-options.component.html',
  styleUrls: ['./cyote-question-options.component.scss']
})
export class CyoteQuestionOptionsComponent implements OnInit {

  @Input('question') q: any;

  optionGroupName: string;

  /**
   * The question asked below the selected option
   */
  subQ: any;

  constructor(
    public cyoteSvc: CyoteService,
    private utilSvc: Utilities
  ) { }

  ngOnInit(): void {
    this.optionGroupName = this.utilSvc.makeId(8);
  }

  /**
   * 
   */
  radioChanged(optionId: number, evt: any) {
    this.cyoteSvc.getQuestion(optionId).subscribe((x: any) => {
      this.subQ = x.question;
    });
  }
}
