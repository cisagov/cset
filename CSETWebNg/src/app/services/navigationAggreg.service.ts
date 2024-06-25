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
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { AggregationService } from './aggregation.service';

/**
 * A service that provides intelligent NEXT and BACK routing.
 * Some pages are hidden, and this service knows what to do.
 *
 * Maybe someday a single 'navigation service' can be created.
 */
@Injectable({
  providedIn: 'root'
})
export class NavigationAggregService {
  compareType: string = "standards-based";

  pages = [
    {
      pageId: 'trend', path: 'trend',
      condition: () => this.aggregationSvc.mode === 'TREND'
    },
    {
      pageId: 'compare', path: 'compare',
      condition: () => this.aggregationSvc.mode === 'COMPARE'
    },
    {
      pageId: 'alias-assessments', path: 'alias-assessments/{:id}'
    },
    {
      pageId: 'compare-analytics', path: 'compare-analytics/{:id}/{:type}',
      condition: () => this.aggregationSvc.mode === 'COMPARE',
    },
    {
      pageId: 'trend-analytics', path: 'trend-analytics/{:id}',
      condition: () => this.aggregationSvc.mode === 'TREND'
    }
  ];

  /**
   * Constructor
   * @param router
   */
  constructor(
    private aggregationSvc: AggregationService,
    private router: Router
  ) {
  }

  /**
   *
   * @param cur
   */
  navBack(cur: string) {
    // find current page
    const currentPageIndex = this.pages.findIndex(p => p.pageId === cur);
    if (currentPageIndex < 0) {
      return;
    }

    if (currentPageIndex === 0) {
      // we are at the first page, nothing to do
      return;
    }

    let newPageIndex = currentPageIndex;
    let showPage = false;
    while (newPageIndex >= 0 && !showPage) {
      newPageIndex = newPageIndex - 1;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
    }

    const newPath = this.pages[newPageIndex].path.replace('{:id}', this.aggregationSvc.id().toString());
    this.router.navigate([newPath]);
  }


  /**
   *
   * @param cur
   */
  navNext(cur: string) {
    // find current page
    const currentPageIndex = this.pages.findIndex(p => p.pageId === cur);

    if (currentPageIndex < 0) {
      return;
    }

    if (currentPageIndex === this.pages.length - 1) {
      // we are at the last page, nothing to do
      return;
    }

    let newPageIndex = currentPageIndex;
    let showPage = false;
    while (newPageIndex < this.pages.length && !showPage) {
      newPageIndex = newPageIndex + 1;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
    }
    this.aggregationSvc.getAssessments().subscribe({
      next: (data: any) => {
        this.compareType = data.assessments[0].useMaturity ? "maturity-based" : "standards-based";
        const newPath = this.pages[newPageIndex].path.replace('{:id}', this.aggregationSvc.id().toString()).replace('{:type}', this.compareType);
        this.router.navigate([newPath]);
      }
    });
  }

  /**
   * If there is no condition, show.  Otherwise evaluate the condition.
   * @param condition
   */
  shouldIShow(condition: any): boolean {
    if (!condition) {
      return true;
    }

    if (typeof condition === 'boolean') {
      return condition;
    }

    if (typeof condition === 'function') {
      return condition();
    }

    if (condition === 'FALSE') {
      return false;
    }

    return true;
  }
}
