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
import {
  Component,
  EventEmitter,
  OnInit,
  Output,
  ViewChild,
  HostListener,
  AfterContentInit, 
  OnChanges,
  ChangeDetectorRef,
  AfterContentChecked
} from '@angular/core';
import { MatSidenav } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { AssessmentService } from '../services/assessment.service';
import { NavigationService } from '../services/navigation.service';

@Component({
  selector: 'app-assessment',
  templateUrl: './assessment.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class AssessmentComponent implements AfterContentChecked {
  innerWidth: number;
  innerHeight: number;

  /**
   * Indicates whether the nav panel is visible (true)
   * or hidden (false).
   */
  expandNav = true;

  /**
   * Indicates whether the nav stays visible (true)
   * or auto-hides when the screen is narrow (false).
   */
  lockNav = true;

  minWidth = 960;
  scrollTop = 0;

  @Output() navSelected = new EventEmitter<string>();
  @ViewChild('sNav')
  sideNav: MatSidenav;
  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.innerWidth = window.innerWidth;
    this.innerHeight = window.innerHeight;
    if (this.expandNav) {
      if (this.innerWidth < this.minWidth) {
        this.expandNav = false;
        this.lockNav = false;
      } else {
        this.expandNav = true;
        this.lockNav = true;
      }
    }
  }

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    public assessSvc: AssessmentService,
    public navSvc: NavigationService, 
    private cd: ChangeDetectorRef
  ) {
    this.assessSvc.getAssessmentToken(+this.route.snapshot.params['id']);
    this.assessSvc.getMode();
    this.assessSvc.currentTab = 'prepare';
    this.navSvc.activeResultsView = null;
    console.log('load assessment');
    if(localStorage.getItem('tree')){
      this.navSvc.buildTree(this.navSvc.getMagic());
    }
    
   
  }

  ngAfterContentChecked() {
    this.cd.detectChanges();
  }

  setTab(tab){
    this.assessSvc.currentTab = tab;
  }
  
  checkActive(tab){
    return this.assessSvc.currentTab === tab;
  }

  selectNavItem(target: string) {
    if (!this.lockNav) {
      this.expandNav = false;
    } else {
      this.expandNav = true;
    }

    this.navSvc.navDirect(target);
  }

  toggleNav() {
    this.expandNav = !this.expandNav;
  }

  handleScroll(component: string) {
    const element = document.getElementById(component);
    if (
      element.scrollTop < this.scrollTop &&
      document.scrollingElement.scrollTop > 0
    ) {
      document.scrollingElement.scrollTo({ behavior: 'smooth', top: 0 });
    }
    this.scrollTop = element.scrollTop;
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

  isTocLoading(s){
    return s === "Please wait" || s === "Loading questions";
  }
}
