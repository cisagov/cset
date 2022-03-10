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

}
