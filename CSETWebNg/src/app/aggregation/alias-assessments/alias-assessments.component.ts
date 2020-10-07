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
import { Component, OnInit, Inject } from '@angular/core';
import { AggregationService } from '../../services/aggregation.service';
import { ActivatedRoute, Router } from '@angular/router';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
import { SelectAssessmentsComponent } from '../../dialogs/select-assessments/select-assessments.component';
import { NavigationAggregService } from '../../services/navigationAggreg.service';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';

@Component({
  selector: 'app-alias-assessments',
  templateUrl: './alias-assessments.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a trend-table-width' }
})
export class AliasAssessmentsComponent implements OnInit {

  aliasData: any;
  dialogRefSelect: MatDialogRef<SelectAssessmentsComponent>;
  dialogRefConfirm: MatDialogRef<ConfirmComponent>;
  trendNameError: boolean = true;

  constructor(
    public aggregationSvc: AggregationService,
    public route: ActivatedRoute,
    public router: Router,
    public dialog: MatDialog,
    public navAggSvc: NavigationAggregService
  ) {
    this.aggregationSvc.getAggregationToken(+this.route.snapshot.params['id']);
  }

  ngOnInit() {
    if (!this.aggregationSvc.currentAggregation) {
      this.router.navigate(['/compare']);
    }
    this.getRelatedAssessments();
  }

  updateAggregation() {
    this.checkTrendName();
    if(this.trendNameError){
      this.aggregationSvc.updateAggregation().subscribe();
    }
  }

  validateNext(){
    if(this.aliasData != null)
    {
      var checkNext = this.aliasData.Assessments.length < 2 || !this.checkTrendName();
      return checkNext;
    }
    return true;
  }

  /**
   * Gets the assessments for this aggregation.
   */
  getRelatedAssessments() {
    this.aggregationSvc.getAssessments().subscribe(resp => {
      this.aliasData = resp;
    });
  }

  /**
   * Opens dialog for assessment selection.
   */
  openSelectionDialog() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRefSelect = this.dialog.open(SelectAssessmentsComponent, {
      width: '300px',
      data: {}
    });
    this.dialogRefSelect.afterClosed().subscribe(() => {
      this.getRelatedAssessments();
    });
  }

  /**
   * Check trend name empty 
   */
  checkTrendName(){
    this.trendNameError =  this.aggregationSvc.currentAggregation.AggregationName.length > 0;
    return this.trendNameError;
  }

  /**
   * 
   * @param assessment 
   */
  changeAlias(assessment) {

    let assessmentList = [];
    this.aliasData.Assessments.forEach(a => {
      assessmentList.push({
        "AssessmentId": a.AssessmentId,
        "Selected": a.Selected,
        "Alias": a.Alias
      });
    });

    this.aggregationSvc.saveAssessmentAlias(
      {
        "AssessmentId": assessment.AssessmentId,
        "Selected": assessment.Selected,
        "Alias": assessment.Alias
      },
      assessmentList
    ).subscribe();
  }

  /**
   * 
   * @param b
   */
  showDot(b: boolean) {
    return b ? '<i class="fa fa-dot-circle primary-900"></i>' : '';
  }

  /**
   * The user is backing from this page.  If the trend represented
   * on this page is incomplete, get confirmation from the user
   * that it's okay to delete the aggregation. 
   */
  navBackIfValid() {
    if (this.aliasData.Assessments.length < 2) {
      this.showConfirmationDialog();
      return;
    }

    this.navAggSvc.navBack('alias-assessments');
  }

  /**
   * Opens dialog to confirm data loss of data on BACK.
   */
  showConfirmationDialog() {
    if (this.dialog.openDialogs[0]) {
      return;
    }

    const dialogRef = this.dialog.open(ConfirmComponent);

    let aggregType = this.aggregationSvc.modeDisplay(false);
    dialogRef.componentInstance.confirmMessage =
      "The " + aggregType + " has less than 2 assessments.  "
      + "Leaving this page will delete the " + aggregType + ".  "
      + "Are you sure you want to leave the page?";


    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.aggregationSvc.deleteAggregation(this.aggregationSvc.currentAggregation.AggregationId)
          .subscribe(() => {
            this.navAggSvc.navBack('alias-assessments');
          });
      }
    });
  }
}
