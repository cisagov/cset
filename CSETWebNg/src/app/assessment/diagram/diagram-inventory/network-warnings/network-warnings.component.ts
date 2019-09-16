import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'networkwarnings',
  templateUrl: './network-warnings.component.html',
  styleUrls: ['./network-warnings.component.scss']
})
export class NetworkWarningsComponent implements OnInit {
  warnings = [];
  displayedColumns = ['id', 'message']
  constructor() { }

  ngOnInit() {
  }

}
