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
import { Router } from '@angular/router';
import { AssessmentService } from '../assessment.service';
import { EventEmitter, Injectable, OnDestroy, OnInit, Output } from "@angular/core";
import { ConfigService } from '../config.service';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { MaturityService } from '../maturity.service';
import { PageVisibilityService } from '../navigation/page-visibility.service';
import { NavTreeService } from './nav-tree.service';
import { CieService } from '../cie.service';
import { QuestionsService } from '../questions.service';


export interface NavTreeNode {
  children?: NavTreeNode[];
  label?: string;
  value?: any;
  DatePublished?: string;
  HeadingTitle?: string;
  HeadingText?: string;
  DocId?: string;
  elementType?: string;
  isCurrent?: boolean;
  expandable: boolean;
  visible: boolean;
  index?: number;
  enabled?: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class NavigationService implements OnDestroy, OnInit {
  /**
   * The workflow is stored in a DOM so that we can easily navigate around the tree
   */
  workflow: Document;

  currentPage = '';

  destinationId = '';


  @Output()
  navItemSelected = new EventEmitter<any>();

  @Output()
  scrollToQuestion = new EventEmitter<string>();

  @Output()
  disableNext = new EventEmitter<boolean>();

  activeResultsView: string;

  frameworkSelected = false;
  acetSelected = false;
  diagramSelected = true;

  cisSubnodes = null;

  /**
   * Defines the grouping or question to scroll to when "resuming"
   */
  resumeQuestionsTarget: string = null;



  /**
   *
   */
  constructor(
    private assessSvc: AssessmentService,
    private configSvc: ConfigService,
    private router: Router,
    private http: HttpClient,
    private maturitySvc: MaturityService,
    private pageVisibliltySvc: PageVisibilityService,
    private navTreeSvc: NavTreeService,
    private questionsSvc: QuestionsService    
  ) {
    this.setWorkflow('omni');
    this.assessSvc.assessmentStateChanged$.subscribe((reloadState) => {
      switch (reloadState) {
        case 123:
          // remembers state of ToC dropdown for CIE
          if (this.assessSvc.usesMaturityModel('CIE')) {
            this.navTreeSvc.applyCieToCStates();
          }
          break;
        case 124:
          this.buildTree();
          this.setNextEnabled(true);
          //this.navDirect('dashboard');
          break;
        case 125:
          if (this.assessSvc.usesMaturityModel('CIE')) {
            this.navTreeSvc.applyCieToCStates();
          }
          this.buildTree();
          this.navDirect('phase-prepare');
          
          break;
        case 126:
          // refresh tree only
          this.buildTree();
          break;
      }
    });
  }

  ngOnInit(): void {
    // remembers state of ToC dropdown for CIE
    if (this.assessSvc.usesMaturityModel('CIE')) {
      this.navTreeSvc.applyCieToCStates();
      this.buildTree();

    }
  }

  ngOnDestroy() {
    this.assessSvc.assessmentStateChanged$.unsubscribe()
  }

  /**
   * Generates a random 'magic number'.
   */
  getMagic() {
    this.navTreeSvc.magic = (Math.random() * 1e5).toFixed(0);
    return this.navTreeSvc.magic;
  }

  /**
   *
   */
  getFramework() {
    return this.http.get(this.configSvc.apiUrl + 'standard/IsFramework');
  }

  setACETSelected(acet: boolean) {
    this.acetSelected = acet;
    this.navTreeSvc.buildTree(this.workflow, this.getMagic());
  }

  setFrameworkSelected(framework: boolean) {
    this.frameworkSelected = framework;
    this.navTreeSvc.buildTree(this.workflow, this.getMagic());
  }

  /**
   *
   */
  setWorkflow(name: string) {
    const url = 'assets/navigation/workflow-' + name + '.xml';
    this.http.get(url, { responseType: 'text' }).subscribe((xml: string) => {

      // build the workflow DOM
      let d = new DOMParser();
      this.workflow = d.parseFromString(xml, 'text/xml');

      // populate displaytext for CIS and MVRA using API-sourced grouping titles
      this.maturitySvc.mvraGroupings.forEach(t => {
        const e = this.workflow.getElementById('maturity-questions-nested-' + t.id);
        if (!!e) {
          e.setAttribute('displaytext', t.title);
        }
      });

      this.maturitySvc.cisGroupings.forEach(t => {
        const e = this.workflow.getElementById('maturity-questions-nested-' + t.id);
        if (!!e) {
          if (!!t.titlePrefix) {
            e.setAttribute('displaytext', t.titlePrefix + '. ' + t.title);
          } else {
            e.setAttribute('displaytext', t.title);
          }
        }
      });


      // build the sidenav tree
      this.navTreeSvc.buildTree(this.workflow, this.getMagic());
    },
      (err: HttpErrorResponse) => {
        console.error(err);
      });
  }

  /**
   * Loads an assessment and navigates to the Prepare tab
   * so that the user starts on the first page of the workflow.
   */
  beginAssessment(assessmentId: number) {
    this.assessSvc.loadAssessment(assessmentId).then(() => {
      if (this.configSvc.installationMode == "CF") {
        this.assessSvc.initCyberFlorida(assessmentId);
      }
      else {
        if (this.assessSvc.usesMaturityModel('CIE')) {
          this.navTreeSvc.applyCieToCStates();
        }
        this.navDirect('phase-prepare');
      }
    });
  }

  beginNewAssessmentGallery(item: any) {
    this.assessSvc.newAssessmentGallery(item).then(() => {
      if (this.assessSvc.usesMaturityModel('CIE')) {
        this.navTreeSvc.applyCieToCStates();
      }
      this.navDirect('phase-prepare');
    });
  }

  /**
   *
   */
  buildTree() {
    this.navTreeSvc.buildTree(this.workflow, this.getMagic());
  }

  /**
   *
   */
  setQuestionsTree() {
    this.navTreeSvc.setQuestionsTree();
  }

  /**
   * Crawls the workflow document to determine the next viewable page.
   */
  navNext(cur: string) {
    const originPage = this.workflow.getElementById(cur);
    if (originPage == null) {
      console.error('navNext: cannot find node ' + cur);
      return;
    }

    if (originPage.children.length == 0 && originPage.nextElementSibling == null && originPage.parentElement.tagName == 'nav') {
      // we are at the last page, nothing to do
      return;
    }

    let target = originPage;

    try {
      do {
        if (target.children.length > 0) {
          target = <HTMLElement>target.firstElementChild;
        } else {
          while (!target.nextElementSibling) {
            target = <HTMLElement>target.parentElement;
          }
          target = <HTMLElement>target.nextElementSibling;
        }
      } while (!this.pageVisibliltySvc.canLandOn(target) || !this.pageVisibliltySvc.showPage(target));
    } catch (e) {
      //TODO:  Check to see if we are in a CF assessment and if so then disable the next button
      this.setNextEnabled(false);
    }

    this.routeToTarget(target);
  }

  isNextEnabled(cur: string): boolean {
    if (!this.workflow) return true;
    const originPage = this.workflow.getElementById(cur);

    if (originPage == null) {
      return true;
    }

    if (originPage.children.length == 0 && originPage.nextElementSibling == null && originPage.parentElement.tagName == 'nav') {
      // we are at the last page, nothing to do
      return false;
    }

    let target = originPage;

    try {
      do {
        if (target.children.length > 0) {
          target = <HTMLElement>target.firstElementChild;
        } else {
          while (!target.nextElementSibling) {
            target = <HTMLElement>target.parentElement;
          }
          target = <HTMLElement>target.nextElementSibling;
        }
      } while (!(this.pageVisibliltySvc.canLandOn(target)
        && this.pageVisibliltySvc.showPage(target)
        && this.pageVisibliltySvc.isEnabled(target)));
    } catch (e) {
      //TODO:  Check to see if we are in a CF assessment and if so then disable the next button
      return false;
    }
    return true;
  }

  /**
   * Enables or disables the next button
   * @param enableNext 
   */
  setNextEnabled(enableNext: boolean) {
    this.disableNext.emit(enableNext);
  }

  /**
   * Crawls the workflow document to determine the previous viewable page.
   */
  navBack(cur: string) {
    const originPage = this.workflow.getElementById(cur);

    if (originPage == null) {
      return;
    }

    if (originPage.previousElementSibling == null && originPage.parentElement.tagName == 'nav') {
      // we are at the first page, nothing to do
      return;
    }

    let target = originPage;

    do {
      if (target.children.length > 0) {
        target = <HTMLElement>target.lastElementChild;
      } else {
        while (!target.previousElementSibling) {
          target = <HTMLElement>target.parentElement;
        }
        target = <HTMLElement>target.previousElementSibling;
      }
    } while (!this.pageVisibliltySvc.canLandOn(target) || !this.pageVisibliltySvc.showPage(target));

    this.routeToTarget(target);
  }

  /**
   * Routes to the first available node in the workflow
   */
  navFirst() {
    debugger;
    const startPage = this.workflow.firstElementChild;
  }

  /**
   * Routes to the path configured for the specified pageId.
   * @param value
   */
  navDirect(id: string) {
    // if the target is a simple string, find it in the pages structure
    // and navigate to its path
    if (typeof id == 'string') {
      let target = this.workflow.getElementById(id);

      if (target == null) {
        console.error('Cannot find \'' + id + ' \'in workflow document');
        return;
      }

      // if they clicked on a tab there won't be a path -- nudge them to the next page
      if (!target.hasAttribute('path')) {
        this.navNext(id);
        return;
      }

      this.routeToTarget(target);
      return;
    }
  }

  /**
   * Navigates to the path specified in the target node.
   */
  routeToTarget(targetNode: HTMLElement) {
    this.navTreeSvc.setCurrentPage(targetNode.id);
    this.destinationId = targetNode.id;

    this.buildTree();

    // determine the route path
    const targetPath = targetNode.attributes['path'].value.replace('{:id}', this.assessSvc.id().toString());
    this.router.navigate([targetPath]);
  }

  /**
   * Determines if the specified page is the first visible page in the nav flow.
   * Used to hide the "Back" button.
   * @returns
   */
  isFirstVisiblePage(id: string): boolean {
    if (!this.workflow) {
      return false;
    }

    let target = this.workflow.getElementById(id);

    if (!target) {
      console.error(`No workflow element found for id '${id}'`);
      return false;
    }

    do {
      if (!target.previousElementSibling) {
        while (!target.previousElementSibling && target.tagName != 'nav') {
          target = <HTMLElement>target.parentElement;
        }
        target = <HTMLElement>target.previousElementSibling;
      } else {
        target = <HTMLElement>target.previousElementSibling;
      }
    } while (!!target && !this.pageVisibliltySvc.showPage(target));

    if (!target) {
      return true;
    }

    return false;
  }

  /**
   * Determines if the specified page is the last visible page in the nav flow.
   * Used to hide the "Next" button.
   * @returns
   */
  isLastVisiblePage(id: string): boolean {
    if (!this.workflow) {
      return false;
    }

    let target = this.workflow.getElementById(id);
    if (!target) {
      console.error(`No workflow element found for id ${id}`);
      return false;
    }

    do {
      if (target.children.length > 0) {
        target = <HTMLElement>target.firstElementChild;
      } else if (!target.nextElementSibling) {
        while (!target.nextElementSibling && target.tagName != 'nav') {
          target = <HTMLElement>target.parentElement;
        }
        target = <HTMLElement>target.nextElementSibling;
      } else {
        target = <HTMLElement>target.nextElementSibling;
      }
    } while (!!target && !this.pageVisibliltySvc.showPage(target));

    if (!target) {
      return true;
    }

    return false;
  }

  /**
   *
   */
  setCurrentPage(id: string) {
    this.navTreeSvc.setCurrentPage(id);
  }

  /**
   * 
   */
  clearNoMatterWhat() {
    this.navTreeSvc.clearNoMatterWhat();
  }

  /**
   * Jump to the last question answered.
   */
  resumeQuestions() {
    this.http.get(this.configSvc.apiUrl + 'contacts/bookmark', { responseType: 'text' }).subscribe(x => {

      if (!x) {
        this.navDirect('phase-assessment');
        return;
      }


      // set the target so that the question page will know where to scroll to
      this.resumeQuestionsTarget = x;


      // is there a specific nav node for the grouping? (nested)
      var g = x.split(',').find(x => x.startsWith('MG:'))?.replace('MG:', '');
      let e = this.workflow.getElementById('maturity-questions-nested-' + g);
      if (!!e) {
        this.navDirect(e.id);
        return;
      }

      // is there a specific nav node for the grouping? (CIE nested)
      // get the parent grouping if it exists
      var pg = x.split(',').find(x => x.startsWith('PG:'))?.replace('PG:', '');
      if (pg != null) {
        e = this.workflow.getElementById('maturity-questions-cie-' + pg);
      } else {
        e = this.workflow.getElementById('maturity-questions-cie-' + g);
      }

      if (!!e) {
        // set to Principle scope
        if (+g <= 2632) {
          this.questionsSvc.setMode('P')
        }
        //set to Principle-Phase scope
        else {
          this.questionsSvc.setMode('F')
        }
        this.navDirect(e.id);
        return;
      }


      // if we don't have to land on a specific nested page, we should be able to just jump to the assessment phase
      this.navDirect('phase-assessment');
    });
  }
}
