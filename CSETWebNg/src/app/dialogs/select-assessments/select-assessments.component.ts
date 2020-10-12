////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { AggregationService } from '../../services/aggregation.service';
import { MatDialogRef } from '@angular/material/dialog';

interface UserAssessment {
  AssessmentId: number;
  AssessmentName: string;
  AssessmentCreatedDate: string;
  Selected: boolean;
}

@Component({
  selector: 'app-select-assessments',
  templateUrl: './select-assessments.component.html'
})
export class SelectAssessmentsComponent implements OnInit {

  assessments: UserAssessment[];
  aggregation: any = {};

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

  getAssessmentsForUser() {
    this.assessmentSvc.getAssessments().subscribe((resp: UserAssessment[]) => {
      this.assessments = resp;

      this.aggregationSvc.getAssessments().subscribe((resp2: any) => {
        this.aggregation = resp2.Aggregation;

        resp2.Assessments.forEach(selectedAssess => {
          this.assessments.find(x => x.AssessmentId === selectedAssess.AssessmentId).Selected = true;
        });
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
   * Call the API to manage connections between aggregation and assessment.
   * @param event
   * @param assessment
   */
  toggleSelection(event, assessment) {
    this.aggregationSvc.saveAssessmentSelection(event.target.checked, assessment).subscribe((resp: any) => {
      this.aggregation = resp;
    });
  }

  /**
   *
   */
  close() {
    return this.dialog.close();
  }

}
