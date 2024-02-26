import { Component, Input, OnInit } from '@angular/core';
import { QuestionsService } from '../../../../services/questions.service';
import { MalcolmService } from '../../../../services/malcolm.service';

@Component({
  selector: 'app-malcolm-answer-default',
  templateUrl: './malcolm-answer-default.component.html',
  styleUrls: ['./malcolm-answer-default.component.scss']
})
export class MalcolmAnswerDefaultComponent {
  @Input() userAnswer: string;
  @Input() malcolmAnswer: any;

  malcolmAnswerForThis: any;

  constructor(
    public questionsSvc: QuestionsService,
    public malcolmSvc: MalcolmService
  ) { }

}
