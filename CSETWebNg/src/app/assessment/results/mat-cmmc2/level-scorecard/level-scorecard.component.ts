import { Component, Input } from '@angular/core';
import { LayoutService } from '../../../../services/layout.service';

@Component({
  selector: 'app-level-scorecard',
  templateUrl: './level-scorecard.component.html',
  styleUrl: './level-scorecard.component.scss'
})
export class LevelScorecardComponent {

  @Input()
  response: any;


  /**
   * 
   */
  constructor(
    public layoutSvc: LayoutService
  ) {}
}
