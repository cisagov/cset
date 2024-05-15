import { Component } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { DatePipe } from '@angular/common';
import { MatDialog } from '@angular/material/dialog';
import { ConfigService } from '../../../../services/config.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { MaturityService } from '../../../../services/maturity.service';
import { CisService } from '../../../../services/cis.service';
import { ConfirmComponent } from '../../../../dialogs/confirm/confirm.component';
import { AlertComponent } from '../../../../dialogs/alert/alert.component';

@Component({
  selector: 'app-assessment-config-cie',
  templateUrl: './assessment-config-cie.component.html',
  styleUrls: ['./assessment-config-cie.component.scss']
})
export class AssessmentConfigCieComponent {
  assessment: any;
  baselineCandidates: any;
  importSourceCandidates: any;
  baselineAssessmentId: number;
  /**
   *
   */
  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public datePipe: DatePipe,
    public dialog: MatDialog,
    private maturitySvc: MaturityService,
    private cisSvc: CisService
  ) { }

  ngOnInit() {
    if (this.assessSvc.id()) {
      this.getAssessmentDetail();
      // call API for CIS assessments other than the current one
      this.maturitySvc.getMyCieAssessments().subscribe((resp: any) => {
        console.log(resp)
        resp.myCisAssessments.sort((a, b) => {
          return new Date(a.assessmentDate) > new Date(b.assessmentDate) ? 1 : -1;
        });
        this.baselineAssessmentId = resp.baselineAssessmentId;
        //this.cisSvc.baselineAssessmentId = resp.baselineAssessmentId;

        // remove the current assessment from the candidate lists
        this.baselineCandidates = Object.assign(resp.myCisAssessments).filter(x => x.id !== this.assessSvc.assessment.id);
        this.importSourceCandidates = Object.assign(resp.myCisAssessments).filter(x => x.id !== this.assessSvc.assessment.id);
      });
    }
  }

  
  /**
   * Called every time this page is loaded.
   */
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
    if (this.assessment.assessmentName.trim().length === 0) {
      this.assessment.assessmentName = "New Analysis";
    }
    // a few things for a brand new assessment
    if (this.assessSvc.isBrandNew) {
      // RRA install presets the maturity model
      if (this.configSvc.installationMode === 'RRA') {
        this.assessSvc.setRraDefaults();
        this.assessSvc.updateAssessmentDetails(this.assessment);
      }
    }

    this.assessSvc.isBrandNew = false;
    // Null out a 'low date' so that we display a blank
    const assessDate: Date = new Date(this.assessment.assessmentDate);
    if (assessDate.getFullYear() <= 1900) {
      this.assessment.assessmentDate = null;
    }
  }

    /**
   *
   */
  update(e) {
    // default Assessment Name if it is left empty
    if (!!this.assessment) {
      if (this.assessment.assessmentName.trim().length === 0) {
        this.assessment.assessmentName = "New Analysis";
      }
    }
    this.assessSvc.updateAssessmentDetails(this.assessment);
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
  confirmImportSurvey() {
    this.cisSvc.saveBaseline(this.baselineAssessmentId);
    const dialogRef = this.dialog.open(ConfirmComponent);

    dialogRef.componentInstance.confirmMessage =
      "This will replace all answers in the current survey with "
      + "those of the imported survey.  This action cannot be undone. "
      + "Continue?";

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.cisSvc.importSurvey(this.assessSvc.assessment.id, this.baselineAssessmentId)
          .subscribe(() => {
            this.dialog.open(AlertComponent, {
              data: { messageText: 'Import complete.' }
            });
          });
      }
    });
  }

}
