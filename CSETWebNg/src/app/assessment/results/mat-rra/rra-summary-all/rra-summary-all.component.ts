import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-rra-summary-all',
  templateUrl: './rra-summary-all.component.html',
  styleUrls: ['./rra-summary-all.component.scss']
})
export class RraSummaryAllComponent implements OnInit {
  @Input() title = "RRA Performance Summary";
  @Input() showNav = true;
  constructor() { }

  ngOnInit(): void {
  }

}
