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
import { Router, ActivatedRoute } from '@angular/router';
import { AssessmentService } from './assessment.service';
import { NestedTreeControl } from "@angular/cdk/tree";
import { EventEmitter, Injectable, Output } from "@angular/core";
import { MatTreeNestedDataSource } from "@angular/material";
import { of as observableOf, BehaviorSubject } from "rxjs";
import { ConfigService } from './config.service';
import { HttpClient } from '@angular/common/http';
import { AnalyticsService } from './analytics.service';


export interface NavTreeNode {
  children?: NavTreeNode[];
  label?: string;
  value?: any;
  DatePublished?: string;
  HeadingTitle?: string;
  HeadingText?: string;
  DocId?: string;
  elementType?: string;
  isPhaseNode?: boolean;
  isCurrent?: boolean;
  expandable: boolean;
  visible: boolean;
}

/**
 * A service that provides intelligent NEXT and BACK routing.
 * Some pages are hidden, and this service knows what to do.
 * 
 * It also renders the structure for the side nav / table of contents / TOC.
 */
@Injectable({
  providedIn: 'root'
})
export class NavigationService {

  private magic: string;

  @Output()
  navItemSelected = new EventEmitter<any>();

  dataSource: MatTreeNestedDataSource<NavTreeNode> = new MatTreeNestedDataSource<NavTreeNode>();
  dataChange: BehaviorSubject<NavTreeNode[]> = new BehaviorSubject<NavTreeNode[]>([]);
  treeControl: NestedTreeControl<NavTreeNode>;

  currentNode: string;

  frameworkSelected = false;
  acetSelected = false;
  diagramSelected = true;

  activeResultsView: string;

  analyticsIsUp = false;

  /**
   * Constructor
   * @param router
   */
  constructor(
    private http: HttpClient,
    private assessSvc: AssessmentService,
    private analyticsSvc: AnalyticsService,
    private router: Router,
    private activatedRoute: ActivatedRoute,
    private configSvc: ConfigService
  ) {

    // set up the mat tree control and its data source
    this.treeControl = new NestedTreeControl<NavTreeNode>(this.getChildren);
    this.dataSource = new MatTreeNestedDataSource<NavTreeNode>();
    this.dataChange.subscribe(data => {
      console.log('dataChange happened');
      this.dataSource.data = data;
      this.treeControl.dataNodes = data;
      this.treeControl.expandAll();
    });

    this.analyticsSvc.pingAnalyticsService().subscribe(data => {
      this.analyticsIsUp = true;
    });
  }

  private getChildren = (node: NavTreeNode) => { return observableOf(node.children); };

  /**
   * 
   */
  getMagic() {
    this.magic = (Math.random() * 1e5).toFixed(0);
    return this.magic;
  }

  /**
   * 
   * @param magic 
   */
  buildTree(magic: string) {
    if (this.magic === magic) {
      // this.saveExpandedNodes();
      this.dataSource.data = this.buildTocData();
      this.treeControl.dataNodes = this.dataSource.data;
      this.treeControl.expandAll();
    }
  }

  /**
   * 
   */
  setTree(tree: NavTreeNode[], magic: string, collapsible: boolean = true) {
    if (this.magic === magic) {
      this.treeControl = new NestedTreeControl<NavTreeNode>((node: NavTreeNode) => {
        return observableOf(node.children);
      });
      this.saveExpandedNodes();
      this.dataSource = new MatTreeNestedDataSource<NavTreeNode>();
      this.dataSource.data = tree;
      this.treeControl.dataNodes = tree;
      this.treeControl.expandAll();
    }
  }

  expandedNodes: NavTreeNode[];

  saveExpandedNodes() {
    this.expandedNodes = new Array<NavTreeNode>();
    console.log(this.treeControl.dataNodes);
    this.treeControl.dataNodes.forEach(node => {
      console.log(node);
      if (node.expandable && this.treeControl.isExpanded(node)) {
        this.expandedNodes.push(node);
      }
    });
  }

  restoreExpandedNodes() {
    if (!!this.expandedNodes) {
      this.expandedNodes.forEach(node => {
        this.treeControl.expand(this.treeControl.dataNodes.find(n => n.value === node.value));
      });
    }
  }

  hasNestedChild(_: number, node: NavTreeNode) {
    return node.children.length > 0;
  }

