////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { AssessmentService } from './assessment.service';
import { NestedTreeControl } from "@angular/cdk/tree";
import { EventEmitter, Injectable, Output, Directive } from "@angular/core";
import { MatTreeNestedDataSource } from "@angular/material/tree";
import { of as observableOf, BehaviorSubject } from "rxjs";
import { ConfigService } from './config.service';
import { HttpClient } from '@angular/common/http';
import { AnalyticsService } from './analytics.service';
import { QuestionsService } from './questions.service';



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
  index?: number;
}

/**
 * A service that provides intelligent NEXT and BACK routing.
 * Some pages are hidden, and this service knows what to do.
 * 
 * It also renders the structure for the side nav / table of contents / TOC.
 */
@Directive()
@Injectable({
  providedIn: 'root'
})
export class NavigationService {

  private magic: string;

  @Output()
  navItemSelected = new EventEmitter<any>();

  @Output()
  scrollToQuestion = new EventEmitter<string>();

  dataSource: MatTreeNestedDataSource<NavTreeNode> = new MatTreeNestedDataSource<NavTreeNode>();
  dataChange: BehaviorSubject<NavTreeNode[]> = new BehaviorSubject<NavTreeNode[]>([]);
  treeControl: NestedTreeControl<NavTreeNode>;
  isNavLoading = false;

