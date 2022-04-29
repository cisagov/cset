import { Component, Input, OnInit } from '@angular/core';
import { CyoteService } from '../../../../services/cyote.service';

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
    public cyoteSvc: CyoteService
  ) { }

  ngOnInit(): void {
    this.optionGroupName = this.makeId(8);
  }

  /**
   * 
   */
  radioChanged(optionId: number, evt: any) {
    this.cyoteSvc.getQuestion(optionId).subscribe((x: any) => {
      this.subQ = x.question;
    });
  }

   /**
   *
   */
    makeId(length) {
      var result = '';
      var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      var charactersLength = characters.length;
      for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() *
          charactersLength));
      }
      return result;
    }
}
