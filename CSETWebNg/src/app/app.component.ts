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
import { Component, OnInit, ViewChild, AfterViewInit, ViewEncapsulation } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { Hotkey, HotkeysService } from 'angular2-hotkeys';
import { AboutComponent } from './dialogs/about/about.component';
import { AdvisoryComponent } from './dialogs/advisory/advisory.component';
import { AssessmentDocumentsComponent } from './dialogs/assessment-documents/assessment-documents.component';
import { ChangePasswordComponent } from './dialogs/change-password/change-password.component';
import { ConfirmComponent } from './dialogs/confirm/confirm.component';
import { EditUserComponent } from './dialogs/edit-user/edit-user.component';
import { EnableProtectedComponent } from './dialogs/enable-protected/enable-protected.component';
import { GlobalParametersComponent } from './dialogs/global-parameters/global-parameters.component';
import { KeyboardShortcutsComponent } from './dialogs/keyboard-shortcuts/keyboard-shortcuts.component';
import { TermsOfUseComponent } from './dialogs/terms-of-use/terms-of-use.component';
import { CreateUser } from './models/user.model';
import { AssessmentService } from './services/assessment.service';
import { AuthenticationService } from './services/authentication.service';
import { ConfigService } from './services/config.service';
import { NgbAccordion } from '@ng-bootstrap/ng-bootstrap';
import { ExcelExportComponent } from './dialogs/excel-export/excel-export.component';
import { AggregationService } from './services/aggregation.service';
import { LocalStoreManager } from './services/storage.service';
import { NavigationService } from './services/navigation/navigation.service';
import { FooterService } from './services/footer.service';
import { translate } from '@ngneat/transloco';


