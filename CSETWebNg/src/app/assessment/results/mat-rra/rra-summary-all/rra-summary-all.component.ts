import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-rra-summary-all',
  templateUrl: './rra-summary-all.component.html',
  styleUrls: ['./rra-summary-all.component.scss']
})
export class RraSummaryAllComponent implements OnInit {
  @Input() title = "RRA Summary";
  constructor() { }

  ngOnInit(): void {
  }

}
