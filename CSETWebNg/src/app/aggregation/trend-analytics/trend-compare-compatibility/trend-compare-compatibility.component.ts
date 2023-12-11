////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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

import { Component, Input, OnInit } from '@angular/core';
import { AggregationService } from '../../../services/aggregation.service';
import { AssessmentService } from '../../../services/assessment.service';
import { NgbTimepickerI18nDefault } from '@ng-bootstrap/ng-bootstrap/timepicker/timepicker-i18n';


interface UserAssessment {
  assessmentId: number;
  assessmentName: string;
  assessmentCreatedDate: string;
  selected: boolean;
  useMaturity: boolean;
  selectedMaturityModel: string;
}

@Component({
  selector: 'app-trend-compare-compatibility',
  templateUrl: './trend-compare-compatibility.component.html'
})
export class TrendCompareCompatibilityComponent implements OnInit {
  
  assessments: UserAssessment[];
  aggregation: any = {};
  message: string = 'Assessment compatibility or maturity model title will show once selection is made';
  maturity: boolean; 

  /**
   * CTOR
   * @param assessmentSvc
   * @param aggregationSvc
   */
  constructor(
    public aggregationSvc: AggregationService,
    private assessmentSvc: AssessmentService
  ) { }

  ngOnInit() {
    let answer = this.getAssessmentsForUser()
  }

  getAssessmentsForUser() {

    this.assessmentSvc.getAssessments().subscribe((resp: UserAssessment[]) => {
      this.assessments = resp;


      this.aggregationSvc.getAssessments().subscribe((resp2: any) => {
        this.aggregation = resp2.aggregation;
        


        resp2.assessments.forEach(selectedAssess => {
          this.assessments.find(x => x.assessmentId === selectedAssess.assessmentId).selected = true;
        });

        let result = this.assessmentTypeCheck()
        return result; 

      });
    })
  }

  assessmentTypeCheck() {
    for (let element of this.assessments) {
      if (element.selected === true) {
        if (element.useMaturity === true) {
          this.message = element.selectedMaturityModel + ' Maturity Model Comparison';
          this.maturity = true;
        } else {
          this.message = 'Standard';
          this.maturity = false;
        }
      }
    }
  }

  refresh(){
    this.getAssessmentsForUser()
  }
}
