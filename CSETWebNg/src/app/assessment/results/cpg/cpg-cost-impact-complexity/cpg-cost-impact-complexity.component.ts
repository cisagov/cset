////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, Input, OnInit } from '@angular/core';
import { TranslocoService } from '@ngneat/transloco';

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
  impactWord: string;

  @Input()
  complexity: string
  complexityWord: string;

  /**
   * 
   */
  constructor(
    private tSvc: TranslocoService
  ) { }

  ngOnInit(): void {
    this.greenDollars = "$".repeat(Number.parseInt(this.cost));
    this.grayDollars = "$".repeat(4 - Number.parseInt(this.cost));

    // i18n
    this.impactWord = !!this.impact ? this.tSvc.translate('reports.core.cpg.report.' + this.impact.toLowerCase()) : 'UNKNOWN';
    this.complexityWord = !!this.complexity ? this.tSvc.translate('reports.core.cpg.report.' + this.complexity.toLowerCase()) : 'UNKNOWN';
  }

  lowMedHigh(val: string) {
    return "lmh " + (!!val ? val.toLocaleLowerCase() : 'low');
  }
}
