import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'links',
  templateUrl: './links.component.html',
  styleUrls: ['./links.component.scss']
})
export class LinksComponent implements OnInit {
  dataSource = [];
  displayedColumns = ['label', 'subnetName', 'security', 'layer', 'headLineDecorator', 'tailLineDecorator', 'lineType', 'thickness', 'color', 'color', 'linkType', 'visible']
  constructor() { }

  ngOnInit() {
  }

}
