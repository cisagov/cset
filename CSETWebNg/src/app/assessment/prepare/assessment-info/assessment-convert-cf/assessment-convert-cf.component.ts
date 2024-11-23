import { Component, Input, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConversionService } from '../../../../services/conversion.service';
import { OkayComponent } from '../../../../dialogs/okay/okay.component';
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { ConfirmComponent } from '../../../../dialogs/confirm/confirm.component';
import { TranslocoService } from '@jsverse/transloco';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { GalleryService } from '../../../../services/gallery.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-assessment-convert-cf',
  templateUrl: './assessment-convert-cf.component.html'
})
export class AssessmentConvertCfComponent implements OnInit {

  dialogRef: MatDialogRef<OkayComponent>;
  @Input() isEntry: boolean;

  /**
   * CTOR
   */
  constructor(
    private assessSvc: AssessmentService,
    public tSvc: TranslocoService,
    private convertSvc: ConversionService,
    public dialog: MatDialog,
    private navSvc: NavigationService,
    private gallerySvc: GalleryService,
    public router: Router
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
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
    const msg1 = this.tSvc.translate('cyber-florida.upgrade confirm 1');
    const msg2 = this.tSvc.translate('cyber-florida.upgrade confirm 2');
    const titleComplete = this.tSvc.translate('cyber-florida.title upgrade complete');

    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage = msg1;

    dialogRef.afterClosed().subscribe(confirmed => {
      if (confirmed) {
        if (this.isEntry) {          
          this.convertSvc.convertCfToMid().subscribe((resp: any) => {
            console.log(resp);
            var tmpMsg = msg2 + "\n Your new assessment is named "+ resp.newName;
            const dlgOkay = this.dialog.open(OkayComponent, { data: { title: titleComplete, messageText: tmpMsg } });
            dlgOkay.componentInstance.hasHeader = true;
             dlgOkay.afterClosed().subscribe(() => {
              this.router.navigate(['/landing-page-tabs'], {
                queryParams: {
                  'tab': 'myAssessments'
                },
                queryParamsHandling: 'merge',
              });
                           
            });
            
          });
        }
        else {
          this.convertSvc.convertMidToFull().subscribe((resp: any) => {            
            var tmpMsg = msg2 + "\n Your new assessment is named "+ resp.newName;    
            const dlgOkay = this.dialog.open(OkayComponent, { data: { title: titleComplete, messageText: tmpMsg } });
            dlgOkay.componentInstance.hasHeader = true;
             dlgOkay.afterClosed().subscribe(() => {
              this.router.navigate(['/landing-page-tabs'], {
                queryParams: {
                  'tab': 'myAssessments'
                },
                queryParamsHandling: 'merge',
              });
            });
          });
        }
      }
      
    });
  }
}
