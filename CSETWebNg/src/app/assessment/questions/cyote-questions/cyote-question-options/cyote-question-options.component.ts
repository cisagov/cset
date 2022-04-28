import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-cyote-question-options',
  templateUrl: './cyote-question-options.component.html',
  styleUrls: ['./cyote-question-options.component.scss']
})
export class CyoteQuestionOptionsComponent implements OnInit {

  @Input('question') q: any;

  constructor() { }

  ngOnInit(): void {
  }

}
