import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-option-block-cis',
  templateUrl: './option-block-cis.component.html'
})
export class OptionBlockCisComponent implements OnInit {

  @Input() opt: any[];

  constructor() { }

  ngOnInit(): void {
    console.log(this.opt);
  }

}
