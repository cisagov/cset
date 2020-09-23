import { Component, OnInit, Input } from '@angular/core';
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

}