  currentPage = '';

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
    private questionsSvc: QuestionsService,
    private configSvc: ConfigService
  ) {

    // set up the mat tree control and its data source
    this.treeControl = new NestedTreeControl<NavTreeNode>(this.getChildren);
    this.dataSource = new MatTreeNestedDataSource<NavTreeNode>();
    this.dataChange.subscribe(data => {
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
   * Generates a random 'magic number'.
   */
  getMagic() {
    this.magic = (Math.random() * 1e5).toFixed(0);
    return this.magic;
  }

  /**
   * 
   * @param magic 
   */
  clearTree(magic: string) {
    if (this.magic === magic) {
      this.isNavLoading = true;
      this.dataSource.data = null;
      this.treeControl.dataNodes = this.dataSource.data;
    }
  }

  /**
   * 
   * @param magic 
   */
  buildTree(magic: string) {
    if (this.magic === magic) {
      if (sessionStorage.getItem('tree')) {
        let tree: any = this.parseTocData(JSON.parse(sessionStorage.getItem('tree')));
        this.dataSource.data = <NavTreeNode[]>tree;
      } else {
        this.dataSource.data = this.buildTocData();
      }
      this.treeControl.dataNodes = this.dataSource.data;
      sessionStorage.setItem('tree', JSON.stringify(this.dataSource.data));
      this.setQuestionsTree();

      this.treeControl.expandAll();

      this.isNavLoading = false;
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
      this.dataSource = new MatTreeNestedDataSource<NavTreeNode>();
      this.dataSource.data = tree;
      this.treeControl.dataNodes = tree;

      this.treeControl.expandAll();

      this.isNavLoading = false;
    }
  }

  hasNestedChild(_: number, node: NavTreeNode) {
    return node.children.length > 0;
  }

  parseTocData(tree): NavTreeNode[] {
    let navTree: NavTreeNode[] = [];
    for (let i = 0; i < tree.length; i++) {
      let p = tree[i];

      const node: NavTreeNode = {
        label: p.label,
        value: p.value,
        isPhaseNode: p.isPhaseNode,
        children: p.children,
        expandable: p.expandable,
        visible: p.visible
      };
      navTree.push(node);
    }
    return navTree;
  }

  /**
   * Returns a list of tree node elements
   */
  buildTocData(): NavTreeNode[] {
    const toc: NavTreeNode[] = [];
    
    for (let i = 0; i < this.pages.length; i++) {
      let p = this.pages[i];
      let visible = this.shouldIShow(p.condition);

      const node: NavTreeNode = {
        label: p.displayText,
        value: p.pageId,
        isPhaseNode: false,
        children: [],
        expandable: true,
        visible: visible
      };

      // the node might need tweaking based on certain factors
      this.adjustNode(node);

      if (p.level === 0) {
        node.isPhaseNode = true;
      }

      if (this.currentPage === node.value) {
        node.isCurrent = true;
      }

      const parentPage = this.findParentPage(i);
      node.index = i;
      if (!!parentPage) {
        const parentNode = this.findInTree(toc, parentPage.pageId);
        if (!!parentNode) {
          parentNode.children.push(node);
        }
      } else {
        toc.push(node);
      }
    }

    return toc;
  }

  /**
   * Any runtime adjustments can be made here.
   */
  adjustNode(node: NavTreeNode) {
    if (node.value == 'maturity-questions') {
      const alias = this.assessSvc.assessment?.MaturityModel?.QuestionsAlias;
      if (!!alias) {
        node.label = alias;
      }
    }
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
  findInTree(tree: NavTreeNode[], className: string): NavTreeNode {
    let result = null;

    if (!!tree) {
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
    }

    return result;
  }

  /**
   * Sets all nodes in the tree to NOT be current
   */
  clearCurrentPage(tree: NavTreeNode[]) {
    this.currentPage = '';

    if (!tree) {
      return;
    }

    for (let i = 0; i < tree.length; i++) {
      let node = tree[i];
      node.isCurrent = false;

      if (node.children.length > 0) {
        this.clearCurrentPage(node.children);
      }
    }
  }

  /**
   * Clear any current page and mark the new one.
   */
  setCurrentPage(pageId: string) {
    this.clearCurrentPage(this.dataSource?.data);

    const currentNode = this.findInTree(this.dataSource.data, pageId);

    if (!!currentNode) {
      currentNode.isCurrent = true;
      this.currentPage = currentNode.value;
    }
  }

  /**
   * Replaces the children of the Questions node with
   * the values supplied.
   * There can be up to 3 sources for questions -- 
   *   - Maturity
   *   - Questions/Requirements
   *   - Diagram
   * 
   * This functionality has been put on hold.  It needs to be reevaluated
   * to see if it is useful to the user or is just clutter in the nav tree.
   * For now, there's no need to make API calls whose response will not be used.
   */
  setQuestionsTree() {
    const d = this.dataSource.data;
    this.dataSource.data = null;
    this.dataSource.data = d;
  }

  /**
   * 
   */
  getFramework() {
    return this.http.get(this.configSvc.apiUrl + "standard/IsFramework");
  }

  getACET() {
    return this.http.get(this.configSvc.apiUrl + "standard/IsACET");
  }

  setACETSelected(acet: boolean) {
    this.acetSelected = acet;
    sessionStorage.removeItem('tree');
    this.buildTree(this.getMagic());
  }

  setFrameworkSelected(framework: boolean) {
    this.frameworkSelected = framework;
    sessionStorage.removeItem('tree');
    this.buildTree(this.getMagic());
  }

  /**
   * Routes to the path configured for the specified pageId.
   * @param value 
   */
  navDirect(navTarget: any) {
    // if the target is a simple string, find it in the pages structure 
    // and navigate to its path
    if (typeof navTarget == 'string') {
      let targetPage = this.pages.find(p => p.pageId === navTarget);

      // if they clicked on a tab there won't be a path -- nudge them to the next page
      if (!targetPage.hasOwnProperty('path')) {
        this.navNext(navTarget);
        return;
      }

      this.setCurrentPage(targetPage.pageId);

      // determine the route path
      const targetPath = targetPage.path.replace('{:id}', this.assessSvc.id().toString());
      this.router.navigate([targetPath]);
      return;
    }


    // they clicked on a question category, send them to questions

    if (this.router.url.endsWith('/questions')) {
      // we are sitting on the questions screen, tell it to just scroll to the desired subcat
      this.scrollToQuestion.emit(this.questionsSvc.buildNavTargetID(navTarget));
    } else {
      // stash the desired question group and category ID
      this.questionsSvc.scrollToTarget = this.questionsSvc.buildNavTargetID(navTarget);

      // navigate to the questions screen
      let targetPage = this.pages.find(p => p.pageId === 'phase-assessment');
      this.setCurrentPage(targetPage.pageId);

      const targetPath = targetPage.path.replace('{:id}', this.assessSvc.id().toString());
      this.router.navigate([targetPath]);
    }
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

    // skip over any entries without a path or that fail the 'showpage' condition
    do {
      newPageIndex--;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
    }
    while (!this.pages[newPageIndex].hasOwnProperty('path')
      || (newPageIndex >= 0 && !showPage));


    this.setCurrentPage(this.pages[newPageIndex].pageId);

    const newPath = this.pages[newPageIndex].path.replace('{:id}', this.assessSvc.id().toString());
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

    // skip over any entries without a path or that fail the 'showpage' condition
    do {
      newPageIndex++;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
    }
    while (!this.pages[newPageIndex].hasOwnProperty('path')
      || (newPageIndex < this.pages.length && !showPage));


    this.setCurrentPage(this.pages[newPageIndex].pageId);

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

    if (typeof (condition) === 'function') {
      return condition();
    }

    if (condition === 'ANALYTICS-IS-UP') {
      return this.analyticsIsUp;
    }

    return true;
  }


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
    { displayText: 'Prepare', pageId: 'phase-prepare', level: 0 },

    { displayText: 'Assessment Configuration', pageId: 'info1', level: 1, path: 'assessment/{:id}/prepare/info1' },
    { displayText: 'Assessment Information', pageId: 'info2', level: 1, path: 'assessment/{:id}/prepare/info2' },

    {
      displayText: 'Maturity Models',
      pageId: 'model-select', level: 1,
      path: 'assessment/{:id}/prepare/model-select',
      condition: () => { 
        return !!this.assessSvc.assessment 
        && this.assessSvc.assessment?.UseMaturity 
        && !this.assessSvc.assessment.IsAcetOnly
      }
    },
    {
      displayText: 'CMMC Tutorial',
      pageId: 'tutorial-cmmc', level: 1,
      path: 'assessment/{:id}/prepare/tutorial-cmmc',
      condition: () => { 
        return !!this.assessSvc.assessment
        && this.assessSvc.assessment?.UseMaturity
        && this.assessSvc.usesMaturityModel('CMMC');
       }
    },
    {
      displayText: 'EDM Tutorial',
      pageId: 'tutorial-edm', level: 1,
      path: 'assessment/{:id}/prepare/tutorial-edm',
      condition: () => { 
        return !!this.assessSvc.assessment
        && this.assessSvc.assessment?.UseMaturity
        && this.assessSvc.usesMaturityModel('EDM');
       }
    },
    {
      displayText: 'CMMC Target Level Selection', pageId: 'cmmc-levels', level: 1,
      path: 'assessment/{:id}/prepare/cmmc-levels',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('CMMC');
      }
    },

    

    {
      displayText: 'Security Assurance Level (SAL)',
      pageId: 'sal', level: 1,
      path: 'assessment/{:id}/prepare/sal',
      condition: () => {
        return ((!!this.assessSvc.assessment && this.assessSvc.assessment?.UseStandard)
          || (!!this.assessSvc.assessment && this.assessSvc.assessment?.UseDiagram));
      }
    },

    {
      displayText: 'Cybersecurity Standards Selection',
      pageId: 'standards', level: 1,
      path: 'assessment/{:id}/prepare/standards',
      condition: () => { return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseStandard }
    },

    {
      displayText: 'Standards Specific Screen(s)', level: 1,
      condition: () => { return false; }
    },

    // ACET-specific screens
    {
      displayText: 'Document Request List', pageId: 'acet-drl', level: 1,
      path: 'assessment/{:id}/prepare/required',
      condition: () => { return false; }
    },
    {
      displayText: 'Inherent Risk Profiles', pageId: 'irp', level: 1,
      path: 'assessment/{:id}/prepare/irp',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('ACET');
      }
    },
    {
      displayText: 'Inherent Risk Profile Summary', pageId: 'irp-summary', level: 1,
      path: 'assessment/{:id}/prepare/irp-summary',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('ACET');
      }
    },

    //  Diagram
    {
      displayText: 'Network Diagram',
      pageId: 'diagram', level: 1,
      path: 'assessment/{:id}/prepare/diagram/info',
      condition: () => { return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseDiagram }
    },

    // Framework
    {
      displayText: 'Framework', pageId: 'framework', level: 1, path: 'assessment/{:id}/prepare/framework',
      condition: () => {
        return this.frameworkSelected;
      }
    },


    // Questions/Requirements/Statements
    { displayText: 'Assessment', pageId: 'phase-assessment', level: 0 },

    {
      displayText: 'Assessment Questions',
      pageId: 'placeholder-questions',
      path: 'assessment/{:id}/placeholder-questions',
      level: 1,
      condition: () => {
         return !(this.assessSvc.assessment?.UseMaturity
          || this.assessSvc.assessment?.UseDiagram
          || this.assessSvc.assessment?.UseStandard);
      }
    },

    {
      displayText: 'Maturity Questions',
      pageId: 'maturity-questions',
      path: 'assessment/{:id}/maturity-questions',
      level: 1,
      condition: () => {
        return this.assessSvc.assessment?.UseMaturity
        && this.assessSvc.usesMaturityModel('*')
        && !(this.configSvc.acetInstallation
          && this.assessSvc.usesMaturityModel('ACET'));
      }
    },

    {
      displayText: 'Statements',
      pageId: 'maturity-questions-acet',
      path: 'assessment/{:id}/maturity-questions-acet',
      level: 1,
      condition: () => {
        return this.assessSvc.assessment?.UseMaturity
        && (this.configSvc.acetInstallation
          && this.assessSvc.usesMaturityModel('ACET'));
      }
    },

    {
      displayText: 'Standard Questions',
      pageId: 'questions',
      path: 'assessment/{:id}/questions',
      level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseStandard;
      }
    },

    {
      displayText: 'Diagram Component Questions',
      pageId: 'diagram-questions',
      path: 'assessment/{:id}/diagram-questions',
      level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseDiagram;
      }
    },



    { displayText: 'Results', pageId: 'phase-results', level: 0 },

    // Results - CMMC
    {
      displayText: 'CMMC Results', pageId: 'cmmc-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('CMMC')
      }
    },

    {
      displayText: 'Target and Achieved Levels', pageId: 'cmmc-level-results', level: 2, path: 'assessment/{:id}/results/cmmc-level-results',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('CMMC')
      }
    },
    {
      displayText: 'Level Drill Down', pageId: 'cmmc-level-drilldown', level: 2, path: 'assessment/{:id}/results/cmmc-level-drilldown',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('CMMC')
      }
    },
    {
      displayText: 'Compliance Score', pageId: 'cmmc-compliance', level: 2, path: 'assessment/{:id}/results/cmmc-compliance',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('CMMC')
      }
    },
    {
      displayText: 'Detailed Gaps List', pageId: 'cmmc-gaps', level: 2, path: 'assessment/{:id}/results/cmmc-gaps',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('CMMC')
      }
    },
    //Results EDM
    {
      displayText: 'EDM Results', pageId: 'edm-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('edm')
      }
    },
    {
      displayText: 'Relationship Formation', pageId: 'relationship-formation', level: 2, path: 'assessment/{:id}/results/relationship-formation',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('EDM')
      }
    },
    {
      displayText: 'Relationship Management and Governance', pageId: 'relationship-management', level: 2, path: 'assessment/{:id}/results/relationship-management',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('EDM')
      }
    },
    {
      displayText: 'Service Protection and Sustainment', pageId: 'service-protection', level: 2, path: 'assessment/{:id}/results/service-protection',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('EDM')
      }
    },
    {
      displayText: 'Maturity Indicator', pageId: 'maturity-indicator-levels', level: 2, path: 'assessment/{:id}/results/maturity-indicator-levels',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('EDM')
      }
    },

    // Results - Standards
    {
      displayText: 'Analysis Dashboard', pageId: 'dashboard', level: 1, path: 'assessment/{:id}/results/dashboard',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseStandard;
      }
    },


    {
      displayText: 'Control Priorities', pageId: 'ranked-questions', level: 1, path: 'assessment/{:id}/results/ranked-questions',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseStandard;
      }
    },
    {
      displayText: 'Standards Summary', pageId: 'standards-summary', level: 1, path: 'assessment/{:id}/results/standards-summary',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseStandard;
      }
    },
    {
      displayText: 'Ranked Categories', pageId: 'standards-ranked', level: 1, path: 'assessment/{:id}/results/standards-ranked',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseStandard;
      }
    },
    {
      displayText: 'Results By Category', pageId: 'standards-results', level: 1, path: 'assessment/{:id}/results/standards-results',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseStandard;
      }
    },

    // Results - Components
    {
      displayText: 'Components Summary', pageId: 'components-summary', level: 1, path: 'assessment/{:id}/results/components-summary',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseDiagram;
      }
    },
    {
      displayText: 'Ranked Components By Category', pageId: 'components-ranked', level: 1, path: 'assessment/{:id}/results/components-ranked',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseDiagram;
      }
    },
    {
      displayText: 'Component Results By Category', pageId: 'components-results', level: 1, path: 'assessment/{:id}/results/components-results',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseDiagram;
      }
    },
    {
      displayText: 'Components By Component Type', pageId: 'components-types', level: 1, path: 'assessment/{:id}/results/components-types',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseDiagram;
      }
    },
    {
      displayText: 'Network Warnings', pageId: 'components-warnings', level: 1, path: 'assessment/{:id}/results/components-warnings',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.UseDiagram;
      }
    },

    // ACET results pages
    {
      displayText: 'ACET Maturity Results', pageId: 'acet-maturity', level: 1, path: 'assessment/{:id}/results/acet-maturity',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('ACET');
      }
    },
    {
      displayText: 'ACET Dashboard', pageId: 'acet-dashboard', level: 1, path: 'assessment/{:id}/results/acet-dashboard',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.UseMaturity
          && this.assessSvc.usesMaturityModel('ACET');
      }
    },


    { displayText: 'High-Level Assessment Description, Executive Summary & Comments', pageId: 'overview', level: 1, path: 'assessment/{:id}/results/overview',
      condition: () => {
        return !this.configSvc.acetInstallation;
      }
  },
    { displayText: 'Reports', pageId: 'reports', level: 1, path: 'assessment/{:id}/results/reports' },
    { displayText: 'Feedback', pageId: 'feedback', level: 1, path: 'assessment/{:id}/results/feedback',
      condition: () => {
        return !this.configSvc.acetInstallation;
      } 
    },
    { displayText: 'Share Assessment With DHS', pageId: 'analytics', level: 1, path: 'assessment/{:id}/results/analytics',
    condition: () => {
      return this.analyticsIsUp && !this.configSvc.acetInstallation;
      } 
     }

  ];
}
