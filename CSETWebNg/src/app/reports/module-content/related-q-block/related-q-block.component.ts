import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-related-q-block',
  templateUrl: './related-q-block.component.html'
})
export class RelatedQBlockComponent implements OnInit {

  @Input()
  questions;

  constructor() { }
  

  ngOnInit(): void {
  }

}
