import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from './assessment.service';
import { StandardService } from './standard.service';

/**
 * A service that provides intelligent NEXT and BACK routing.
 * Some pages are hidden, and this service knows what to do.
 *
 * Maybe someday a single 'navigation service' can be created.
 */
@Injectable({
  providedIn: 'root'
})
export class Navigation2Service {

  pages = [
    // Prepare
    { pageClass: 'info', path: 'assessment/{:id}/prepare/info' },
    { pageClass: 'sal', path: 'assessment/{:id}/prepare/sal' },
    { pageClass: 'standards', path: 'assessment/{:id}/prepare/standards' },
    { pageClass: 'framework', path: 'assessment/{:id}/prepare/framework', condition: 'FRAMEWORK' },
    { pageClass: 'required', path: 'assessment/{:id}/prepare/required', condition: 'ACET' },
    { pageClass: 'irp', path: 'assessment/{:id}/prepare/irp', condition: 'ACET' },
    { pageClass: 'irp-summary', path: 'assessment/{:id}/prepare/irp-summary', condition: 'ACET' },

    //  Diagram
    { pageClass: 'diagram', path: 'assessment/{:id}/diagram'},
    { pageClass: 'diagram-inventory', path: 'assessment/{:id}/diagram/inventory'},

    // Questions/Requirements/Statements
    { pageClass: 'questions', path: 'assessment/{:id}/questions' },

    // Results - Standards
    { pageClass: 'dashboard', path: 'assessment/{:id}/results/dashboard' },
    { pageClass: 'ranked-questions', path: 'assessment/{:id}/results/ranked-questions' },
    { pageClass: 'standards-summary', path: 'assessment/{:id}/results/standards-summary' },
    { pageClass: 'standards-ranked', path: 'assessment/{:id}/results/standards-ranked' },
    { pageClass: 'standards-results', path: 'assessment/{:id}/results/standards-results' },

    // Results - Components
    { pageClass: 'components-summary', path: 'assessment/{:id}/results/components-summary' },
    { pageClass: 'components-ranked', path: 'assessment/{:id}/results/components-ranked' },
    { pageClass: 'components-results', path: 'assessment/{:id}/results/components-results' },
    { pageClass: 'components-types', path: 'assessment/{:id}/results/components-types' },
    { pageClass: 'components-warnings', path: 'assessment/{:id}/results/components-warnings' },

    // ACET results pages
    { pageClass: 'maturity', path: 'assessment/{:id}/results/maturity', condition: 'ACET' },
    { pageClass: 'admin', path: 'assessment/{:id}/results/admin', condition: 'ACET' },
    { pageClass: 'acetDashboard', path: 'assessment/{:id}/results/acetDashboard', condition: 'ACET' },

    { pageClass: 'overview', path: 'assessment/{:id}/results/overview' },
    { pageClass: 'reports', path: 'assessment/{:id}/results/reports' },
    { pageClass: 'feedback', path: 'assessment/{:id}/results/analysis/feedback'}
  ];

  /**
   * Constructor
   * @param router
   */
  constructor(
    private assessSvc: AssessmentService,
    private standardSvc: StandardService,
    private router: Router
  ) { }


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
    while (newPageIndex >= 0 && !showPage) {
      newPageIndex = newPageIndex - 1;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
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
    while (newPageIndex < this.pages.length && !showPage) {
      newPageIndex = newPageIndex + 1;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
    }

    const newPath = this.pages[newPageIndex].path.replace('{:id}', this.assessSvc.id().toString());
    console.log(newPath);
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
      return !this.standardSvc.acetSelected;
    }

    if (condition === 'ACET') {
      return this.standardSvc.acetSelected;
    }

    if (condition === 'FRAMEWORK') {
      return this.standardSvc.frameworkSelected;
    }

    if (condition === 'FALSE') {
      return false;
    }

    return true;
  }
}
