import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-grouping-block-nested-report',
  templateUrl: './grouping-block-nested-report.component.html',
  styleUrls: ['./grouping-block-nested-report.component.scss']
})
export class GroupingBlockNestedReportComponent implements OnInit {

  @Input('grouping') grouping: any;

  constructor() { }

  ngOnInit(): void {
  }

}
