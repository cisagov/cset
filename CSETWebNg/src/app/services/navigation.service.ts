import { NestedTreeControl } from '@angular/cdk/tree';
import { MatTreeNestedDataSource } from '@angular/material/tree';
import { Router } from '@angular/router';
import { AssessmentService } from './assessment.service';
import { EventEmitter, Injectable, Output, Directive } from "@angular/core";
import { of as observableOf, BehaviorSubject } from "rxjs";
import { ConfigService } from './config.service';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { AnalyticsService } from './analytics.service';
import { QuestionsService } from './questions.service';
import { MaturityService } from './maturity.service';
import { CisService } from './cis.service';
import { nodeName } from 'jquery';
import { NavBackNextComponent } from '../assessment/navigation/nav-back-next/nav-back-next.component';



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
}

@Injectable({
  providedIn: 'root'
})
export class NavigationService {

  /**
   * The workflow is stored in a DOM so that we can easily navigate around the tree
   */
  workflow: Document;

  currentPage = '';

  private magic: string;

  @Output()
  navItemSelected = new EventEmitter<any>();

  @Output()
  scrollToQuestion = new EventEmitter<string>();

  dataSource: MatTreeNestedDataSource<NavTreeNode> = new MatTreeNestedDataSource<NavTreeNode>();
  dataChange: BehaviorSubject<NavTreeNode[]> = new BehaviorSubject<NavTreeNode[]>([]);
  treeControl: NestedTreeControl<NavTreeNode>;
  isNavLoading = false;

  activeResultsView: string;

  frameworkSelected = false;
  acetSelected = false;
  diagramSelected = true;

  analyticsIsUp = false;
  cisSubnodes = null;



