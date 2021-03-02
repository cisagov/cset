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
import { MaturityService } from '../../services/maturity.service';
import { MaturityQuestionResponse } from '../../models/questions.model';

@Component({
  selector: 'edm',
  templateUrl: './edm.component.html',
  styleUrls: ['../reports.scss', 'edm.component.scss']
})
export class EdmComponent implements OnInit {

  orgName: string;

  /**
   * 
   * @param maturitySvc 
   */
  constructor(
    public maturitySvc: MaturityService
  ) {
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
}