  /**
   * Returns a list of tree node elements
   */
  buildTocData(): NavTreeNode[] {
    console.log('buildTocData');
    console.log(this.currentNode);
    const toc: NavTreeNode[] = [];

    for (let i = 0; i < this.pages.length; i++) {
      let p = this.pages[i];
      let visible = this.shouldIShow(p.condition);

      const node: NavTreeNode = {
        label: p.displayText,
        value: p.pageClass,
        isPhaseNode: false,
        children: [],
        expandable: true,
        visible: visible
      };

      if (p.level === 0) {
        node.isPhaseNode = true;
      }

      node.isCurrent = (p.pageClass === this.currentNode);

      const parentPage = this.findParentPage(i);
      if (!!parentPage) {
        const parentNode = this.findInTree(toc, parentPage.pageClass);
        if (!!parentNode) {
          parentNode.children.push(node);
        }
      } else {
        toc.push(node);
      }
    }

    // console.log(JSON.stringify(toc));
    return toc;
  }

  /**
   * Back-tracks thru the pages to find the previous page with a lower level number
   */
  findParentPage(i: number) {
    let j = i;
    do {
      j--;
    }
    while (j >= 0 && this.pages[j].level >= this.pages[i].level);

    if (j < 0) {
      return null;
    }

    return this.pages[j];
  }

  /**
   * Recurses a list of NavTreeNode and their children for a
   * className.
   */
  findInTree(tree: NavTreeNode[], className: string) {
    let result = null;
    for (let i = 0; i < tree.length; i++) {
      let node = tree[i];
      if (node.value === className) {
        return node;
      }

      if (node.children.length > 0) {
        result = this.findInTree(node.children, className);
        if (!!result) {
          return result;
        }
      }
    }

    return result;
  }

  /**
   * Sets all nodes in the tree to NOT be current
   */
  setNoCurrentPage(tree: NavTreeNode[]) {
    for (let i = 0; i < tree.length; i++) {
      let node = tree[i];
      node.isCurrent = false;

      if (node.children.length > 0) {
        this.setNoCurrentPage(node.children);
      }
    }
  }

  /**
   * Replaces the children of the Questions node with
   * the values supplied.
   */
  setQuestionsTree(tree: NavTreeNode[], magic: string, collapsible: boolean) {
    // find the questions node
    const questionsNode = this.dataSource.data.find(x => x.value === 'questions');
    console.log('setQuestionsTree: ');
    console.log(questionsNode);

    // purge its children


    // insert the new questions

  }

  getFramework() {
    return this.http.get(this.configSvc.apiUrl + "standard/IsFramework");
  }

  getACET() {
    return this.http.get(this.configSvc.apiUrl + "standard/IsACET");
  }

  setACETSelected(acet: boolean) {
    this.acetSelected = acet;
    this.buildTree(this.getMagic());
  }

  setFrameworkSelected(framework: boolean) {
    this.frameworkSelected = framework;
    this.buildTree(this.getMagic());
  }

  /**
   * Routes to the path configured for the specified pageClass.
   * @param value 
   */
  navDirect(pageClass: string) {
    const targetPage = this.pages.find(p => p.pageClass === pageClass);

    // if they clicked on a 'phase', nudge them to the first page in that phase
    if (!targetPage.path) {
      this.navNext(pageClass);
      return;
    }

    this.setNoCurrentPage(this.dataSource.data);
    const currentNode = this.findInTree(this.dataSource.data, targetPage.pageClass);
    if (!!currentNode) {
      currentNode.isCurrent = true;
    }

    const targetPath = targetPage.path.replace('{:id}', this.assessSvc.id().toString());
    this.router.navigate([targetPath]);
  }

  /**
   *
   * @param cur
   */
  navBack(cur: string) {
    // find current page
    const currentPageIndex = this.pages.findIndex(p => p.pageClass === cur);
    if (currentPageIndex < 0) {
      return;
    }

    if (currentPageIndex === 0) {
      // we are at the first page, nothing to do
      return;
    }

    let newPageIndex = currentPageIndex;
    let showPage = false;

    // skip over any entries without a path or that fail the 'showpage' condition
    do {
      newPageIndex--;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
    }
    while (!this.pages[newPageIndex].hasOwnProperty('path')
      || (newPageIndex >= 0 && !showPage));

    this.setNoCurrentPage(this.dataSource.data);
    const currentNode = this.findInTree(this.dataSource.data, this.pages[newPageIndex].pageClass);
    if (!!currentNode) {
      currentNode.isCurrent = true;
    }

    const newPath = this.pages[newPageIndex].path.replace('{:id}', this.assessSvc.id().toString());
    this.router.navigate([newPath]);
  }

