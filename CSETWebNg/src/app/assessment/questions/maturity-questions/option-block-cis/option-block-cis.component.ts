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

  optionGroupName = '';

  // temporary debug aids
  showIdTag = false;
  showWeightTag = false;

  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {
    // break up the options so that we can group radio buttons in a mixed bag of options
    this.optRadio = this.opts?.filter(x => x.optionType == 'radio');
    this.optCheckbox = this.opts?.filter(x => x.optionType == 'checkbox');
    this.optOther = this.opts?.filter(x => x.optionType != 'radio' && x.optionType != 'checkbox');

    // create a random 'name' that can be used to group the radios in this block
    this.optionGroupName = this.makeId(8);
  }

  /**
   * 
   */
  changeRadio(o, event): void {
    o.selected = event.target.checked;
    console.log(o);
  }

  /**
   * 
   */
  changeCheckbox(o, event): void {
    o.selected = event.target.checked;
    console.log(o);
  }

  /**
   * 
   */
  makeId(length) {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
      result += characters.charAt(Math.floor(Math.random() *
        charactersLength));
    }
    return result;
  }
}
