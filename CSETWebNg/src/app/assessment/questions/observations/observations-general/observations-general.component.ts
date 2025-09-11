import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { ObservationDetailComponent } from '../observation-detail.component';
import { Importance, Observation } from '../observations.model';
import { ObservationsService } from '../../../../services/observations.service';
import { TranslocoService } from '@jsverse/transloco';
import { LayoutService } from '../../../../services/layout.service';
import { ConfirmComponent } from '../../../../dialogs/confirm/confirm.component';
import { AssessmentService } from '../../../../services/assessment.service';
import { firstValueFrom } from 'rxjs';


@Component({
  selector: 'app-observations-general',
  templateUrl: './observations-general.component.html',
  standalone: false
})
export class ObservationsGeneralComponent implements OnInit {

  observations: any[];

  /**
   * 
   */
  constructor(
    public assessSvc: AssessmentService,
    public obsSvc: ObservationsService,
    public tSvc: TranslocoService,
    public dialog: MatDialog,
    public layoutSvc: LayoutService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.populateList();
  }

  /**
   * 
   */
  populateList(): void {
    this.obsSvc.getAssessmentLevelObservations().subscribe(
      (response: Observation[]) => {
        this.observations = response;
      },
      error => {
        console.error('Error updating observations | ' + (<Error>error).message);
      });
  }

  /**
   * 
   */
  async editObservation(observationId) {
    let obs = await firstValueFrom(this.obsSvc.getObservation(-1, observationId, -1, ''));

    if (!obs) {
      obs = this.buildEmptyObservation();
      // this component only builds assessment-level observations
      obs.answerLevel = false;
    }

    this.dialog.open(ObservationDetailComponent, {
      data: obs,
      disableClose: true,
      width: this.layoutSvc.hp ? '90%' : '750px',
      maxWidth: this.layoutSvc.hp ? '90%' : '750px',
    })
      .afterClosed().subscribe(result => {
        this.populateList();
      });
  }

  /**
   * Deletes an Observation.
   * @param obsToDelete
   */
  deleteObservation(obsToDelete) {
    // Build a message whether the observation has a title or not
    let msg = this.tSvc.translate('observation.delete observation confirm');
    msg = msg.replace('{title}', obsToDelete.summary);

    if (obsToDelete.summary === null) {
      msg = this.tSvc.translate('observation.delete this observation confirm');
    }

    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage = msg;

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.obsSvc.deleteObservation(obsToDelete.observation_Id).subscribe();
        let deleteIndex = -1;

        for (let i = 0; i < this.observations.length; i++) {
          if (this.observations[i].observation_Id === obsToDelete.observation_Id) {
            deleteIndex = i;
          }
        }
        this.observations.splice(deleteIndex, 1);
      }
    });
  }

  /**
   * 
   */
  buildEmptyObservation(): Observation {
    return {
      // ACET fields
      question_Id: 0,
      questionType: '',
      answer_Id: 0,
      assessmentId: null,
      observation_Id: 0,
      summary: '',
      issue: '',
      impact: '',
      recommendations: '',
      vulnerabilities: '',
      resolution_Date: new Date(),
      importance_Id: 0,
      // ISE fields
      title: '',
      type: '',
      risk_Area: '',
      sub_Risk: '',
      description: '',
      citations: '',
      actionItems: '',
      auto_Generated: 0,
      supp_Guidance: '',
      // Shared fields
      importance: {} as Importance,
      observation_Contacts: [],
      answerLevel: false
    };
  }
}
