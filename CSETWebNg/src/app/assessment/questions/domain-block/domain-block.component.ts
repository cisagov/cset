import { Component, OnInit, Input } from '@angular/core';
import { Domain } from '../../../models/questions.model';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-domain-block',
  templateUrl: './domain-block.component.html'
})
export class DomainBlockComponent implements OnInit {

  @Input('domain') domain;



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
    if (!!d.DisplayText) {
      return d.DisplayText;
    } else if (!!d.SetShortName) {
      return d.SetShortName;
    }
    return '';
  }

}
