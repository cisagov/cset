import { Component, Input, OnInit } from '@angular/core';
import { NgxChartsModule, ColorHelper } from '@swimlane/ngx-charts';
import { VadrDataService } from '../../../../services/vadr-data.service';

@Component({
  selector: 'app-vadr-summary-all',
  templateUrl: './vadr-summary-all.component.html',
  styleUrls: ['./vadr-summary-all.component.scss']
})
export class VadrSummaryAllComponent implements OnInit {
  @Input() title = "RRA Performance Summary";
  @Input() showNav = true;
  constructor() { }

  ngOnInit(): void {
  }

}
