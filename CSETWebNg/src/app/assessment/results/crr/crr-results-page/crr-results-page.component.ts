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
import { Component, OnInit } from '@angular/core';
import { NavigationEnd, Router } from '@angular/router';
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
  public domainAbbrev = "";
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
      this.domainAbbrev = this.pageName.substr(this.pageName.indexOf('crr-domain-') + 11).toUpperCase();
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
    this.maturitySvc.getStructure(this.domainAbbrev).subscribe((resp: any) => {
      this.domain = resp.Domain;
      this.domain.Goal.forEach(g => {
        // The Question object needs to be an array for the template to work.
        // A singular question will be an object.  Create an array and push the question into it
        if (!Array.isArray(g.Question)) {
          var onlyChild = Object.assign({}, g.Question);
          g.Question = [];
          g.Question.push(onlyChild);
        }
      });

      this.loaded = true;
    });
  }
}
