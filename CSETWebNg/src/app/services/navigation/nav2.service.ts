import { NestedTreeControl } from '@angular/cdk/tree';
import { HttpClient } from '@angular/common/http';
import { EventEmitter, Injectable, Output } from '@angular/core';
import { MatTreeNestedDataSource } from '@angular/material/tree';
import { Router } from '@angular/router';
import { BehaviorSubject } from 'rxjs';
import { AssessmentService } from '../assessment.service';
import { ConfigService } from '../config.service';
import { NavTreeNode } from '../navigation.service';

@Injectable({
  providedIn: 'root'
})
export class Nav2Service {

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


  /**
   *
   */
  constructor(
    private assessSvc: AssessmentService,
    private configSvc: ConfigService,
    private router: Router,
    private http: HttpClient
  ) { }

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

  /**
   * 
   */
  analyticsIsUp(): boolean {
    return false;
  }
}
