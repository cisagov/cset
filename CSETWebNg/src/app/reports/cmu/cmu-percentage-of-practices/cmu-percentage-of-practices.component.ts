import { Component, Input, OnChanges, OnInit } from '@angular/core';

@Component({
  selector: 'app-cmu-percentage-of-practices',
  templateUrl: './cmu-percentage-of-practices.component.html',
  styleUrls: ['./cmu-percentage-of-practices.component.scss']
})
export class CmuPercentageOfPracticesComponent implements OnChanges {

  @Input() model: any;

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

    for (let i = 0; i < this.model?.reportChart.labels.length; i++) {
      var domain = { name: this.model.reportChart.labels[i], value: this.model.reportChart.values[i] };
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
