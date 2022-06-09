

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
import { MaturityService } from './maturity.service';
import { CisService } from './cis.service';



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

  pages = [];
  currentPage = '';

  cisSubnodes = null;

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
    private maturitySvc: MaturityService,
    private cisSvc: CisService,
    private configSvc: ConfigService
  ) {

    this.setWorkflow('BASE');

    if (this.configSvc.installationMode === 'RRA') {
      this.setWorkflow('RRA');
    }

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

    // get and store the CIS subnode list from the API.
    this.cisSvc.cisSubnodeList$.subscribe(l => {
      this.cisSubnodes = l;
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
   * @param code
   */
  setWorkflow(code: string) {
    switch (code) {
      case "TSA":
        this.pages = this.workflowTSA;
        return;
      case "BASE":
        this.pages = this.workflowBase;
        return;
      case "ACET":
        // someday maybe create an ACET-specific workflow
        this.pages = this.workflowBase;
        return;
      case "RRA":
        this.pages = this.workflowRRA;
        break;
    }
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
      this.insertCisNodes();

      if (localStorage.getItem('tree')) {
        let tree: any = this.parseTocData(JSON.parse(localStorage.getItem('tree')));
        this.dataSource.data = <NavTreeNode[]>tree;
      } else {
        this.dataSource.data = this.buildTocData();
      }
      this.treeControl.dataNodes = this.dataSource.data;
      localStorage.setItem('tree', JSON.stringify(this.dataSource.data));
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
      const alias = this.assessSvc.assessment?.maturityModel?.questionsAlias;
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

  setACETSelected(acet: boolean) {
    this.acetSelected = acet;
    localStorage.removeItem('tree');
    this.buildTree(this.getMagic());
  }

  setFrameworkSelected(framework: boolean) {
    this.frameworkSelected = framework;
    localStorage.removeItem('tree');
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

      if (targetPage == null) {
        console.error('Cannot find ' + navTarget + ' in navigation tree');
        return;
      }

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

    // skip over any entries without a path or have children or that fail the 'showpage' condition
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

    // look for maturity model
    if (typeof (condition) === 'string') {
      if (condition.startsWith('MATURITY-')) {
        let targetModel = condition.substring(9);

        return !!this.assessSvc.assessment
        && this.assessSvc.assessment?.useMaturity
        && this.assessSvc.usesMaturityModel(targetModel);
      }
    }

    if (condition === 'ANALYTICS-IS-UP') {
      return this.analyticsIsUp;
    }

    return true;
  }

  /**
   * Determines if the specified page is the last visible page in the nav flow.
   * Used to hide the "Next" button.
   * @returns
   */
  isLastVisiblePage(pageId: string): boolean {
    const currentPageIndex = this.pages.findIndex(p => p.pageId === pageId);

    let idx = currentPageIndex;
    let showPage = false;

    do {
      idx++;

      if (idx >= this.pages.length) {
        // we passed the end of the page list without hitting another visible page
        return true;
      }

      showPage = this.shouldIShow(this.pages[idx].condition);
    }
    while (!this.pages[idx].hasOwnProperty('path')
      || (idx < this.pages.length && !showPage));

    if (idx < this.pages.length) {
      // there is a visible page after the target page
      return false;
    }

    return false;
  }

  /**
   * Dynamically adds the subnodes to the pages array.
   */
  insertCisNodes() {
    if (!this.pages || !this.cisSubnodes || this.cisSubnodes.length === 0) {
      return;
    }

    // if the CIS nodes are already in the array, nothing to do
    if (this.pages.findIndex(x => x.pageId == this.cisSubnodes[0].pageId) >= 0) {
      return;
    }

    let cisTopIndex = this.pages.findIndex(g => g.pageId == 'maturity-questions-nested');
    if (cisTopIndex > 0) {
      this.pages.splice(cisTopIndex + 1, 0, ...this.cisSubnodes);
    }
  }


  /**
   * The master list of all pages.  Question categories are not listed here,
   * but are dynamically set elsewhere.
   *
   * It is used to build the tree of NavTreeNode instances that feeds the side nav.
   *
   * Note that the pages collection is not nested.  This makes BACKing and NEXTing easier.
   */
  workflowBase = [
    // Prepare
    { displayText: 'Prepare', pageId: 'phase-prepare', level: 0 },

    { displayText: 'Assessment Configuration', pageId: 'info1', level: 1, path: 'assessment/{:id}/prepare/info1' },
    { displayText: 'Assessment Information', pageId: 'info2', level: 1, path: 'assessment/{:id}/prepare/info2' },

    {
      displayText: 'Cybersecurity Assessment Modules',
      pageId: 'model-select', level: 1,
      path: 'assessment/{:id}/prepare/model-select',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && !this.assessSvc.assessment.isAcetOnly
      }
    },

    {
      displayText: 'CMMC Tutorial',
      pageId: 'tutorial-cmmc', level: 1,
      path: 'assessment/{:id}/prepare/tutorial-cmmc',
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'CMMC Tutorial',
      pageId: 'tutorial-cmmc2', level: 1,
      path: 'assessment/{:id}/prepare/tutorial-cmmc2',
      condition: 'MATURITY-CMMC2'
    },
    {
      displayText: 'EDM Tutorial',
      pageId: 'tutorial-edm', level: 1,
      path: 'assessment/{:id}/prepare/tutorial-edm',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'CRR Tutorial',
      pageId: 'tutorial-crr', level: 1,
      path: 'assessment/{:id}/prepare/tutorial-crr',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Ransomware Readiness Tutorial',
      pageId: 'tutorial-rra', level: 1,
      path: 'assessment/{:id}/prepare/tutorial-rra',
      condition: 'MATURITY-RRA'
    },
    {
      displayText: 'Cyber Infrastructure Survey Tutorial',
      pageId: 'tutorial-cis', level: 1,
      path: 'assessment/{:id}/prepare/tutorial-cis',
      condition: 'MATURITY-CIS'
    },
    {
      displayText: 'CIS Configuration',
      pageId: 'config-cis', level: 1,
      path: 'assessment/{:id}/prepare/config-cis',
      condition: 'MATURITY-CIS'
    },
    {
      displayText: 'Critical Service Information',
      pageId: 'csi', level: 1,
      path: 'assessment/{:id}/prepare/csi',
      condition: 'MATURITY-CIS'
    },

    {
      displayText: 'CMMC Target Level Selection', pageId: 'cmmc-levels', level: 1,
      path: 'assessment/{:id}/prepare/cmmc-levels',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && (this.assessSvc.usesMaturityModel('CMMC') || this.assessSvc.usesMaturityModel('CMMC2'));
      }
    },



    {
      displayText: 'Security Assurance Level (SAL)',
      pageId: 'sal', level: 1,
      path: 'assessment/{:id}/prepare/sal',
      condition: () => {
        return ((!!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard)
          || (!!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram));
      }
    },

    {
      displayText: 'Cybersecurity Standards Selection',
      pageId: 'standards', level: 1,
      path: 'assessment/{:id}/prepare/standards',
      condition: () => { return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard }
    },

    {
      displayText: 'Cybersecurity Framework',
      pageId: 'framework', level: 1,
      path: 'assessment/{:id}/prepare/framework',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useStandard
          && this.assessSvc.usesStandard('NCSF_V1');
      }
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
      condition: 'MATURITY-ACET'
    },
    {
      displayText: 'Inherent Risk Profile Summary', pageId: 'irp-summary', level: 1,
      path: 'assessment/{:id}/prepare/irp-summary',
      condition: 'MATURITY-ACET'
    },

    //  Diagram
    {
      displayText: 'Network Diagram',
      pageId: 'diagram', level: 1,
      path: 'assessment/{:id}/prepare/diagram/info',
      condition: () => { return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram }
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
      comment: 'This screen displays if no features are selected',
      displayText: 'Assessment Questions',
      pageId: 'placeholder-questions',
      path: 'assessment/{:id}/placeholder-questions',
      level: 1,
      condition: () => {
        return !(this.assessSvc.assessment?.useMaturity
          || this.assessSvc.assessment?.useDiagram
          || this.assessSvc.assessment?.useStandard
          || this.assessSvc.assessment?.useCyote);
      }
    },

    {
      displayText: 'Maturity Questions',
      pageId: 'maturity-questions',
      path: 'assessment/{:id}/maturity-questions',
      level: 1,
      condition: () => {
        return this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('*')
          && !this.assessSvc.usesMaturityModel('CIS')
          && !(this.configSvc.installationMode === 'ACET'
            && this.assessSvc.usesMaturityModel('ACET'));
      }
    },

    {
      displayText: 'Statements',
      pageId: 'maturity-questions-acet',
      path: 'assessment/{:id}/maturity-questions-acet',
      level: 1,
      condition: () => {
        return this.assessSvc.assessment?.useMaturity
          && (this.configSvc.installationMode === 'ACET'
            && this.assessSvc.usesMaturityModel('ACET'));
      }
    },

    {
      displayText: 'CIS Questions',
      pageId: 'maturity-questions-nested',
      level: 1,
      condition: 'MATURITY-CIS'
    },

    // CIS nodes are inserted here

    {
      displayText: 'Standard Questions',
      pageId: 'questions',
      path: 'assessment/{:id}/questions',
      level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },

    {
      displayText: 'Diagram Component Questions',
      pageId: 'diagram-questions',
      path: 'assessment/{:id}/diagram-questions',
      level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },

    {
      displayText: 'CyOTE',
      pageId: 'cyote-questions',
      level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useCyote;
      }
    },
    {
      displayText: 'Collect Anomalies',
      pageId: 'cyote-collect',
      level: 2,
      path: 'assessment/{:id}/cyote-collect',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useCyote;
      }
    },
    {
      displayText: 'Categorization',
      pageId: 'cyote-categorize',
      level: 2,
      path: 'assessment/{:id}/cyote-categorize' ,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useCyote;
      }
    },
    {
      displayText: 'Deep Dive',
      pageId: 'cyote-deepdive',
      level: 2,
      path: 'assessment/{:id}/cyote-deepdive',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useCyote;
      }
    },
    {
      displayText: 'Recommendation',
      pageId: 'cyote-recommendation',
      level: 2,
      path: 'assessment/{:id}/cyote-recommendation',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useCyote;
      }
    },


    { displayText: 'Results', pageId: 'phase-results', level: 0 },

    {
      displayText: 'Analysis Dashboard', pageId: 'dashboard', level: 1, path: 'assessment/{:id}/results/dashboard',
      condition: () => {
        return !!this.assessSvc.assessment
        && (this.assessSvc.assessment?.useStandard || this.assessSvc.assessment?.useDiagram);
      }
    },

    // Results - CMMC
    {
      displayText: 'CMMC Results', pageId: 'cmmc-results-node', level: 1,
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'Target and Achieved Levels', pageId: 'cmmc-level-results', level: 2, path: 'assessment/{:id}/results/cmmc-level-results',
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'Level Drill Down', pageId: 'cmmc-level-drilldown', level: 2, path: 'assessment/{:id}/results/cmmc-level-drilldown',
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'Compliance Score', pageId: 'cmmc-compliance', level: 2, path: 'assessment/{:id}/results/cmmc-compliance',
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'Detailed Gaps List', pageId: 'cmmc-gaps', level: 2, path: 'assessment/{:id}/results/cmmc-gaps',
      condition: 'MATURITY-CMMC'
    },

    // Results - CMMC2
    {
      displayText: 'CMMC 2.0 Results', pageId: 'cmmc2-results-node', level: 1,
      condition: 'MATURITY-CMMC2'
    },

    {
      displayText: 'Performance by Level', pageId: 'cmmc2-level-results', level: 2, path: 'assessment/{:id}/results/cmmc2-level-results',
      condition: 'MATURITY-CMMC2'
    },
    {
      displayText: 'Performance by Domain', pageId: 'cmmc2-domain-results', level: 2, path: 'assessment/{:id}/results/cmmc2-domain-results',
      condition: 'MATURITY-CMMC2'
    },
    {
      displayText: 'SPRS Score', pageId: 'sprs-score', level: 2, path: 'assessment/{:id}/results/sprs-score',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('CMMC2')
          && this.assessSvc.assessment.maturityModel.maturityTargetLevel > 1
      }
    },

    //Results - EDM
    {
      displayText: 'EDM Results', pageId: 'edm-results-node', level: 1,
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Summary Results', pageId: 'summary-results', level: 2, path: 'assessment/{:id}/results/summary-results',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Relationship Formation', pageId: 'relationship-formation', level: 2, path: 'assessment/{:id}/results/relationship-formation',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Relationship Management and Governance', pageId: 'relationship-management', level: 2, path: 'assessment/{:id}/results/relationship-management',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Service Protection and Sustainment', pageId: 'service-protection', level: 2, path: 'assessment/{:id}/results/service-protection',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Maturity Indicator Levels', pageId: 'maturity-indicator-levels', level: 2, path: 'assessment/{:id}/results/maturity-indicator-levels',
      condition: 'MATURITY-EDM'
    },

    // Results - CRR
    {
      displayText: 'CRR Results', pageId: 'crr-results-node', level: 1,
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Summary Results', pageId: 'crr-summary-results', level: 2, path: 'assessment/{:id}/results/crr-summary-results',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Asset Management', pageId: 'crr-domain-am', level: 2, path: 'assessment/{:id}/results/crr-domain-am',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Controls Management', pageId: 'crr-domain-cm', level: 2, path: 'assessment/{:id}/results/crr-domain-cm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Configuration and Change Management', pageId: 'crr-domain-ccm', level: 2, path: 'assessment/{:id}/results/crr-domain-ccm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Vulnerability Management', pageId: 'crr-domain-vm', level: 2, path: 'assessment/{:id}/results/crr-domain-vm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Incident Management', pageId: 'crr-domain-im', level: 2, path: 'assessment/{:id}/results/crr-domain-im',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Service Continuity Management', pageId: 'crr-domain-scm', level: 2, path: 'assessment/{:id}/results/crr-domain-scm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Risk Management', pageId: 'crr-domain-rm', level: 2, path: 'assessment/{:id}/results/crr-domain-rm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'External Dependencies Management', pageId: 'crr-domain-edm', level: 2, path: 'assessment/{:id}/results/crr-domain-edm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Training and Awareness', pageId: 'crr-domain-ta', level: 2, path: 'assessment/{:id}/results/crr-domain-ta',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Situational Awareness', pageId: 'crr-domain-sa', level: 2, path: 'assessment/{:id}/results/crr-domain-sa',
      condition: 'MATURITY-CRR'
    },



    // Results - RRA
    {
      displayText: 'RRA Results', pageId: 'rra-results-node', level: 1,
      condition: 'MATURITY-RRA'
    },
    {
      displayText: 'Goal Performance', pageId: 'rra-gaps', level: 2, path: 'assessment/{:id}/results/rra-gaps',
      condition: 'MATURITY-RRA'
    },
    {
      displayText: 'Assessment Tiers', pageId: 'rra-level-results', level: 2, path: 'assessment/{:id}/results/rra-level-results',
      condition: 'MATURITY-RRA'
    },
    {
      displayText: 'Performance Summary', pageId: 'rra-summary-all', level: 2, path: 'assessment/{:id}/results/rra-summary-all',
      condition: 'MATURITY-RRA'
    },



    // Results - Standards
    {
      displayText: 'Standards Results', pageId: 'standards-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },



    {
      displayText: 'Control Priorities', pageId: 'ranked-questions', level: 2, path: 'assessment/{:id}/results/ranked-questions',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Standards Summary', pageId: 'standards-summary', level: 2, path: 'assessment/{:id}/results/standards-summary',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Ranked Categories', pageId: 'standards-ranked', level: 2, path: 'assessment/{:id}/results/standards-ranked',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Results By Category', pageId: 'standards-results', level: 2, path: 'assessment/{:id}/results/standards-results',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },

    // Results - Components
    {
      displayText: 'Components Results', pageId: 'components-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Components Summary', pageId: 'components-summary', level: 2, path: 'assessment/{:id}/results/components-summary',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Ranked Components By Category', pageId: 'components-ranked', level: 2, path: 'assessment/{:id}/results/components-ranked',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Component Results By Category', pageId: 'components-results', level: 2, path: 'assessment/{:id}/results/components-results',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Answers By Component Type', pageId: 'components-types', level: 2, path: 'assessment/{:id}/results/components-types',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Network Warnings', pageId: 'components-warnings', level: 2, path: 'assessment/{:id}/results/components-warnings',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },

    // ACET results pages
    {
      displayText: 'ACET Results', pageId: 'acet-results-node', level: 1,
      condition: 'MATURITY-ACET'
    },
    {
      displayText: 'ACET Maturity Results', pageId: 'acet-maturity', level: 2, path: 'assessment/{:id}/results/acet-maturity',
      condition: 'MATURITY-ACET'
    },
    {
      displayText: 'ACET Dashboard', pageId: 'acet-dashboard', level: 2, path: 'assessment/{:id}/results/acet-dashboard',
      condition: 'MATURITY-ACET'
    },


    // CyOTE results pages
    {
      displayText: 'CyOTE Results', pageId: 'cyote-results', level: 1, path: 'assessment/{:id}/results/cyote-results',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useCyote;
      }
    },

    // CIS results pages
    {
      displayText: 'CIS Results', pageId: 'cis-results-node', level: 1,
      condition: 'MATURITY-CIS'
    },
    {
      displayText: 'CIS Section Scoring', pageId: 'section-scoring', level: 2, path: 'assessment/{:id}/results/section-scoring',
      condition: 'MATURITY-CIS'
    },
    {
      displayText: 'CIS Ranked Deficiency', pageId: 'ranked-deficiency', level: 2, path: 'assessment/{:id}/results/ranked-deficiency',
      condition: 'MATURITY-CIS'
    },
   


    {
      displayText: 'High-Level Assessment Description, Executive Summary & Comments', pageId: 'overview', level: 1, path: 'assessment/{:id}/results/overview',
      condition: () => {
        return this.showExecSummaryPage();
      }
    },
    { displayText: 'Reports', pageId: 'reports', level: 1, path: 'assessment/{:id}/results/reports' },
    {
      displayText: 'Feedback', pageId: 'feedback', level: 1, path: 'assessment/{:id}/results/feedback',
      condition: () => {
        return this.configSvc.installationMode !== 'ACET';
      }
    },
    {
      displayText: 'Share Assessment With CISA', pageId: 'analytics', level: 1, path: 'assessment/{:id}/results/analytics',
      condition: () => {
        return false;
        return this.analyticsIsUp && this.configSvc.installationMode !== 'ACET';
      }
    }

  ];


  // --------
  // TSA Workflow
  // --------
  workflowTSA = [
    // Prepare
    { displayText: 'Prepare', pageId: 'phase-prepare', level: 0 },

    { displayText: 'Assessment Configuration', pageId: 'info-tsa', level: 1, path: 'assessment/{:id}/prepare/info-tsa' },
    { displayText: 'Assessment Information', pageId: 'info2-tsa', level: 1, path: 'assessment/{:id}/prepare/info2-tsa' },

    // Questions/Requirements/Statements
    { displayText: 'Assessment', pageId: 'phase-assessment', level: 0 },

    {
      displayText: 'Maturity Questions',
      pageId: 'maturity-questions',
      path: 'assessment/{:id}/maturity-questions',
      level: 1,
      condition: () => {
        return this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('*')
          && !(this.configSvc.installationMode === 'ACET'
            && this.assessSvc.usesMaturityModel('TSA'));
      }
    },
    {
      displayText: 'Standard Questions',
      pageId: 'questions',
      path: 'assessment/{:id}/questions',
      level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },


    // Results
    { displayText: 'Results', pageId: 'phase-results', level: 0 },
    {
      displayText: 'Standards Results', pageId: 'standards-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Analysis Dashboard', pageId: 'dashboard', level: 2, path: 'assessment/{:id}/results/dashboard',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },

    {
      displayText: 'Control Priorities', pageId: 'ranked-questions', level: 2, path: 'assessment/{:id}/results/ranked-questions',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Standards Summary', pageId: 'standards-summary', level: 2, path: 'assessment/{:id}/results/standards-summary',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Ranked Categories', pageId: 'standards-ranked', level: 2, path: 'assessment/{:id}/results/standards-ranked',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Results By Category', pageId: 'standards-results', level: 2, path: 'assessment/{:id}/results/standards-results',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },

    // Results - Components
    {
      displayText: 'Components Results', pageId: 'components-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Components Summary', pageId: 'components-summary', level: 2, path: 'assessment/{:id}/results/components-summary',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Ranked Components By Category', pageId: 'components-ranked', level: 2, path: 'assessment/{:id}/results/components-ranked',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Component Results By Category', pageId: 'components-results', level: 2, path: 'assessment/{:id}/results/components-results',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Answers By Component Type', pageId: 'components-types', level: 2, path: 'assessment/{:id}/results/components-types',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Network Warnings', pageId: 'components-warnings', level: 2, path: 'assessment/{:id}/results/components-warnings',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },

    // Reports
    {
      displayText: 'High-Level Assessment Description, Executive Summary & Comments', pageId: 'overview', level: 1, path: 'assessment/{:id}/results/overview',
      condition: () => {
        return this.showExecSummaryPage();
      }
    },
    { displayText: 'Reports', pageId: 'reports', level: 1, path: 'assessment/{:id}/results/reports' },
    { displayText: 'Assessment Complete', pageId: 'tsa-assessment-complete', level: 1, path: 'assessment/{:id}/results/tsa-assessment-complete' }
  ];


  // --------
  // RRA Workflow
  // --------
  workflowRRA = [
    // Prepare phase
    { displayText: 'Prepare', pageId: 'phase-prepare', level: 0 },

    { displayText: 'Assessment Configuration', pageId: 'info1', level: 1, path: 'assessment/{:id}/prepare/info1' },
    { displayText: 'Assessment Information', pageId: 'info2', level: 1, path: 'assessment/{:id}/prepare/info2' },
    {
      displayText: 'Ransomware Readiness Tutorial',
      pageId: 'tutorial-rra',
      path: 'assessment/{:id}/prepare/tutorial-rra',
      level: 1
    },


    // Questions phase
    { displayText: 'Assessment', pageId: 'phase-assessment', level: 0 },

    {
      displayText: 'Maturity Questions',
      pageId: 'maturity-questions',
      path: 'assessment/{:id}/maturity-questions',
      level: 1
    },



    // Results phase
    { displayText: 'Results', pageId: 'phase-results', level: 0 },
    // Results - RRA
    {
      displayText: 'RRA Results', pageId: 'rra-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('RRA')
      }
    },
    {
      displayText: 'Goal Performance', pageId: 'rra-gaps', level: 2, path: 'assessment/{:id}/results/rra-gaps',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('RRA')
      }
    },
    {
      displayText: 'Assessment Tiers', pageId: 'rra-level-results', level: 2, path: 'assessment/{:id}/results/rra-level-results',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('RRA')
      }
    },
    {
      displayText: 'Performance Summary', pageId: 'rra-summary-all', level: 2, path: 'assessment/{:id}/results/rra-summary-all',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('RRA')
      }
    },



    // Reports
    { displayText: 'Reports', pageId: 'reports', level: 1, path: 'assessment/{:id}/results/reports' },

  ];


  /**
   *
   */
  showExecSummaryPage() {
    let assessment = this.assessSvc.assessment;
    return assessment?.useDiagram || assessment?.useStandard;
  }
}
