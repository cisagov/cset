import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-option-block',
  templateUrl: './option-block.component.html'
})
export class OptionBlockComponent implements OnInit {

  @Input()
  question: any;

  /**
   * 
   */
  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {
  }

}
