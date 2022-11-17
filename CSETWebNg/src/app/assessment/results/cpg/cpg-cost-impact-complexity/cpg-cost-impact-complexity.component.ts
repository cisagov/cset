import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-cpg-cost-impact-complexity',
  templateUrl: './cpg-cost-impact-complexity.component.html',
  styleUrls: ['./cpg-cost-impact-complexity.component.scss']
})
export class CpgCostImpactComplexityComponent implements OnInit {

  @Input()
  cost: string;

  greenDollars = "";
  grayDollars = "";

  @Input()
  impact: string;

  @Input()
  complexity: string

  /**
   * 
   */
  constructor() { }

  ngOnInit(): void {
    this.greenDollars = "$".repeat(Number.parseInt(this.cost));
    this.grayDollars = "$".repeat(4 - Number.parseInt(this.cost));
  }

  lowMedHigh(val: string) {
    return "lmh " + val.toLocaleLowerCase();
  }
}
