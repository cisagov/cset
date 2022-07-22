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

  /**
   *
   */
  constructor(
    private assessSvc: AssessmentService,
    private configSvc: ConfigService,
    private router: Router,
    private http: HttpClient
  ) { 
    this.setWorkflow('classic');
    debugger;
  }


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

    // for (let i = 0; i < this.pages.length; i++) {
    //   let p = this.pages[i];
    //   let visible = this.shouldIShow(p.condition);

    //   const node: NavTreeNode = {
    //     label: p.displayText,
    //     value: p.pageId,
    //     isPhaseNode: false,
    //     children: [],
    //     expandable: true,
    //     visible: visible
    //   };

    //   // the node might need tweaking based on certain factors
    //   this.adjustNode(node);

    //   if (p.level === 0) {
    //     node.isPhaseNode = true;
    //   }

    //   if (this.currentPage === node.value) {
    //     node.isCurrent = true;
    //   }

    //   const parentPage = this.findParentPage(i);
    //   node.index = i;
    //   if (!!parentPage) {
    //     const parentNode = this.findInTree(toc, parentPage.pageId);
    //     if (!!parentNode) {
    //       parentNode.children.push(node);
    //     }
    //   } else {
    //     toc.push(node);
    //   }
    // }

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
   * 
   */
  setWorkflow(name: string) {
    this.http.get('assets/navigation/workflow-' + name + '.xml', { responseType: 'text' }).subscribe((xml: string) => {
      let d = new DOMParser();
      this.workflow = d.parseFromString(xml, 'text/xml');
    });
  }

  /**
   *
   * @param cur
   */
  navNext(cur: string) {
    const currentPage = this.workflow.getElementById(cur);

    if (currentPage == null) {
      return;
    }

    if (currentPage.children.length == 0 && currentPage.nextElementSibling == null) {
      // we are at the last page, nothing to do
      return;
    }

    let potentialTarget = currentPage;

    do {
      if (potentialTarget.children.length > 0) {
        potentialTarget = <HTMLElement>potentialTarget.firstElementChild;
      } else {
        potentialTarget = <HTMLElement>potentialTarget.nextElementSibling;
      }
    } while (!this.showPage(potentialTarget));


    this.setCurrentPage(potentialTarget.id);

    const newPath = potentialTarget.attributes['path'].replace('{:id}', this.assessSvc.id().toString());
    this.router.navigate([newPath]);
  }

  /**
   * 
   */
  navBack(cur: string) {
    const currentPage = this.workflow.getElementById(cur);

    if (currentPage == null) {
      return;
    }

    if (currentPage.previousElementSibling == null && currentPage.parentElement.tagName == 'NAV') {
      // we are at the first page, nothing to do
      return;
    }

    let potentialTarget = currentPage;


    do {
      if (potentialTarget.previousElementSibling == null) {
        potentialTarget = <HTMLElement>potentialTarget.parentElement;
      } else {
        potentialTarget = <HTMLElement>potentialTarget.previousElementSibling;
      }
    } while (!this.showPage(potentialTarget));



    this.setCurrentPage(potentialTarget.id);

    const newPath = potentialTarget.attributes['path'].replace('{:id}', this.assessSvc.id().toString());
    this.router.navigate([newPath]);
  }

  /**
   * Routes to the path configured for the specified pageId.
   * @param value
   */
  navDirect(id: string) {
    // if the target is a simple string, find it in the pages structure
    // and navigate to its path
    if (typeof id == 'string') {
      let targetPage = this.workflow.getElementById(id);

      if (targetPage == null) {
        console.error('Cannot find \'' + id + ' \'in navigation tree');
        return;
      }

      // if they clicked on a tab there won't be a path -- nudge them to the next page
      if (!targetPage.hasAttribute('path')) {
        this.navNext(id);
        return;
      }

      this.setCurrentPage(targetPage.id);

      // determine the route path
      const targetPath = targetPage.attributes['path'].replace('{:id}', this.assessSvc.id().toString());
      this.router.navigate([targetPath]);
      return;
    }


    // they clicked on a question category, send them to questions

    // if (this.router.url.endsWith('/questions')) {
    //   // we are sitting on the questions screen, tell it to just scroll to the desired subcat
    //   this.scrollToQuestion.emit(this.questionsSvc.buildNavTargetID(navTarget));
    // } else {
    //   // stash the desired question group and category ID
    //   this.questionsSvc.scrollToTarget = this.questionsSvc.buildNavTargetID(navTarget);

    //   // navigate to the questions screen
    //   let targetPage = this.pages.find(p => p.pageId === 'phase-assessment');
    //   this.setCurrentPage(targetPage.pageId);

    //   const targetPath = targetPage.path.replace('{:id}', this.assessSvc.id().toString());
    //   this.router.navigate([targetPath]);
    // }
  }

  /**
   * 
   * @param page 
   * @returns 
   */
  showPage(page: HTMLElement): boolean {
    if (!page.hasAttribute('path')) {
      return false;
    }

    return true;
  }

  /**
   * Determines if the specified page is the last visible page in the nav flow.
   * Used to hide the "Next" button.
   * @returns
   */
   isLastVisiblePage(id: string): boolean {
    return false; // TODO
    //var x = this.workflow.lastElementChild
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
   * Dynamically adds the subnodes to the pages array.
   */
   insertCisNodes() {
    // if (!this.pages || !this.cisSubnodes || this.cisSubnodes.length === 0) {
    //   return;
    // }

    // // if the CIS nodes are already in the array, nothing to do
    // if (this.pages.findIndex(x => x.pageId == this.cisSubnodes[0].pageId) >= 0) {
    //   return;
    // }

    // let cisTopIndex = this.pages.findIndex(g => g.pageId == 'maturity-questions-nested');
    // if (cisTopIndex > 0) {
    //   this.pages.splice(cisTopIndex + 1, 0, ...this.cisSubnodes);
    // }
  }

  /**
   * 
   */
  showExecSummaryPage(): boolean {
    let assessment = this.assessSvc.assessment;
    return assessment?.useDiagram || assessment?.useStandard;
  }

  /**
   * 
   */
  analyticsIsUp(): boolean {
    return false;
  }
}
