import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConversionService } from '../../../../services/conversion.service';
import { OkayComponent } from '../../../../dialogs/okay/okay.component';
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { ConfirmComponent } from '../../../../dialogs/confirm/confirm.component';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-assessment-convert-cf',
  templateUrl: './assessment-convert-cf.component.html'
})
export class AssessmentConvertCfComponent implements OnInit {

  isCfEntry = false;
  dialogRef: MatDialogRef<OkayComponent>;


  /**
   * CTOR
   */
  constructor(
    private assessSvc: AssessmentService,
    public tSvc: TranslocoService,
    private convertSvc: ConversionService,
    public dialog: MatDialog
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    // determine if this assessment is a Cyber Florida "entry" assessment.
    if (this.assessSvc.assessment.origin == 'CF') {
      this.convertSvc.isEntryCfAssessment().subscribe((resp: boolean) => {
        this.isCfEntry = resp;
      });
    }
  }

  /**
   * Call an endpoint that handles conversions.  The endpoint:
   *   1 - Adds a DETAILS_DEMOGRAPHICS record that says this used to be a limited CF 
   *   2 - Delete the MATURITY-SUBMODEL 'CF RRA' record
   *   3 - Swap out the AVAILABLE_SETS record for the full CSF record
   * 
   * Reload the assessment.
   */
  convert() {
    const msg1 = this.tSvc.translate('cyberFlorida.convert confirm 1');
    const msg2 = this.tSvc.translate('cyberFlorida.convert confirm 2');
    const titleComplete = this.tSvc.translate('cyberFlorida.title convert complete');

    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage = msg1;

    dialogRef.afterClosed().subscribe(confirmed => {
      if (confirmed) {
        this.convertSvc.convertCfSub().subscribe(resp => {
          this.assessSvc.loadAssessment(this.assessSvc.assessment.id);
          this.isCfEntry = false;

          const dlgOkay = this.dialog.open(OkayComponent, { data: { title: titleComplete, messageText: msg2 } });
          dlgOkay.componentInstance.hasHeader = true;
        });
      }
    });
  }
}
