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
import { MatDialogRef, MAT_DIALOG_DATA, MatDialog } from '@angular/material';
import { SelectAssessmentsComponent } from '../../dialogs/select-assessments/select-assessments.component';
import { NavigationAggregService } from '../../services/navigationAggreg.service';

@Component({
  selector: 'app-alias-assessments',
  templateUrl: './alias-assessments.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class AliasAssessmentsComponent implements OnInit {

  aliasData: any;
  dialogRef: MatDialogRef<SelectAssessmentsComponent>;

  constructor(
    public aggregationSvc: AggregationService,
    public route: ActivatedRoute,
    public router: Router,
    public dialog: MatDialog,
    public navSvc: NavigationAggregService
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
    this.aggregationSvc.updateAggregation().subscribe();
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
  openDialog() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(SelectAssessmentsComponent, {
      width: '300px',
      data: {}
    });
    this.dialogRef.afterClosed().subscribe(() => {
      this.getRelatedAssessments();
    });
  }

  /**
   * 
   * @param assessment 
   */
  changeAlias(assessment) {
    this.aggregationSvc.saveAssessmentAlias(assessment).subscribe();
  }

  /**
   * 
   * @param b
   */
  showDot(b: boolean) {
    return b ? '<i class="fa fa-dot-circle primary-900"></i>' : '';
  }
}
