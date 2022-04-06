////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { Component, Input, OnInit } from '@angular/core';
import { Answer } from '../../../../models/questions.model';
import { CisService } from '../../../../services/cis.service';
import { MaturityService } from '../../../../services/maturity.service';
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

  descendants: any[];

  // temporary debug aids
  showIdTag = false;
  showWeightTag = false;

  constructor(
    public questionsSvc: QuestionsService,
    public cisSvc: CisService
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
    var answers = [];

    // add this option to the request
    answers.push(this.makeAnswer(o));

    // get the descendants for my peer radios to clean them up
    var otherOptions = this.q.options.filter(x => x.optionId !== o.optionId);
    this.descendants = [];
    this.getDescendants(otherOptions);

    this.descendants.forEach(g => {
      g.selected = false;
      g.answerText = '';
      g.freeResponseAnswer = '';

      const ans = this.makeAnswer(g);
      if (!!ans) {
        answers.push(ans);
      }
    });

    debugger;
    this.storeAnswers(answers);
  }

  /**
   * 
   */
  changeCheckbox(o, event): void {
    o.selected = event.target.checked;
    var answers = [];

    // add this option to the request
    answers.push(this.makeAnswer(o));

    // if unselected, clean up my kids
    if (!o.selected) {
      this.descendants = [];
      this.getDescendants([o]);

      this.descendants.forEach(g => {
        g.selected = false;
        g.answerText = '';
        g.freeResponseAnswer = '';

        const ans = this.makeAnswer(g);
        if (!!ans) {
          answers.push(ans);
        }
      });
    }

    this.storeAnswers(answers);
  }

  /**
   * 
   */
  changeText(o, event): void {
    o.freeResponseAnswer = event.target.value;
    this.storeAnswers([o]);
  }


  /**
   * Creates a 'clean' (unanswered) option
   */
  makeAnswer(o): Answer {

    console.log('makeAnswer');
    console.log(o);

    const answer: Answer = {
      answerId: o.answerId,
      questionId: o.questionId,
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

    return answer;
  }

  /**
   * 
   */
  storeAnswers(answers) {
    this.cisSvc.storeAnswers(answers).subscribe((x: any) => {
      let score = x.groupingScore;
      this.cisSvc.changeScore(score);
    });
  }

  /**
   * Recurses the children of the supplied options/questions
   * and adds them to the 'gathered' array.
   */
  getDescendants(y: any[]) {
    if (!y) {
      return;
    }
    y.forEach(x => {
      this.getDescendants(x.followups);
      this.getDescendants(x.options);

      this.descendants.push(x);
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
