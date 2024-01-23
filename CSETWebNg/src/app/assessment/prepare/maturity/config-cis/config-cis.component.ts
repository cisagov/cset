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
import { MatDialog } from '@angular/material/dialog';
import { AlertComponent } from '../../../../dialogs/alert/alert.component';
import { ConfirmComponent } from '../../../../dialogs/confirm/confirm.component';
import { AssessmentDetail } from '../../../../models/assessment-info.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { CisService } from '../../../../services/cis.service';

@Component({
  selector: 'app-config-cis',
  templateUrl: './config-cis.component.html'
})
export class ConfigCisComponent implements OnInit {

  assessmentId: number;

  assessment: AssessmentDetail;

  baselineAssessmentId?: number;

  baselineCandidates: any[];

  importSourceCandidates: any[];

  /**
   *
   */
  constructor(
    public assessmentSvc: AssessmentService,
    public cisSvc: CisService,
    public dialog: MatDialog
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    this.assessmentId = this.assessmentSvc.assessment?.id;
    this.assessment = this.assessmentSvc.assessment;

    // call API for CIS assessments other than the current one
    this.cisSvc.getMyCisAssessments().subscribe((resp: any) => {
      resp.myCisAssessments.sort((a, b) => {
        return new Date(a.assessmentDate) > new Date(b.assessmentDate) ? 1 : -1;
      });
      this.baselineAssessmentId = resp.baselineAssessmentId;
      this.cisSvc.baselineAssessmentId = resp.baselineAssessmentId;

      // remove the current assessment from the candidate lists
      this.baselineCandidates = Object.assign(resp.myCisAssessments).filter(x => x.id !== this.assessmentId);
      this.importSourceCandidates = Object.assign(resp.myCisAssessments).filter(x => x.id !== this.assessmentId);
    });
  }

  /**
   * Persist the user's choice of baseline assessment (or none).
   */
  changeBaseline(event: any) {
    var baselineId = event.target.value;
    this.cisSvc.saveBaseline(baselineId).subscribe();
  }

  /**
   *
   */
  confirmImportSurvey(importSelect: any) {
    if (this.dialog.openDialogs[0]) {
      return;
    }

    var assessToBeImported = +importSelect.value;

    const dialogRef = this.dialog.open(ConfirmComponent);

    dialogRef.componentInstance.confirmMessage =
      "This will replace all answers in the current survey with "
      + "those of the imported survey.  This action cannot be undone. "
      + "Continue?";

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.cisSvc.importSurvey(this.assessmentId, assessToBeImported)
          .subscribe(() => {
            this.dialog.open(AlertComponent, {
              data: { messageText: 'Import complete.' }
            });
          });
      }
    });
  }

  /**
   * Persist changes made to the current assessment
   */
  updateAssessment() {
    // default assessment name if it is left empty
    if (this.assessment.assessmentName.trim().length === 0) {
      this.assessment.assessmentName = "(Untitled Assessment)";
    }
    this.assessmentSvc.updateAssessmentDetails(this.assessment);
  }
}
