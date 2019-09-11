import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'networkwarnings',
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
