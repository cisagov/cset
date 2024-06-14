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

import {
  Component,
  EventEmitter,
  OnInit,
  Output, HostListener,
  ApplicationRef
} from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AssessmentService } from '../services/assessment.service';
import { LayoutService } from '../services/layout.service';
import { NavTreeService } from '../services/navigation/nav-tree.service';
import { NavigationService } from '../services/navigation/navigation.service';
import { TranslocoService } from '@ngneat/transloco';
import { ConfigService } from '../services/config.service';

@Component({
  selector: 'app-assessment',
  styleUrls: ['./assessment.component.scss'],
  templateUrl: './assessment.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class AssessmentComponent implements OnInit {
  innerWidth: number;
  innerHeight: number;

  /**
   * Indicates whether the nav panel is visible (true)
   * or hidden (false).
   */
  expandNav = false;

  /**
   * Indicates whether the nav stays visible (true)
   * or auto-hides when the screen is narrow (false).
   */
  lockNav = true;

  widthBreakpoint = 960;
  scrollTop = 0;

  assessmentAlias = this.tSvc.translate('titles.assessment');


  @Output() navSelected = new EventEmitter<string>();
  isSet: boolean;

  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.evaluateWindowSize();
  }

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public navTreeSvc: NavTreeService,
    public layoutSvc: LayoutService,
    public tSvc: TranslocoService,
    private configSvc: ConfigService,
    private appRef: ApplicationRef
  ) {
    this.assessSvc.getAssessmentToken(+this.route.snapshot.params['id']);
    this.assessSvc.getMode();
    this.setTab('prepare');
    this.navSvc.activeResultsView = null;    
    this.isSet=false;
  }

  ngOnInit(): void {
    //This is a hack to force the app to update the view after the assessment is loaded
    //but not the first time.
    if(this.isSet){
      this.isSet = true;
      this.appRef.tick();
    }
    this.evaluateWindowSize();

    if (this.configSvc.behaviors.replaceAssessmentWithAnalysis) {
      this.assessmentAlias = this.tSvc.translate('titles.analysis');
    }

    this.tSvc.langChanges$.subscribe((event) => {
      this.navSvc.buildTree();
    });
  }
 
  setTab(tab) {
    this.assessSvc.currentTab = tab;
  }

  checkActive(tab) {
    return this.assessSvc.currentTab === tab;
  }

  /**
   * Determines how to display the sidenav.
   */
  sidenavMode() {
    if (this.layoutSvc.hp) {
      this.lockNav = false;
      return 'over';
    }

    return this.innerWidth < this.widthBreakpoint ? 'over' : 'side';
  }

  /**
   * Evaluates sidenav drawer behavior based on window size
   */
  evaluateWindowSize() {
    this.innerWidth = window.innerWidth;
    this.innerHeight = window.innerHeight;

    // show/hide lock/unlock the nav drawer based on available width
    if (this.innerWidth < this.widthBreakpoint) {
      this.expandNav = false;
      this.lockNav = false;
    } else {
      this.expandNav = true;
      this.lockNav = true;
    }
  }

  /**
   * Called when the user clicks an item
   * in the nav.
   */
  selectNavItem(target: string) {
    if (!this.lockNav) {
      this.expandNav = false;
    } else {
      this.expandNav = true;
    }

    this.navSvc.navDirect(target);
    setTimeout(() => {
      this.navTreeSvc.setSideNavScrollLocation(target)
    }, 300);
  }

  toggleNav() {
    this.expandNav = !this.expandNav;
  }

  /**
   * Returns the text for the Requirements label.  It might be Statements for ACET assessments.
   */
  requirementsLabel() {
    return 'Requirements';
  }

  /**
   * Fired when the sidenav's opened state changes.
   * @param e
   */
  openStateChange(e) {
    this.expandNav = e;
  }

  // isTocLoading(node) { 
  //   console.log(node);
  //   var s = node?.label;
  //   return  (s === "Please wait" || s === "Loading questions") ;
  // }

  goHome() {
    this.assessSvc.dropAssessment();
    this.router.navigate(['/home']);
  }
}
