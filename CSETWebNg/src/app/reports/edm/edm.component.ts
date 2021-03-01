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



  //scoring components 
  rfScores: any[];

  performanceLegend: any[];
  performanceLegend2: any[];
  relationshipFormationSummary: any[];
  relationshipFormationG1: any[];
  relationshipFormationG2: any[];
  relationshipFormationG3: any[];
  relationshipFormationG4: any[];
  relationshipFormationG5: any[];
  relationshipFormationG6: any[];
  view: any[] = [400, 50];
  view2: any[] = [200, 150];

  // performance summary legend options
  performanceLegendShowXAxis: boolean = false;
  performanceLegendShowYAxis: boolean = true;
  gradient: boolean = false;
  showLegend: boolean = false;
  performanceLegendYAxisLabel: string = 'Legend';
  performanceLegendXAxisLabel: string = '(example responses)';
  performanceLegendShowXAxisLabel: boolean = true;

  // performance summary goal charts options
  goalShowXAxis: boolean = false;
  goalShowYAxis: boolean = false;
  goalShowXAxisLabel: boolean = false;
  goalShowYAxisLabel: boolean = false;

  colorScheme = {
    domain: ['#5AA454', '#C7B42C', '#A10A28', '#AAAAAA']
  };

  /**
   * 
   * @param maturitySvc 
   */
  constructor(public maturitySvc: MaturityService) {
    Object.assign(this, { performanceLegend });
    Object.assign(this, { performanceLegend2 });
    Object.assign(this, { relationshipFormationSummary });
    Object.assign(this, { relationshipFormationG1 });
    Object.assign(this, { relationshipFormationG2 });
    Object.assign(this, { relationshipFormationG3 });
    Object.assign(this, { relationshipFormationG4 });
    Object.assign(this, { relationshipFormationG5 });
    Object.assign(this, { relationshipFormationG6 });
  }

  /**
   * 
   */
  ngOnInit(): void {
    this.getEdmScoresRf();
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

  /**
   * 
   */
  getEdmScoresRf() {
    this.maturitySvc.getEdmScores('RF').subscribe(
      (r: any) => {
        this.rfScores = r;
      },
      error => console.log('RF Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   * @param score 
   */
  getEdmScoreStyle(score) {
    switch (score.toLowerCase()) {
      case 'red': return 'red-score';
      case 'yellow': return 'yellow-score';
      case 'green': return 'green-score';
      default: return 'default-score';
    }
  }
}