declare var $: any;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  encapsulation: ViewEncapsulation.None,
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class AppComponent implements OnInit, AfterViewInit {
  docUrl: string;
  dialogRef: MatDialogRef<any>;
  isFooterVisible: boolean = false;

  @ViewChild('acc') accordion: NgbAccordion;

  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    private navSvc: NavigationService,
    public configSvc: ConfigService,
    public aggregationSvc: AggregationService,
    public dialog: MatDialog,
    public router: Router,
    private _hotkeysService: HotkeysService,
    private footerSvc: FooterService,
    storageManager: LocalStoreManager
  ) {
    storageManager.initialiseStorageSyncListener();
  }


  ngOnInit() {
    this.docUrl = this.configSvc.docUrl;

    if (localStorage.getItem("returnPath")) {
      if (!Number(localStorage.getItem("redirectid"))) {
        this.hasPath(localStorage.getItem("returnPath"));
      }
    }
    this.setupShortCutKeys();
  }

  ngAfterViewInit() {

    setTimeout(() => {
      this.isFooterOpen();
    }, 200);
  }

  hasPath(rpath: string) {
    if (rpath != null) {
      localStorage.removeItem("returnPath");
      const qParams = this.processParams(rpath);
      rpath = rpath.split('?')[0];
      this.router.navigate([rpath], { queryParams: qParams, queryParamsHandling: 'merge' });
    }
  }

  processParams(url: string) {
    if (!url.includes('?'))
      return null

    let queryParams = url.split('?')[1];
    let params = queryParams.split('&');
    let queryParamsObj = {};
    params.forEach((d) => {
      let pair = d.split('=');
      queryParamsObj[`${pair[0]}`] = pair[1];
    });
    return queryParamsObj;
  }

  goHome() {
    this.assessSvc.dropAssessment();
    this.router.navigate(['/home']);
  }

  about() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(AboutComponent);
    this.dialogRef
      .afterClosed()
      .subscribe();
  }

  termsOfUse() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(TermsOfUseComponent);
    this.dialogRef
      .afterClosed()
      .subscribe();
  }

  advisory() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(AdvisoryComponent);
    this.dialogRef
      .afterClosed()
      .subscribe();
  }

  editUser() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(EditUserComponent);
    this.dialogRef
      .afterClosed()
      .subscribe(
        (data: CreateUser) => {
          if (data && data.primaryEmail) {
            // don't send anything unless there's something sane to send
            this.auth.updateUser(data).subscribe(() => this.auth.setUserInfo(data));
          }
          this.dialogRef = undefined;
        },
        error => console.log(error.message)
      );
  }

  resetPassword() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(ChangePasswordComponent, {
      width: '300px',
      data: { primaryEmail: this.auth.email() }
    });
    this.dialogRef.afterClosed().subscribe();
  }

  isAssessment() {
    return localStorage.getItem('assessmentId');
  }

  showAssessDocs() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    // , {width: '800px', height: "500px"}
    this.dialogRef = this.dialog.open(AssessmentDocumentsComponent);
    this.dialogRef
      .afterClosed()
      .subscribe();
  }

  editParameters() {
    if (this.dialog.openDialogs[0]) {

      return;
    }
    this.dialogRef = this.dialog.open(GlobalParametersComponent);
    this.dialogRef
      .afterClosed()
      .subscribe();
  }

  enableProtectedFeature() {
    if (this.dialog.openDialogs[0]) {

      return;
    }
    this.dialogRef = this.dialog.open(EnableProtectedComponent);
  }

  showKeyboardShortcuts() {
    if (this.dialog.openDialogs[0]) {

      return;
    }
    this.dialogRef = this.dialog.open(KeyboardShortcutsComponent);
  }

  showExcelExportDialog() {
    const doNotShowLocal = localStorage.getItem('doNotShowExcelExport');
    const doNotShow = doNotShowLocal && doNotShowLocal == 'true' ? true : false;
    if (this.dialog.openDialogs[0] || doNotShow) {
      this.exportToExcel();
      return;
    }
    this.dialogRef = this.dialog.open(ExcelExportComponent);
    this.dialogRef
      .afterClosed()
      .subscribe();
  }

  exportToExcel() {
    window.location.href = this.configSvc.apiUrl + 'ExcelExport?token=' + localStorage.getItem('userToken');
  }


  navigateTrend() {
    this.aggregationSvc.mode = 'TREND';
    this.router.navigate(['/trend']);
  }

  navigateCompare() {
    this.aggregationSvc.mode = 'COMPARE';
    this.router.navigate(['/compare']);
  }

  // -----------------------------

  setupShortCutKeys() {
    // About
    this._hotkeysService.add(new Hotkey('alt+a', (event: KeyboardEvent): boolean => {
      this.about();
      return false; // Prevent bubbling
    }));
    // Accessibility Features
    this._hotkeysService.add(new Hotkey('alt+c', (event: KeyboardEvent): boolean => {
      switch (this.configSvc.installationMode || '') {
        case "ACET":
          window.open(this.docUrl + "AccessibilityFeatures/index_acet.htm", "_blank");
          break;
        default:
          window.open(this.docUrl + "ApplicationDocuments/AccessibilityStatement.pdf", "_blank");
      }
      return false; // Prevent bubbling
    }));
    // User Guide
    this._hotkeysService.add(new Hotkey('alt+g', (event: KeyboardEvent): boolean => {
      switch (this.configSvc.installationMode || '') {
        case "ACET":
          window.open(this.docUrl + "htmlhelp_acet/index.htm", "_blank");
          break;
        default:
          window.open(this.docUrl + "htmlhelp/index.htm", "_blank");
      }
      return false; // Prevent bubbling
    }));
    // Resource Library
    this._hotkeysService.add(new Hotkey('alt+l', (event: KeyboardEvent): boolean => {
      this.router.navigate(['resource-library']);
      return false; // Prevent bubbling
    }));
    // Parameter Editor
    this._hotkeysService.add(new Hotkey('alt+m', (event: KeyboardEvent): boolean => {
      return false; // Prevent bubbling
    }));
    // New Assessment
    this._hotkeysService.add(new Hotkey('alt+n', (event: KeyboardEvent): boolean => {
      const dialogRef = this.dialog.open(ConfirmComponent);
      dialogRef.componentInstance.confirmMessage = translate('dialogs.confirm create new assessment');

      dialogRef.afterClosed().subscribe(result => {
        if (result) {
          //this.assessSvc.newAssessment();
          //this.navSvc.beginNewAssessment();
          this.router.navigate(['/landing-page-tabs'], {
            queryParams: {
              'tab': 'newAssessment'
            },
            queryParamsHandling: 'merge',
          });
        }
      });
      return false; // Prevent bubbling
    }));
    // User Guide (PDF)
    this._hotkeysService.add(new Hotkey('alt+p', (event: KeyboardEvent): boolean => {
      window.open(this.docUrl + "cdDocs/UserGuide.pdf", "_blank");
      return false; // Prevent bubbling
    }));

    // Protected Features
    this._hotkeysService.add(new Hotkey('alt+r', (event: KeyboardEvent): boolean => {
      this.enableProtectedFeature();
      return false; // Prevent bubbling
    }));
    // Assessment Documents
    this._hotkeysService.add(new Hotkey('alt+t', (event: KeyboardEvent): boolean => {
      return false; // Prevent bubbling
    }));
    // Advisory
    this._hotkeysService.add(new Hotkey('alt+v', (event: KeyboardEvent): boolean => {
      this.advisory();
      return false; // Prevent bubbling
    }));
    // Keyboard Shortcuts
    this._hotkeysService.add(new Hotkey('?', (event: KeyboardEvent): boolean => {
      this.showKeyboardShortcuts();
      return false; // Prevent bubbling
    }));

  }

  showNavBarRight() {
    if (this.auth.isLocal) {
      return false;
    }

    return this.router.url !== '/resource-library';
  }

  isFooterOpen() {
    this.footerSvc.isFooterOpen(this.accordion);
  }
}
