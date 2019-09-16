import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'zones',
  templateUrl: './zones.component.html',
  styleUrls: ['./zones.component.scss']
})
export class ZonesComponent implements OnInit {
  zones = [];
  displayedColumns = ['type', 'label', 'sal', 'layer', 'owner', 'visible']
  constructor() { }

  ngOnInit() {
  }

}
