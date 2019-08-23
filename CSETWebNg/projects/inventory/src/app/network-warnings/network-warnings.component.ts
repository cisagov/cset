import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-network-warnings',
  templateUrl: './network-warnings.component.html',
  styleUrls: ['./network-warnings.component.scss']
})
export class NetworkWarningsComponent implements OnInit {
  dataSource = [];
  displayedColumns = ['id', 'message']
  constructor() { }

  ngOnInit() {
  }

}
