import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-zones',
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
