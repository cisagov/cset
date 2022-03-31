import { Component, Input, OnInit } from '@angular/core';
import { Answer } from '../../../../models/questions.model';
import { QuestionsService } from '../../../../services/questions.service';

@Component({
  selector: 'app-option-block-cis',
  templateUrl: './option-block-cis.component.html'
})
export class OptionBlockCisComponent implements OnInit {

  @Input() q: any;
  @Input() opts: any[];

  optRadio: any[];
  optCheckbox: any[];
  optOther: any[];

  optionGroupName = '';

  // temporary debug aids
  showIdTag = false;
  showWeightTag = false;

  constructor(
    public questionsSvc: QuestionsService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    // break up the options so that we can group radio buttons in a mixed bag of options
    this.optRadio = this.opts?.filter(x => x.optionType == 'radio');
    this.optCheckbox = this.opts?.filter(x => x.optionType == 'checkbox');
    this.optOther = this.opts?.filter(x => x.optionType != 'radio' && x.optionType != 'checkbox');

    // create a random 'name' that can be used to group the radios in this block
    this.optionGroupName = this.makeId(8);
  }

  /**
   * 
   */
  changeRadio(o, event): void {
    o.selected = event.target.checked;
    this.storeAnswer(o);
  }

  /**
   * 
   */
  changeCheckbox(o, event): void {
    o.selected = event.target.checked;
    this.storeAnswer(o);
  }

  changeText(o, event): void {
    o.freeResponseAnswer = event.target.value;
    this.storeAnswer(o);
  }

  /**
   * 
   */
  storeAnswer(o) {
    const answer: Answer = {
      answerId: o.answerId,
      questionId: this.q.questionId,
      questionType: 'Maturity',
      optionId: o.optionId,
      optionType: o.optionType,
      is_Maturity: true,
      is_Component: false,
      is_Requirement: false,
      questionNumber: '',
      answerText: o.selected ? 'S' : '', // options are marked 'S' for 'selected'
      freeResponseAnswer: o.freeResponseAnswer,
      altAnswerText: '',
      comment: '',
      feedback: '',
      markForReview: false,
      reviewed: false,
      componentGuid: '00000000-0000-0000-0000-000000000000'
    };

    this.questionsSvc.storeAnswer(answer).subscribe();
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
