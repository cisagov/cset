import { Component, OnInit, Input } from '@angular/core';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-domain-block',
  templateUrl: './domain-block.component.html'
})
export class DomainBlockComponent implements OnInit {

  @Input('myContainer') myContainer;

  domains: any;

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

}
