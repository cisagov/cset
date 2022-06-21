import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'merge-examinations',
  templateUrl: './merge-examinations.component.html'
})
export class MergeExaminationsComponent implements OnInit {

  @Input() page: string;

  constructor() { }

  ngOnInit(): void {
      
  }

}