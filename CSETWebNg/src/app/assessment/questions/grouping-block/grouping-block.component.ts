import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-grouping-block',
  templateUrl: './grouping-block.component.html'
})
export class GroupingBlockComponent implements OnInit {

  @Input('grouping') grouping: any;


  constructor() { }

  ngOnInit(): void {
  }

}
