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
import { Component, OnInit, ViewChild } from '@angular/core';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { AggregationService } from '../../services/aggregation.service';
import { MatDialogRef } from '@angular/material/dialog';
import { forEach, remove } from 'lodash';


interface UserAssessment {
  assessmentId: number;
  assessmentName: string;
  assessmentCreatedDate: string;
  selected: boolean;
  useMaturity: boolean;
  selectedMaturityModel: string;

  // used to filter selectable assessments in the list
  disabled: boolean;
}

@Component({
  selector: 'app-select-assessments',
  templateUrl: './select-assessments.component.html'
})
export class SelectAssessmentsComponent implements OnInit {

  assessments: UserAssessment[];
  aggregation: any = {};

  selectedMaturityModel?: string = null;
  standardSelected: boolean = false;

  @ViewChild('refreshComponent') refreshComponent;

  /**
   * CTOR
   * @param assessmentSvc
   * @param authSvc
   */
  constructor(
    private dialog: MatDialogRef<SelectAssessmentsComponent>,
    private assessmentSvc: AssessmentService,
    private authSvc: AuthenticationService,
    public aggregationSvc: AggregationService
  ) { }

  ngOnInit() {
    // get my assessment list
    this.getAssessmentsForUser();
  }

  /**
   * Requests a list of the user's assessments 
   */
  getAssessmentsForUser() {
    this.assessmentSvc.getAssessments().subscribe((resp: UserAssessment[]) => {
      this.assessments = resp;

      this.aggregationSvc.getAssessments().subscribe((resp2: any) => {
        this.aggregation = resp2.aggregation;

        resp2.assessments.forEach(selectedAssess => {
          this.assessments.find(x => x.assessmentId === selectedAssess.assessmentId).selected = true;
        });

        this.checkSelectedType();
        this.filterAssessments();
        this.refreshComponent.refresh();
      });
    },
      error =>
        console.log(
          "Unable to get Assessments for " +
          this.authSvc.email() +
          ": " +
          (<Error>error).message
        ));
  }

  /**
   * Sets a component-level indicator for a selected maturity model
   * or any selected standard-based assessment, whichever is found first.
   */
  checkSelectedType() {
    this.selectedMaturityModel = null;
    this.standardSelected = false;

    for (let element of this.assessments) {
      if (element.selected) {
        if (element.useMaturity) {
          this.selectedMaturityModel = element.selectedMaturityModel;
          return;
        }

        this.standardSelected = true;
        return;
      }
    }
  }

  /**
   * Sets a 'disabled' flag for assessments that are not compatible
   * with whatever has been selected, e.g., any standard or a specific
   * maturity model.
   */
  filterAssessments() {
    for (let element of this.assessments) {
      element.disabled = false;

      if (!!this.selectedMaturityModel) {
        if (!element.useMaturity) {
          element.disabled = true;
        } else if (element.selectedMaturityModel != this.selectedMaturityModel) {
          element.disabled = true;
        }
      }
      
      if (!!this.standardSelected) {
        if (element.useMaturity) {
          element.disabled = true;
        }
      }
    }
  }

  /**
   * Call the API to manage connections between aggregation and assessment.
   * @param event
   * @param assessment
   */
  toggleSelection(event, assessment) {
    this.aggregationSvc.saveAssessmentSelection(event.target.checked, assessment).subscribe((resp: any) => {
      this.aggregation = resp;

      // refresh the assessment list
      this.getAssessmentsForUser();
    });
  }

  /**
   *
   */
  close() {
    return this.dialog.close();
  }

}
