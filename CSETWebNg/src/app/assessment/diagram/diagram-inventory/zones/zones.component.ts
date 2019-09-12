import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'zones',
  templateUrl: './zones.component.html',
  styleUrls: ['./zones.component.scss']
})
export class ZonesComponent implements OnInit {
  dataSource = [];
  displayedColumns = ['type', 'label', 'sal', 'layer', 'owner', 'visible']
  constructor() { }

  ngOnInit() {
  }

}
