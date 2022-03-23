import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-option-block-cis',
  templateUrl: './option-block-cis.component.html'
})
export class OptionBlockCisComponent implements OnInit {

  @Input() q: any;
  @Input() opts: any[];

  optRadio: any[];
  optCheckbox: any[];
  optOther: any[];

  showIdTag = true;
  showWeightTag = false;

  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {
    // break up the options so that we can group radio buttons in a mixed bag of options
    this.optRadio = this.opts.filter(x => x.optionType == 'Radio');
    this.optCheckbox = this.opts.filter(x => x.optionType == 'Checkbox');
    this.optOther = this.opts.filter(x => x.optionType != 'Radio' && x.optionType != 'Checkbox');
  }

  /**
   * 
   */
  changeRadio(o, event): void {
    o.selected = event.target.checked;
    console.log(o);
    console.log(event);
  }

  changeCheckbox(o, event): void {
    o.selected = event.target.checked;
    console.log(o);
    console.log(event);
  }

}
