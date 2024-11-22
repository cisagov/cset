import { Component, Input, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConversionService } from '../../../../services/conversion.service';
import { OkayComponent } from '../../../../dialogs/okay/okay.component';
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { ConfirmComponent } from '../../../../dialogs/confirm/confirm.component';
import { TranslocoService } from '@jsverse/transloco';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { GalleryService } from '../../../../services/gallery.service';

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
    private gallerySvc: GalleryService
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
          this.convertSvc.convertCfToMid().subscribe((resp: number) => {
            this.assessSvc.loadAssessment(resp);
  
            const dlgOkay = this.dialog.open(OkayComponent, { data: { title: titleComplete, messageText: msg2 } });
            dlgOkay.componentInstance.hasHeader = true;
            dlgOkay.afterClosed().subscribe(() => {
              this.navSvc.buildTree();
              this.navSvc.navDirect('tutorial-conversion');
            });
            // this.navSvc.navDirect('standard-questions');
            
          });
        }
        else {
          this.convertSvc.convertMidToFull().subscribe((resp: number) => {
            this.assessSvc.loadAssessment(resp);
  
            const dlgOkay = this.dialog.open(OkayComponent, { data: { title: titleComplete, messageText: msg2 } });
            dlgOkay.componentInstance.hasHeader = true;
            dlgOkay.afterClosed().subscribe(() => {
              this.navSvc.buildTree();
              this.gallerySvc.getGalleryItems('CF').subscribe(
                (result: any) => {
                  result[0]
              });
              //this.navSvc.beginNewAssessmentGallery();
              this.navSvc.navDirect('tutorial-conversion');
            });
            // this.navSvc.navDirect('standard-questions');
            
          });
        }
      }
      
    });
  }
}