  /**
   *
   * @param cur
   */
  navNext(cur: string) {
    // find current page
    const currentPageIndex = this.pages.findIndex(p => p.pageClass === cur);

    if (currentPageIndex < 0) {
      return;
    }

    if (currentPageIndex === this.pages.length - 1) {
      // we are at the last page, nothing to do
      return;
    }

    let newPageIndex = currentPageIndex;
    let showPage = false;

    // skip over any entries without a path or that fail the 'showpage' condition
    do {
      newPageIndex++;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
    }
    while (!this.pages[newPageIndex].hasOwnProperty('path')
      || (newPageIndex < this.pages.length && !showPage));

    this.setNoCurrentPage(this.dataSource.data);
    const currentNode = this.findInTree(this.dataSource.data, this.pages[newPageIndex].pageClass);
    if (!!currentNode) {
      currentNode.isCurrent = true;
    }

    const newPath = this.pages[newPageIndex].path.replace('{:id}', this.assessSvc.id().toString());
    this.router.navigate([newPath]);
  }

  /**
   * If there is no condition, show.  Otherwise evaluate the condition.
   * @param condition
   */
  shouldIShow(condition: any): boolean {
    if (condition === undefined || condition === null) {
      return true;
    }

    if (condition === '!ACET') {
      return !this.acetSelected;
    }

    if (condition === 'ACET') {
      return this.acetSelected;
    }

    if (condition === 'FRAMEWORK') {
      return this.frameworkSelected;
    }

    if (condition === 'USE-STANDARD') {
      return !!this.assessSvc.assessment && this.assessSvc.assessment.UseStandard;
    }

    if (condition === 'USE-MATURITY-MODEL') {
      return !!this.assessSvc.assessment && this.assessSvc.assessment.UseMaturity;
    }

    if (condition === 'SHOW-SAL') {
      return ((!!this.assessSvc.assessment && this.assessSvc.assessment.UseStandard)
        || (!!this.assessSvc.assessment && this.assessSvc.assessment.UseDiagram));
    }

    if (condition === 'USE-DIAGRAM') {
      return !!this.assessSvc.assessment && this.assessSvc.assessment.UseDiagram;
    }

    if (condition === 'ANALYTICS-IS-UP') {
      return this.analyticsIsUp;
    }

    if (condition === 'FALSE') {
      return false;
    }

    return true;
  }

  /**
   * Recurses the tree to find the specified value.
   * @param tree
   * @param value
   */
  // findNodeByClassName(tree: NavTreeNode[], className: string): NavTreeNode {
  //   for (let index = 0; index < tree.length; index++) {
  //     const t = tree[index];

  //     if (t.value === className) {
  //       return t;
  //     }

  //     if (this.findNodeByClassName(t.children, className)) {
  //       return t;
  //     }
  //   }
  //   return null;
  // }

