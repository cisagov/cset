import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-domain-block',
  templateUrl: './domain-block.component.html'
})
export class DomainBlockComponent implements OnInit {

  @Input('myContainer') myContainer;

  /** 
   * 
   */
  constructor() { }

  /**
   * 
   */
  ngOnInit() {
  }

}
