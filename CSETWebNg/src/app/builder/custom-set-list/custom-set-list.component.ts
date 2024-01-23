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
import { SetBuilderService } from '../../services/set-builder.service';
import { SetDetail } from '../../models/set-builder.model';
import { Router } from '@angular/router';
import { AlertComponent } from "../../dialogs/alert/alert.component";
import { MatDialog } from '@angular/material/dialog';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-custom-set-list',
  templateUrl: './custom-set-list.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class SetListComponent implements OnInit {

  setDetailList: SetDetail[];
  setsInUseList: SetDetail[];

  canDeleteCustomModules = false;

  constructor(
    public setBuilderSvc: SetBuilderService,
    public authSvc: AuthenticationService,
    public configSvc: ConfigService,
    private router: Router,
    private dialog: MatDialog) {
  }

  ngOnInit() {
    this.getStandards();
    this.getStandardsInUse();

    this.canDeleteCustomModules = this.configSvc.config.debug.canDeleteCustomModules ?? false;
  }

  getStandards() {
    this.setBuilderSvc.getCustomSetList().subscribe(
      (response: SetDetail[]) => {
        this.setDetailList = response;
      },
      error =>
        console.log(
          "Unable to get Custom Standards: " +
          (<Error>error).message
        )
    );
  }

  getStandardsInUse() {
    this.setBuilderSvc.getSetsInUseList().subscribe(
      (response: SetDetail[]) => {
        this.setsInUseList = response;
      },
      error =>
        console.log(
          "Unable to get standards in use: " +
          (<Error>error).message
        )
    );
  }

  cloneSet(setName: string) {
    this.setBuilderSvc.cloneCustomSet(setName).subscribe((response: SetDetail) => {
      localStorage.setItem('setName', response.setName);
      this.router.navigate(['/set-detail', response.setName]);
    });
  }

  /**
   * Deletes the set after confirmation.
   */
  deleteSet(s: SetDetail) {

    // See if any questions originated from this set
    // It's 8:00 at night just before we are to release tomorrow and this api call does not
    // exist.  I'm just going to comment it out and hope the repercussions are minimal.


    // this.setBuilderSvc.getQuestionsOriginatingFromSet(s.setName).subscribe((resp: number[]) => {

    //   // Prevent the deletion if the set spawned questions.
    //   if (resp.length > 0) {
    //     let msg = null;

    //     if (resp.length === 1) {
    //       msg = 'There is 1 question that were created for this set.  You cannot delete the set.';
    //     } else {
    //       msg = 'There are ' + resp.length + ' questions that were created for this set.  You cannot delete the set.';
    //     }

    //     this.dialog.open(AlertComponent, {
    //       data: {
    //         messageText: msg
    //       }
    //     });
    //     return;
    //   }


    // confirm deletion
    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage =
      "Are you sure you want to delete '" + s.fullName + "?'";

    if (this.setsInUseList.find(x => x.setName === s.setName)) {
      dialogRef.componentInstance.confirmMessage +=
        "<div class=\"d-flex justify-content-center mt-2\"><span class=\"mr-3 fs-base-6 cset-icons-exclamation-triangle\" style=\"color: #856404\"></span>This module is currently in use in one or more assessments.<br/> All assessment data pertaining to the module will be lost.</div>";
    }

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.dropSet(s.setName);
      }
    });

    //});
  }

  dropSet(setName: string) {
    this.setBuilderSvc.deleteSet(setName).subscribe(
      (response: any) => {
        // display any messages
        if (response.errorMessages.length > 0) {
          let msg: string = "";
          response.errorMessages.forEach(element => {
            msg += element + "<br>";
          });

          this.dialog.open(AlertComponent, {
            data: {
              messageText: msg
            }
          });
        }

        // refresh page
        this.getStandards();
      },
      error => {
        this.dialog
          .open(AlertComponent, { data: "Error deleting set" })
          .afterClosed()
          .subscribe();
        console.log(
          "Error deleting set: " + setName
        );
      }
    );
  }
}
