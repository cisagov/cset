import { AfterViewChecked, Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { CreService } from '../../../services/cre.service';

@Component({
  selector: 'app-cre-subdomain-charts',
  templateUrl: './cre-subdomain-charts.component.html',
  styleUrls: ['../../reports.scss'],
  standalone: false,
})
export class CreSubdomainChartsComponent implements OnChanges {

  @Input() domainDistrib: any;

  stackedModel: any[];

  stackedHeight: number;
  stackedPadding: number;

  constructor(
    public creSvc: CreService
  ) {  }

  /**
   * 
   */
  ngOnChanges(changes: SimpleChanges): void {
    if (!!this.domainDistrib) { 
      this.stackedModel = this.domainDistrib.subgroups;
      this.calcStackedHeight();
    }
  }

  /**
   * 
   */
  calcStackedHeight() {
    this.stackedHeight = Math.max(200, this.domainDistrib.subgroups.length * 50 + 100);
    this.stackedPadding = Math.max(10, 30 - this.domainDistrib.subgroups.length);
  }
}
