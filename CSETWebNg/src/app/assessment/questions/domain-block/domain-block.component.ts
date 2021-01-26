import { Component, OnInit, Input } from '@angular/core';
import { Domain } from '../../../models/questions.model';
import { AcetFiltersService } from '../../../services/acet-filters.service';
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
    public questionsSvc: QuestionsService,
    public acetFiltersSvc: AcetFiltersService
  ) { }

  /**
   * 
   */
  ngOnInit() {
  }

  setOrDomainLabel(d: Domain) {
    // Don't show Component Defaults
    if (d.DisplayText == 'Component Defaults') {
      return '';
    }

    // don't show a domain label if it contains a single category with the same name
    if (d.Categories.length === 1 && d.DisplayText === d.Categories[0].GroupHeadingText) {
      return '';
    }

    if (!!d.DisplayText) {
      return d.DisplayText;
    } else if (!!d.SetShortName) {
      return d.SetShortName;
    }
    return '';
  }

}