  /**
   *
   */
  constructor(
    private assessSvc: AssessmentService,
    private configSvc: ConfigService,
    private router: Router,
    private http: HttpClient,
    private analyticsSvc: AnalyticsService,
    private questionsSvc: QuestionsService,
    private maturitySvc: MaturityService,
    private cisSvc: CisService
  ) {
    this.setWorkflow('classic');

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
   * Called from the resource-library component.
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

  hasNestedChild(_: number, node: NavTreeNode) {
    return node.children?.length > 0;
  }

  parseTocData(tree): NavTreeNode[] {
    let navTree: NavTreeNode[] = [];
    for (let i = 0; i < tree.length; i++) {
      let p = tree[i];

      const node: NavTreeNode = {
        label: p.label,
        value: p.value,
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

    this.domToNav(this.workflow.documentElement.children, toc);

    return toc;
  }


  /**
   * Converts workflow DOM nodes to NavTreeNodes.
   * Calls itself recursively to populate children.
   */
  domToNav(domNodes: HTMLCollection, navNodes: NavTreeNode[]) {
    Array.from(domNodes).forEach((workflowNode: HTMLElement) => {

      // nodes without a 'displaytext' attribute are ignored
      if (!!workflowNode.attributes['displaytext']) {

        const navNode: NavTreeNode = {
          label: workflowNode.attributes['displaytext'].value,
          value: workflowNode.id ?? 0,
          children: [],
          expandable: true,
          visible: true
        };


        // TODO
        navNode.visible = this.showPage(workflowNode);



        // the node might need tweaking based on certain factors
        this.adjustNavNode(navNode);

        if (this.currentPage === navNode.value) {
          navNode.isCurrent = true;
        }

        navNodes.push(navNode);

        if (workflowNode.children.length > 0) {
          this.domToNav(workflowNode.children, navNode.children);
        }
      }
    });
  }

  /**
   * Any runtime adjustments can be made here.
   */
  adjustNavNode(node: NavTreeNode) {
    if (node.value == 'maturity-questions') {
      const alias = this.assessSvc.assessment?.maturityModel?.questionsAlias;
      if (!!alias) {
        node.label = alias;
      }
    }
  }

  /**
   * 
   */
  setWorkflow(name: string) {
    const url = 'assets/navigation/workflow-' + name + '.xml';
    this.http.get(url, { responseType: 'text' }).subscribe((xml: string) => {
      let d = new DOMParser();
      this.workflow = d.parseFromString(xml, 'text/xml');
      localStorage.removeItem('tree');
      this.buildTree(this.getMagic());
    },
      (err: HttpErrorResponse) => {
        debugger;
        console.log(err);
      });
  }

  /**
   * Crawls the workflow document to determine the next viewable page.
   */
  navNext(cur: string) {
    const currentPage = this.workflow.getElementById(cur);

    if (currentPage == null) {
      return;
    }

    if (currentPage.children.length == 0 && currentPage.nextElementSibling == null && currentPage.parentElement.tagName == 'nav') {
      // we are at the last page, nothing to do
      return;
    }

    let target = currentPage;

    do {
      if (target.children.length > 0) {
        target = <HTMLElement>target.firstElementChild;
      } else {
        while (!target.nextElementSibling) {
          target = <HTMLElement>target.parentElement;
        }
        target = <HTMLElement>target.nextElementSibling;
      }
    } while (!this.canLandOn(target) || !this.showPage(target));

    this.routeToTarget(target);
  }

  /**
   * Crawls the workflow document to determine the previous viewable page.
   */
  navBack(cur: string) {
    const currentPage = this.workflow.getElementById(cur);

    if (currentPage == null) {
      return;
    }

    if (currentPage.previousElementSibling == null && currentPage.parentElement.tagName == 'nav') {
      // we are at the first page, nothing to do
      return;
    }

    let target = currentPage;

    do {
      if (target.children.length > 0) {
        target = <HTMLElement>target.lastElementChild;
      } else {
        while (!target.previousElementSibling) {
          target = <HTMLElement>target.parentElement;
        }
        target = <HTMLElement>target.previousElementSibling;
      }
    } while (!this.canLandOn(target) || !this.showPage(target));

    this.routeToTarget(target);
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
   * Indicates if you can "land on" the page.
   * Phase nodes (or any parent node) can't be landed on
   * because they aren't displayable pages.  They function
   * as collapsible nodes in the nav tree.
   */
  canLandOn(page: HTMLElement): boolean {
    // pages without a path can't be landed on/navigated to
    if (!page.hasAttribute('path')) {
      return false;
    }

    return true;
  }

  /**
   * Evaluates conditions where a page should be hidden and
   * ignored in the TOC and next/back workflow.
   */
  showPage(page: HTMLElement): boolean {
    const conditionAttrib = page.attributes['condition']?.value;

    if (!conditionAttrib || conditionAttrib.length === 0) {
      return true;
    }

    let show = true;
    
    // All conditions must be true (AND).  
    // Start with true and if any fail, result is false.
    let conditions = conditionAttrib.toUpperCase().split(' ');
    conditions.forEach(c => {

      // if 'HIDE' is present, this trumps everything else
      if (c == 'HIDE') {
        show = false;
      }

      if (c.startsWith('INSTALL-MODE:')) {
        let target = c.substring(c.indexOf(':') + 1);
        if (this.configSvc.installationMode == target) {
          show = show && true;
        }
      }

      // maturity 
      if (c === 'USE-MATURITY') {
        show = show && (
          !!this.assessSvc.assessment
          && this.assessSvc.assessment.useMaturity);
      }


      // standard 
      if (c === 'USE-STANDARD') {
        show = show && (
          !!this.assessSvc.assessment
          && this.assessSvc.assessment.useStandard);
      }


      // diagram 
      if (c === 'USE-DIAGRAM') {
        show = show && (
          !!this.assessSvc.assessment
          && this.assessSvc.assessment.useDiagram);
      }


      // look for the specified maturity model
      if (c.startsWith('MATURITY:')) {
        let target = c.substring(c.indexOf(':') + 1);

        show = show && (
        !!this.assessSvc.assessment
        && this.assessSvc.assessment.useMaturity
        && this.assessSvc.usesMaturityModel(target));
      }


      // hide if specified maturity model is present
      if (c.startsWith('MATURITY-NOT:')) {
        let target = c.substring(c.indexOf(':') + 1);

        show = show && (
        !!this.assessSvc.assessment
        && this.assessSvc.assessment.useMaturity
        && !this.assessSvc.usesMaturityModel(target));
      }


      // look for any of the listed maturity models
      if (c.startsWith('MATURITY-ANY(')) {
        let found = false;
        let p1 = c.indexOf('(');
        let p2 = c.indexOf(')');
        let targetText = c.substring(p1 + 1, p2);
        var targets = targetText.split(',');
        targets.forEach(t => {
          found = found || (
            !!this.assessSvc.assessment
            && this.assessSvc.assessment.useMaturity
            && this.assessSvc.usesMaturityModel(t.trim()));
        });

        show = show && found;
      }


      // is maturity target level greater than X
      if (c.startsWith('TARGET-LEVEL-GT:')) {
        let target = c.substring(c.indexOf(':') + 1);
        show = show && this.assessSvc.assessment.maturityModel.maturityTargetLevel > Number.parseInt(target);
      }


      if (c == 'SHOW-EXEC-SUMMARY') {
        show = show && this.showExecSummaryPage();
      }

    });

    return show;
  }

  /**
   * Navigates to the path specified in the target node.
   */
  routeToTarget(target: HTMLElement) {
    this.setCurrentPage(target.id);

    // determine the route path
    const targetPath = target.attributes['path'].value.replace('{:id}', this.assessSvc.id().toString());
    this.router.navigate([targetPath]);
  }

  /**
   * Determines if the specified page is the last visible page in the nav flow.
   * Used to hide the "Next" button.
   * @returns
   */
  isLastVisiblePage(id: string): boolean {
    let target = this.workflow.getElementById(id);

    do {
      if (target.children.length > 0) {
        target = <HTMLElement>target.firstElementChild;
      } else if (!target.nextElementSibling) {
        while (!target.nextElementSibling && target.tagName != 'nav') {
          target = <HTMLElement>target.parentElement;
        }
        target = <HTMLElement>target.nextElementSibling;
      }
    } while (!!target && !this.showPage(target));

    if (!target) {
      return true;
    }

    return false;
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
  setCurrentPage(id: string) {
    this.clearCurrentPage(this.dataSource?.data);

    const currentNode = this.findInTree(this.dataSource.data, id);

    if (!!currentNode) {
      currentNode.isCurrent = true;
      this.currentPage = currentNode.value;
    }
  }

  /**
   * 
   */
  showExecSummaryPage(): boolean {
    let assessment = this.assessSvc.assessment;
    return assessment?.useDiagram || assessment?.useStandard;
  }

}
