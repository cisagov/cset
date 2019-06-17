////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { NavigationService, NavTree } from '../../services/navigation.service';
import { StandardService } from '../../services/standard.service';

@Component({
  selector: 'app-results',
  templateUrl: './results.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ResultsComponent implements OnInit {
  constructor(
    private assessSvc: AssessmentService,
    private navSvc: NavigationService,
    private stdSvc: StandardService,
    private router: Router,
    private route: ActivatedRoute
  ) {

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

    // Build the nav tree
    this.stdSvc.getACET().subscribe(x => this.populateTree(x));
  }

  tree: NavTree[] = [];

  ngOnInit() {
    this.assessSvc.currentTab = 'results';
    this.navSvc.itemSelected.asObservable().subscribe((value: string) => {
      this.router.navigate([value], { relativeTo: this.route });
    });


    // Jump to the previously active view (if known)
    if (!!this.navSvc.activeResultsView) {

      // make sure the tree is up to date before we query it
      this.stdSvc.getACET().subscribe(x => {
        this.populateTree(x);

        // if the 'active' view is no longer in the tree, default to the dashboard view
        if (!this.navSvc.isPathInTree(this.tree, this.navSvc.activeResultsView)) {
          this.navSvc.activeResultsView = 'dashboard';
        }

        this.navSvc.selectItem(this.navSvc.activeResultsView);
      });
    }
  }

  populateTree(acet) {
    const magic = this.navSvc.getMagic();
    this.tree = [
      {
        label: 'Analysis Dashboard', value: 'dashboard', children: [
          { label: 'Control Priorities', value: 'ranked-questions', children: [] },
          // { label: 'Overall Ranked Categories', value: 'overall-ranked-categories', children: [] },
          {
            label: 'Standards Summary', value: 'standards-summary', children: [
              { label: 'Ranked Categories', value: 'standards-ranked', children: [] },
              { label: 'Results by Category', value: 'standards-results', children: [] }
            ]
          },
          // { label: 'Components Summary', value: 'components-summary', children: [
          //   { label: 'Ranked Categories', value: 'components-ranked', children: [] },
          //   { label: 'Results by Category', value: 'components-results', children: [] },
          //   { label: 'Component Types', value: 'components-types', children: [] },
          //   { label: 'Network Warnings', value: 'components-warnings', children: [] }
          // ] },
        ]
      },
      // { label: 'Executive Summary, Overview, & Comments', value: 'overview', children: [] },
      // { label: 'Reports', value: 'reports', children: [] }
    ];

    if (acet) {
      this.tree.push({
        label: 'ACET Information', value: '', children: [
          { children: [], label: 'Cybersecurity Maturity', value: 'maturity' },
          { children: [], label: 'Administration - Review Hours', value: 'admin' },
          { children: [], label: 'ACET Dashboard', value: 'acetDashboard' }
        ]
      });
    }

    this.tree.push({ label: 'Executive Summary, Overview, & Comments', value: 'overview', children: [] });
    this.tree.push({ label: 'Reports', value: 'reports', children: [] });

    this.navSvc.setTree(this.tree, magic);
    this.navSvc.treeControl.expandDescendants(this.navSvc.dataSource.data[0]);
    this.navSvc.treeControl.expandDescendants(this.navSvc.dataSource.data[1]);
  }
}
