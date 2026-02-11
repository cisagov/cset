////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Component, Input, OnChanges, OnInit } from '@angular/core';

@Component({
    selector: 'app-cmu-domain-compliance',
    templateUrl: './cmu-domain-compliance.component.html',
    styleUrls: ['./cmu-domain-compliance.component.scss'],
    standalone: false
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
