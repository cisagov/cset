import { Component, Input, OnChanges, OnInit } from '@angular/core';

@Component({
  selector: 'app-cmu-domain-compliance',
  templateUrl: './cmu-domain-compliance.component.html',
  styleUrls: ['./cmu-domain-compliance.component.scss']
})
export class CmuDomainComplianceComponent implements OnChanges {

  @Input() data: any;

  colorScheme1 = { domain: ['#007BFF'] };
  xAxisTicks = [0, 25, 50, 75, 100];

  domainCompliance = [];

  /**
   * 
  */
 ngOnChanges(): void {
   this.createDomainCompliance();
  }

  /**
   * 
   */
  createDomainCompliance() {
    let domainList = [];

    for (let i = 0; i < this.data?.labels.length; i++) {
      var domain = { name: this.data.labels[i], value: this.data.values[i] };
      domainList.push(domain);
    }

    this.domainCompliance = domainList;
  }

  /**
   * 
   */
  formatPercent(x: any) {
    return x + '%';
  }
}
