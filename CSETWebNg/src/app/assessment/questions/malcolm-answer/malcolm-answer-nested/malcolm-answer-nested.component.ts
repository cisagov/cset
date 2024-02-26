import { Component, Input } from '@angular/core';
import { QuestionsService } from '../../../../services/questions.service';
import { MalcolmService } from '../../../../services/malcolm.service';

@Component({
  selector: 'app-malcolm-answer-nested',
  templateUrl: './malcolm-answer-nested.component.html',
  styleUrls: ['./malcolm-answer-nested.component.scss']
})
export class MalcolmAnswerNestedComponent {
  @Input() optRadio: any;
  @Input() malcolmAnswer: any;
  @Input() option: any;
  @Input() question: any;

  selectedOption: any;
  malcolmAnswerForThis: any;

  constructor(
    public questionsSvc: QuestionsService,
    public malcolmSvc: MalcolmService
  ) { }

  ngOnInit() {
    if (this.option.selected) {
      this.selectedOption = this.option;
    }
    else {
      for (let i = 0; i < this.optRadio.length; i++) {
        if (this.optRadio[i].selected) {
          this.selectedOption = this.optRadio[i];
        }
      }
    }
  }
}
