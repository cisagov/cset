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
import { Component, OnInit } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { SetDetail } from '../../models/set-builder.model';
import { Router } from '@angular/router';
import { AlertComponent } from "../../dialogs/alert/alert.component";
import { MatDialog } from '@angular/material/dialog';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { AuthenticationService } from '../../services/authentication.service';

@Component({
  selector: 'app-custom-set-list',
  templateUrl: './custom-set-list.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class SetListComponent implements OnInit {

  setDetailList: SetDetail[];

  constructor(
    public setBuilderSvc: SetBuilderService,
    public authSvc: AuthenticationService,
    private router: Router,
    private dialog: MatDialog) {
  }

  ngOnInit() {
    this.authSvc.checkLocal().then();
    this.getStandards();
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

  cloneSet(setName: string) {
    this.setBuilderSvc.cloneCustomSet(setName).subscribe((response: SetDetail) => {
      sessionStorage.setItem('setName', response.SetName);
      this.router.navigate(['/set-detail', response.SetName]);
    });
  }

  /**
   * Deletes the set after confirmation.
   */
  deleteSet(s: SetDetail) {

    // See if any questions originated from this set
    // It's 8:00 at night just before we are to release tomorrow and this api call does not 
    // exist.  I'm just going to comment it out and hope the repercussions are minimal.


    // this.setBuilderSvc.getQuestionsOriginatingFromSet(s.SetName).subscribe((resp: number[]) => {

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
        "Are you sure you want to delete '" + s.FullName + "?'";

      dialogRef.afterClosed().subscribe(result => {
        if (result) {
          this.dropSet(s.SetName);
        }
      });

    //});
  }

  dropSet(setName: string) {
    this.setBuilderSvc.deleteSet(setName).subscribe(
      (response: any) => {
        // display any messages
        if (response.ErrorMessages.length > 0) {
          let msg: string = "";
          response.ErrorMessages.forEach(element => {
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
