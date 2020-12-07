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
import { FileUploadClientService } from "./../../services/file-client.service";
import { Component, OnInit } from "@angular/core";
import { MatDialog } from "@angular/material/dialog";
import { Sort } from "@angular/material/sort";
import { Router } from "@angular/router";
import { ChangePasswordComponent } from "../../dialogs/change-password/change-password.component";
import { PasswordStatusResponse } from "../../models/reset-pass.model";
import { AssessmentService } from "../../services/assessment.service";
import { AuthenticationService } from "../../services/authentication.service";
import { ConfigService } from "../../services/config.service";
import { ConfirmComponent } from "../../dialogs/confirm/confirm.component";
import { AlertComponent } from "../../dialogs/alert/alert.component";
import { ImportAssessmentService } from "../../services/import-assessment.service";
import { UploadExportComponent } from "../../dialogs/upload-export/upload-export.component";
import { Title } from "@angular/platform-browser";
import { NavigationService } from "../../services/navigation.service";
import { QuestionFilterService } from '../../services/question-filter.service';

interface UserAssessment {
  AssessmentId: number;
  AssessmentName: string;
  AssessmentCreatedDate: string;
  CreatorName: string;
  LastModifiedDate: string;
  MarkedForReview: boolean;
  AltTextMissing: boolean;
}

@Component({
  selector: "app-landing-page",
  templateUrl: "landing-page.component.html",
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class LandingPageComponent implements OnInit {
  // assessments: UserAssessment[] = null;
  sortedAssessments: UserAssessment[] = null;
  unsupportedImportFile: boolean = false;

  browserIsIE: boolean = false;
  exportExtension: string;
  displayedColumns: string[] = ['assessment', 'lastModified', 'creatorName', 'markedForReview', 'removeAssessment', 'exportAssessment'];

  constructor(
    public configSvc: ConfigService,
    public authSvc: AuthenticationService,
    private router: Router,
    public assessSvc: AssessmentService,
    public dialog: MatDialog,
    public importSvc: ImportAssessmentService,
    public fileSvc: FileUploadClientService,
    public titleSvc: Title,
    public navSvc: NavigationService,
    private filterSvc: QuestionFilterService
  ) { }

  ngOnInit() {
    this.browserIsIE = /msie\s|trident\//i.test(window.navigator.userAgent);
    this.exportExtension = sessionStorage.getItem('exportExtension');
    this.titleSvc.setTitle('CSET');
    if (localStorage.getItem("returnPath")) {      
    }
    else{
      sessionStorage.removeItem('tree');
      this.navSvc.clearTree(this.navSvc.getMagic());
    }
    
    this.checkPasswordReset();
  }

  checkPasswordReset() {
    this.authSvc.checkLocal().then((resp: any) => {
      if (this.authSvc.isLocal) {
        this.getAssessments();
        return;
      }

      this.authSvc.passwordStatus()
        .subscribe((result: PasswordStatusResponse) => {
          if (result) {
            if (!result.ResetRequired) {
              this.openPasswordDialog(true);
            }
          } else {
            this.getAssessments();
          }
        });
    });
  }

  openPasswordDialog(showWarning: boolean) {
    if (localStorage.getItem("returnPath")) {
      if (!Number(localStorage.getItem("redirectid"))) {
        this.hasPath(localStorage.getItem("returnPath"));
      }
    }
    this.dialog
      .open(ChangePasswordComponent, {
        width: "300px",
        data: { PrimaryEmail: this.authSvc.email(), warning: showWarning }
      })
      .afterClosed()
      .subscribe(() => {
        this.checkPasswordReset();
      });
  }

  getAssessments() {
    this.sortedAssessments = null;
    this.filterSvc.refresh();

    const rid = localStorage.getItem("redirectid");
    if (rid != null) {
      localStorage.removeItem("redirectid");
      this.assessSvc.loadAssessment(+rid);
    }
    this.assessSvc.getAssessments().subscribe(
      (data: UserAssessment[]) => {
        this.sortedAssessments = data;
      },
      error =>
        console.log(
          "Unable to get Assessments for " +
          this.authSvc.email() +
          ": " +
          (<Error>error).message
        )
    );
  }

  hasPath(rpath: string) {
    if (rpath != null) {
      localStorage.removeItem("returnPath");
      this.router.navigate([rpath], { queryParamsHandling: "preserve" });
    }
  }

  removeAssessment(assessment: UserAssessment, assessmentIndex: number) {
    // first, call the API to see if this is a legal move
    this.assessSvc
      .isDeletePermitted(assessment.AssessmentId)
      .subscribe(canDelete => {
        if (!canDelete) {
          this.dialog.open(AlertComponent, {
            data: {
              messageText:
                "You cannot remove an assessment that has other users."
            }
          });
          return;
        }

        // if it's legal, see if they really want to
        const dialogRef = this.dialog.open(ConfirmComponent);
        dialogRef.componentInstance.confirmMessage =
          "Are you sure you want to remove " +
          assessment.AssessmentName +
          "?";
        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.assessSvc.removeContact(0, assessment.AssessmentId).subscribe(
              x => {
                this.sortedAssessments.splice(assessmentIndex, 1);
              },
              x => {
                this.dialog.open(AlertComponent, {
                  data: { messageText: x.statusText }
                });
              });
          }
        });
      });
  }

  sortData(sort: Sort) {

    if (!sort.active || sort.direction === "") {
      // this.sortedAssessments = data;
      return;
    }

    this.sortedAssessments.sort((a, b) => {
      const isAsc = sort.direction === "asc";
      switch (sort.active) {
        case "assessment":
          return compare(a.AssessmentName, b.AssessmentName, isAsc);
        case "date":
          return compare(a.LastModifiedDate, b.LastModifiedDate, isAsc);
        case "assessor":
          return compare(a.CreatorName, b.CreatorName, isAsc);
        case "status":
          return compareBool(a.MarkedForReview, b.MarkedForReview, isAsc);
        default:
          return 0;
      }
    });
  }

  logout() {
    this.authSvc.logout();
  }

  clickDownloadLink(ment_id: number) {
    // get short-term JWT from API
    this.authSvc.getShortLivedTokenForAssessment(ment_id).subscribe((response: any) => {
      const url =
        this.fileSvc.exportUrl + "?token=" + response.Token;
      window.open(url, "_blank");
    });
  }

  importAssessmentFile(event) {
    let dialogRef = null;
    this.unsupportedImportFile = false;
    if (event.srcElement.files[0].name.endsWith(".csetw") > 0) {
      // Call Standard import service
      dialogRef = this.dialog.open(UploadExportComponent, {
        data: { files: event.srcElement.files, IsNormalLoad: true }
      });
    } else {
      if (this.authSvc.isLocal) {
        dialogRef = this.dialog.open(UploadExportComponent, {
          data: { files: event.srcElement.files, IsNormalLoad: false }
        });
      } else {
        this.unsupportedImportFile = true;
      }
    }

    if (!this.unsupportedImportFile) {
      dialogRef.afterClosed().subscribe(result => {
        this.getAssessments();
      });
    }
  }
}

function compare(a, b, isAsc) {
  return (a < b ? -1 : 1) * (isAsc ? 1 : -1);
}
function compareBool(a, b, isAsc) {
  return (a === b) ? 0 : a ? -1 * (isAsc ? 1 : -1) : 1 * (isAsc ? 1 : -1);
}
