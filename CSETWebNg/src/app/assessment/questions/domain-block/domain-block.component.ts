import { Component, OnInit, Input } from '@angular/core';
import { Domain } from '../../../models/questions.model';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-domain-block',
  templateUrl: './domain-block.component.html'
})
export class DomainBlockComponent implements OnInit {

  @Input('domain') domain: any;



  /** 
   * 
   */
  constructor(
    public questionsSvc: QuestionsService
  ) { }

  /**
   * 
   */
  ngOnInit() {
  }

  setOrDomainLabel(d: Domain) {
    // Don't show Component Defaults
    if (d.displayText == 'Component Defaults') {
      return '';
    }

    // don't show a domain label if it contains a single category with the same name
    if (d.categories.length === 1 && d.displayText === d.categories[0].groupHeadingText) {
      return '';
    }

    if (!!d.displayText) {
      return d.displayText;
    } else if (!!d.setShortName) {
      return d.setShortName;
    }
    return '';
  }

}
