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
import { Component, Input, OnChanges } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-crr-heatmap',
  templateUrl: './crr-heatmap.component.html'
})
export class CrrHeatmapComponent implements OnChanges {
  @Input()
    domainAbbrev: string;

  public milHeatmaps: MilSvg[] = [];

  /**
   *
   * @param maturitySvc
   */
  constructor(public maturitySvc: MaturityService) {}

  /**
   *
   */
  ngOnChanges(): void {
    if (!this.domainAbbrev) {
      return;
    }

    for (let i = 1; i <= 5; i++) {
      this.maturitySvc.getMilHeatmapWidget(this.domainAbbrev, 'MIL-' + i).subscribe((svg: string) => {
        // parse the SVG and read the MIL value from the root element
        const p = new DOMParser();
        const x = p.parseFromString(svg, 'text/xml');
        const id = x.documentElement.getAttribute('data-mil');

        this.milHeatmaps.push({ milId: id, svg: svg });
      });
    }
  }

  /**
   *
   * @param i
   * @returns
   */
  show(i: string): string {
    if (!this.milHeatmaps) {
      return '';
    }

    const h = this.milHeatmaps.find((h) => h.milId == i);
    if (!h) {
      return '';
    }

    return h.svg;
  }
}

/**
 * A helper class to keep track of SVGs and their corresponding MIL IDs
 */
export class MilSvg {
  public milId: string;
  public svg: string;
}
