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
