import { Component, OnInit } from '@angular/core';
import { NavigationEnd, Router } from '@angular/router';
import { MaturityQuestionResponse } from '../../../../models/questions.model';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { filter } from 'rxjs/operators';


/**
 * This page is used to house all domain-specific results pages for CRR.
 * The same component is used for various routes.  The route is 
 * parsed to determine which page the user requested.
 */
@Component({
  selector: 'app-crr-results-page',
  templateUrl: './crr-results-page.component.html',
  styleUrls: ['../../../../reports/reports.scss']
})
export class CrrResultsPage implements OnInit {

  public domain: any;
  public loaded = false;

  public pageName = "";
  public domainId = "";
  public domainName;


  /**
   * 
   * @param maturitySvc 
   * @param reportSvc 
   * @param configSvc 
   * @param router 
   */
  constructor(
    private maturitySvc: MaturityService,
    public configSvc: ConfigService,
    private router: Router
  ) {
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((e: any) => {
      var url: string = e.url;
      var slash = url.lastIndexOf('/');
      this.pageName = url.substr(slash + 1);
      this.domainId = this.pageName.substr(this.pageName.indexOf('crr-domain-') + 11).toUpperCase();
    });
  }


  /**
   * 
   */
  ngOnInit(): void {
    this.getQuestions();
  }

  /**
   * 
   */
  getQuestions() {
    this.maturitySvc.getQuestionsList(false, true).subscribe((resp: MaturityQuestionResponse) => {
      this.maturitySvc.domains = resp.groupings;

      this.maturitySvc.getReferenceText('CRR').subscribe((resp: any[]) => {
        this.maturitySvc.ofc = resp;
      });

      this.loaded = true;
    });
  }

  /**
   * 
   * @param abbrev 
   * @returns 
   */
  findDomain(abbrev: string) {
    if (!this.maturitySvc.domains) {
      return null;
    }

    let domain = this.maturitySvc.domains.find(d => d.abbreviation == abbrev);
    this.domain = domain;
    return domain;
  }
}
