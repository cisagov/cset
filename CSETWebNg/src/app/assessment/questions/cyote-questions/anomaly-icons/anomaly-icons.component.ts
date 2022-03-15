import { Component, Input, OnInit } from '@angular/core';
import { CyoteObservable } from '../../../../models/cyote.model';

@Component({
  selector: 'app-anomaly-icons',
  templateUrl: './anomaly-icons.component.html',
  styleUrls: ['./anomaly-icons.component.scss']
})
export class AnomalyIconsComponent implements OnInit {

  @Input() o: CyoteObservable;

  constructor() { }

  ngOnInit(): void {
  }

  /**
   * 
   */
  hasCat(cat: string): boolean {
    return false; //this.o.optionMap.has(cat);
  }

  hasAnyCat(): boolean {
    // for (var i = 0; i < this.o.optionMap.keys.length; i++) {
    //   if (this.o.optionMap.keys[i].endsWith(' Category')) {
    //     return true;
    //   }
    //   return false;
    // }
    return false;
  }
}
