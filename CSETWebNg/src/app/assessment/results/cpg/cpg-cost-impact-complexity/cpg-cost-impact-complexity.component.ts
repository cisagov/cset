import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-cpg-cost-impact-complexity',
  templateUrl: './cpg-cost-impact-complexity.component.html',
  styleUrls: ['./cpg-cost-impact-complexity.component.scss']
})
export class CpgCostImpactComplexityComponent implements OnInit {

  @Input()
  cost: string;

  costDisplay = "";

  @Input()
  impact: string;

  @Input()
  complexity: string

  /**
   * 
   */
  constructor() { }

  ngOnInit(): void {
    this.costDisplay = "$".repeat(Number.parseInt(this.cost));
  }

}
