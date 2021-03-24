////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { CommonModule } from '@angular/common';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { Hotkey, HotkeysService } from 'angular2-hotkeys';
import { AboutComponent } from '../../dialogs/about/about.component';
import { AdvisoryComponent } from '../../dialogs/advisory/advisory.component';
import { AssessmentDocumentsComponent } from '../../dialogs/assessment-documents/assessment-documents.component';
import { ChangePasswordComponent } from '../../dialogs/change-password/change-password.component';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { EditUserComponent } from '../../dialogs/edit-user/edit-user.component';
import { EnableProtectedComponent } from '../../dialogs/enable-protected/enable-protected.component';
import { GlobalParametersComponent } from '../../dialogs/global-parameters/global-parameters.component';
import { KeyboardShortcutsComponent } from '../../dialogs/keyboard-shortcuts/keyboard-shortcuts.component';
import { TermsOfUseComponent } from '../../dialogs/terms-of-use/terms-of-use.component';
import { CreateUser } from '../../models/user.model';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { NgbAccordion } from '@ng-bootstrap/ng-bootstrap';
import { ExcelExportComponent } from '../../dialogs/excel-export/excel-export.component';
import { AggregationService } from '../../services/aggregation.service';
import { FileUploadClientService } from '../../services/file-client.service';

declare var $: any;

@Component({
  moduleId: module.id,
  selector: 'acet-layout-main',
  templateUrl: './acet-layout-main.component.html',
  styleUrls: ['./acet-layout-main.component.scss'],  
  encapsulation: ViewEncapsulation.None,
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class AcetLayoutMainComponent implements OnInit, AfterViewInit {
  docUrl: string;
  dialogRef: MatDialogRef<any>;
  isFooterVisible: boolean = false;

  @ViewChild('acc') accordion: NgbAccordion;

  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public aggregationSvc: AggregationService,
    public fileSvc: FileUploadClientService,
    public dialog: MatDialog,
    public router: Router,
    private _hotkeysService: HotkeysService
  ) { }


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
      this.router.navigate([rpath], { queryParamsHandling: "preserve" });
    }
  }

  /**
   * Indicates if the user is currently within the Module Builder pages.
   * TODO:  Hard-coded paths could be replaced by asking the BreadcrumbComponent
   * or the SetBuilderService for Module Builder paths.
   */
  isModuleBuilder(rpath: string) {
    if (!rpath) {
      return false;
    }
    if (rpath === '/set-list'
      || rpath.indexOf('/set-detail') > -1
      || rpath.indexOf('/requirement-list') > -1
      || rpath.indexOf('/standard-documents') > -1
      || rpath.indexOf('/ref-document') > -1
      || rpath.indexOf('/requirement-detail') > -1
      || rpath.indexOf('/question-list') > -1
      || rpath.indexOf('/add-question') > -1) {
      return true;
    }
    return false;
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

  isACET() {
    return JSON.parse(localStorage.getItem('isAcetApp'));
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
          if (data && data.PrimaryEmail) {
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
      data: { PrimaryEmail: this.auth.email() }
    });
    this.dialogRef.afterClosed().subscribe();
  }

  isAssessment() {
    return sessionStorage.getItem('assessmentId');
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
    window.location.href = this.configSvc.apiUrl + 'ExcelExport?token=' + sessionStorage.getItem('userToken');
  }

  exportToExcelNCUA() {
    window.location.href = this.configSvc.apiUrl + 'ExcelExportNCUA?token=' + sessionStorage.getItem('userToken');
  }

  exportToExcelAllNCUA() {
    window.location.href = this.configSvc.apiUrl + 'ExcelExportAllNCUA?token=' + sessionStorage.getItem('userToken');
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
      window.open(this.docUrl + "ApplicationDocuments/AccessibilityStatement.pdf", "_blank");
      return false; // Prevent bubbling
    }));
    // User Guide
    this._hotkeysService.add(new Hotkey('alt+g', (event: KeyboardEvent): boolean => {
      window.open(this.docUrl + "htmlhelp_acet/index.htm", "_blank");
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
      dialogRef.componentInstance.confirmMessage =
        "Are you sure you want to create a new assessment? ";
      dialogRef.afterClosed().subscribe(result => {
        if (result) {
          this.assessSvc.newAssessment();
        }
      });
      return false; // Prevent bubbling
    }));
    // User Guide (PDF)
    this._hotkeysService.add(new Hotkey('alt+p', (event: KeyboardEvent): boolean => {
      window.open(this.docUrl + "cdDocs_ACET/UserGuide.pdf", "_blank");
      return false; // Prevent bubbling
    }));

    // Questionnaires
    // this._hotkeysService.add(new Hotkey('alt+q', (event: KeyboardEvent): boolean => {
    //   return false; // Prevent bubbling
    // }));

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
    if (!!this.accordion) {
      return this.accordion.isExpanded('footerPanel');
    }
    return false;
  }
}
