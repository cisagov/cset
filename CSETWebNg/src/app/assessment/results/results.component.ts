////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, OnInit } from '@angular/core';
import {
  ActivatedRoute,
  Router, RouterEvent, NavigationEnd, UrlTree, PRIMARY_OUTLET, UrlSegmentGroup, UrlSegment
} from '../../../../node_modules/@angular/router';
import { AssessmentService } from '../../services/assessment.service';
import { NavTreeNode } from '../../services/navigation.service';
import { AnalyticsService } from '../../services/analytics.service';
import { NavigationService } from '../../services/navigation.service';

@Component({
  selector: 'app-results',
  templateUrl: './results.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ResultsComponent implements OnInit {

  /**
   * 
   */
  constructor(
    private assessSvc: AssessmentService,
    private navSvc: NavigationService,
    private router: Router
  ) {
    console.log('results constructor');

    // Store the active results view based on the new navigation target
    this.router.events.subscribe((event: RouterEvent) => {
      if (event instanceof NavigationEnd) {
        const tree: UrlTree = this.router.parseUrl(event.urlAfterRedirects);
        const g: UrlSegmentGroup = tree.root.children[PRIMARY_OUTLET];
        const s: UrlSegment[] = g.segments;

        // Grab the segment following /results/ and set that as the active results view
        for (let i: number = 0; i < s.length; i++) {
          if (s[i].path === 'results') {
            if (s.length >= (i + 2)) {
              this.navSvc.activeResultsView = s[i + 1].path;
              break;
            }
          }
        }
      }
    });
  }


  ngOnInit() {
    this.assessSvc.currentTab = 'results';
  }
}
