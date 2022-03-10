import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-anomaly-icons',
  templateUrl: './anomaly-icons.component.html',
  styleUrls: ['./anomaly-icons.component.scss']
})
export class AnomalyIconsComponent implements OnInit {

  @Input() categories: any;

  constructor() { }

  ngOnInit(): void {
  }

}