  /**
   * The master list of all pages.  Question categories are not listed here,
   * but are dynamically set elsewhere.
   * 
   * It is used to build the tree of NavTreeNode instances that feeds the side nav.
   * 
   * Note that the pages collection is not nested.  This makes BACKing and NEXTing easier.
   */
  pages = [
    // Prepare
    { displayText: 'Prepare', pageClass: 'phase-prepare', level: 0 },

    { displayText: 'Assessment Configuration', pageClass: 'info1', level: 1, path: 'assessment/{:id}/prepare/info1' },
    { displayText: 'Assessment Information', pageClass: 'info2', level: 1, path: 'assessment/{:id}/prepare/info2' },

    { displayText: 'Maturity Model Selection', pageClass: 'model-select', level: 1, path: 'assessment/{:id}/prepare/model-select', condition: 'USE-MATURITY-MODEL' },
    { displayText: 'CMMC Target Level Selection', pageClass: 'cmmc-levels', level: 1, path: 'assessment/{:id}/prepare/cmmc-levels', condition: 'USE-MATURITY-MODEL' },
    { displayText: 'ACET Required Documents', pageClass: 'required', level: 1, path: 'assessment/{:id}/prepare/required', condition: 'ACET' },
    { displayText: 'ACET IRP', pageClass: 'irp', level: 1, path: 'assessment/{:id}/prepare/irp', condition: 'ACET' },
    { displayText: 'ACET IRP Summary', pageClass: 'irp-summary', level: 1, path: 'assessment/{:id}/prepare/irp-summary', condition: 'ACET' },

    { displayText: 'Security Assurance Level (SAL)', pageClass: 'sal', level: 1, path: 'assessment/{:id}/prepare/sal', condition: 'SHOW-SAL' },

    { displayText: 'Cybsersecurity Standards Selection', pageClass: 'standards', level: 1, path: 'assessment/{:id}/prepare/standards', condition: 'USE-STANDARD' },
    { displayText: 'Standard Specific Screen(s)', level: 1, condition: 'FALSE' },

    //  Diagram
    { displayText: 'Network Diagram', pageClass: 'diagram', level: 1, path: 'assessment/{:id}/prepare/diagram/info', condition: 'USE-DIAGRAM' },

    { displayText: 'Framework', pageClass: 'framework', level: 1, path: 'assessment/{:id}/prepare/framework', condition: 'FRAMEWORK' },


    // Questions/Requirements/Statements
    { displayText: 'Assessment', pageClass: 'phase-assessment', level: 0 },
    { displayText: 'Questions', pageClass: 'questions', level: 1, path: 'assessment/{:id}/questions' },


    { displayText: 'Results', pageClass: 'phase-results', level: 0 },

    // Results - Standards
    { displayText: 'Analysis Dashboard', pageClass: 'dashboard', level: 1, path: 'assessment/{:id}/results/dashboard' },


    { displayText: 'Control Priorities', pageClass: 'ranked-questions', level: 1, path: 'assessment/{:id}/results/ranked-questions' },
    { displayText: 'Standards Summary', pageClass: 'standards-summary', level: 1, path: 'assessment/{:id}/results/standards-summary' },
    { displayText: 'Ranked Categories', pageClass: 'standards-ranked', level: 1, path: 'assessment/{:id}/results/standards-ranked' },
    { displayText: 'Results By Category', pageClass: 'standards-results', level: 1, path: 'assessment/{:id}/results/standards-results' },

    // Results - Components
    { displayText: 'Components Summary', pageClass: 'components-summary', level: 1, path: 'assessment/{:id}/results/components-summary' },
    { displayText: 'Ranked Components By Category', pageClass: 'components-ranked', level: 1, path: 'assessment/{:id}/results/components-ranked' },
    { displayText: 'Component Results By Category', pageClass: 'components-results', level: 1, path: 'assessment/{:id}/results/components-results' },
    { displayText: 'Components By Component Type', pageClass: 'components-types', level: 1, path: 'assessment/{:id}/results/components-types' },
    { displayText: 'Network Warnings', pageClass: 'components-warnings', level: 1, path: 'assessment/{:id}/results/components-warnings' },

    // ACET results pages
    { displayText: 'ACET Maturity Results', pageClass: 'maturity', level: 1, path: 'assessment/{:id}/results/maturity', condition: 'ACET' },
    { displayText: 'ACET Admin Results', pageClass: 'admin', level: 1, path: 'assessment/{:id}/results/admin', condition: 'ACET' },
    { displayText: 'ACET Dashboard', pageClass: 'acetDashboard', level: 1, path: 'assessment/{:id}/results/acetDashboard', condition: 'ACET' },

    { displayText: 'Executive Summary, Overview & Comments', pageClass: 'overview', level: 1, path: 'assessment/{:id}/results/overview' },
    { displayText: 'Reports', pageClass: 'reports', level: 1, path: 'assessment/{:id}/results/reports' },
    { displayText: 'Feedback', pageClass: 'feedback', level: 1, path: 'assessment/{:id}/results/feedback' },
    { displayText: 'Share Assessment With DHS', pageClass: 'analytics', level: 1, path: 'assessment/{:id}/results/analytics', condition: 'ANALYTICS-IS-UP' }

  ];
}
