import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-glossary-term',
  templateUrl: './glossary-term.component.html'
})
export class GlossaryTermComponent implements OnInit {

  @Input()
  term: string;

  @Input()
  definition: string;

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
