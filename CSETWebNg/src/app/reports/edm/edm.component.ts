import { performanceLegend, relationshipFormationG1, relationshipFormationG2, relationshipFormationG3, relationshipFormationG4, relationshipFormationG5, relationshipFormationG6, performanceLegend2, relationshipFormationSummary } from './data';
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
import { Component, OnInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { MaturityService } from '../../services/maturity.service';
import { ACETService } from '../../services/acet.service';
import { DemographicService } from '../../services/demographic.service';
import { MaturityQuestionResponse } from '../../models/questions.model';
import { Demographic } from '../../models/assessment-info.model';
import { EDMBarChartModel } from './edm-bar-chart.model'

@Component({
  selector: 'edm',
  templateUrl: './edm.component.html',
  styleUrls: ['../reports.scss', 'edm.component.scss']
})
export class EdmComponent implements OnInit {

  orgName: string;
  displayName = '...';
  currentDate: Date;
  currentTimeZone: string;
  assesmentInfo: any;
  demographicData: Demographic = {};

  /**
   * 
   * @param maturitySvc 
   */
  constructor(
    private titleService: Title,
    public maturitySvc: MaturityService,
    public acetSvc: ACETService,
    public demoSvc: DemographicService
  ) {
  }

  /**
   * 
   */
  ngOnInit(): void {
    this.titleService.setTitle("Report - EDM");
    this.currentTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    this.currentTimeZone = this.currentTimeZone.replace("_", " ")
    this.currentDate = new Date();
    this.getAssementData();
    this.getQuestions();
  }

  /**
   * 
   */
  ngAfterViewInit() {
    setTimeout(() => {
      window.print();
    }, 500);
  }


  getAssementData() {
    this.maturitySvc.getMaturityDeficiency("EDM").subscribe(
      (r: any) => {
        this.assesmentInfo = r.information;
        this.demoSvc.getDemographic().subscribe(
          (data: Demographic) => {
            this.demographicData = data;
            this.orgName = this.demographicData.OrganizationName;
            if (this.demographicData.OrganizationName?.length > 0) {
              this.displayName = this.orgName;
            }
            else if (this.assesmentInfo.Facility_Name?.length > 0) {
              this.displayName = this.assesmentInfo.Facility_Name;
            } else {
              this.displayName = this.assesmentInfo.Assessment_Name;
            }
          },
          error => console.log('Demographic load Error: ' + (<Error>error).message)
        );
      },
      error => console.log('Assesment Information Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   */
  getQuestions() {
    this.maturitySvc.getQuestionsList(false, true).subscribe((resp: MaturityQuestionResponse) => {

      this.maturitySvc.domains = resp.Groupings.filter(x => x.GroupingType == 'Domain');

      this.maturitySvc.getReferenceText('EDM').subscribe((resp: any[]) => {
        this.maturitySvc.ofc = resp;
      });
    });
  }

  /**
   * 
   * @param abbrev 
   */
  findDomain(abbrev: string) {
    if (!this.maturitySvc.domains) {
      return null;
    }

    let domain = this.maturitySvc.domains.find(d => d.Abbreviation == abbrev);
    return domain;
  }

  /**
 * 
 * @param el 
 */
  scroll(eId: string) {
    const element = document.getElementById(eId);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  }
}
