import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'edm-q-blocks-horizontal',
  templateUrl: './edm-q-blocks-horizontal.component.html',
  styleUrls: ['./edm-q-blocks-horizontal.component.scss']
})
export class EdmQBlocksHorizontalComponent implements OnChanges {


  /**
   * hand me a list of Qx and a color
   */
  @Input()
  scoresForGoal: any;


  /**
   * 
   * @param maturitySvc 
   */
  constructor(
    public maturitySvc: MaturityService
  ) { }

  /**
   * 
   */
  ngOnChanges(): void {

  }

  /**
   * 
   * @param q 
   */
  getEdmScoreStyle(color: string) {

    switch (color.toLowerCase()) {
      case 'red': return 'red-score';
      case 'yellow': return 'yellow-score';
      case 'green': return 'green-score';
      default: return 'default-score';
    }
  }

}
