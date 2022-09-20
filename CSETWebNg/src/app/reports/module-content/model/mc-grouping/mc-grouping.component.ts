import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-mc-grouping',
  templateUrl: './mc-grouping.component.html',
  styleUrls: ['./mc-grouping.component.scss']
})
export class McGroupingComponent implements OnInit {

  @Input()
  g: any;

  constructor() { }

  ngOnInit(): void {
  }

}
