import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-mc-question',
  templateUrl: './mc-question.component.html',
  styleUrls: ['./mc-question.component.scss']
})
export class McQuestionComponent implements OnInit {

  @Input()
  q: any;

  constructor() { }

  ngOnInit(): void {
  }

}
