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
import { ChangeDetectionStrategy, Component, Input, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { Hotkey, HotkeysService } from 'angular2-hotkeys';
import { AboutComponent } from '../../dialogs/about/about.component';
import { AdvisoryComponent } from '../../dialogs/advisory/advisory.component';
import { AssessmentDocumentsComponent } from '../../dialogs/assessment-documents/assessment-documents.component';
import { ChangePasswordComponent } from '../../dialogs/change-password/change-password.component';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { EditUserComponent } from '../../dialogs/edit-user/edit-user.component';
import { EnableProtectedComponent } from '../../dialogs/enable-protected/enable-protected.component';
import { ExcelExportComponent } from '../../dialogs/excel-export/excel-export.component';
import { GlobalConfigurationComponent } from '../../dialogs/global-configuration/global-configuration.component';
import { GlobalParametersComponent } from '../../dialogs/global-parameters/global-parameters.component';
import { KeyboardShortcutsComponent } from '../../dialogs/keyboard-shortcuts/keyboard-shortcuts.component';
import { RraMiniUserGuideComponent } from '../../dialogs/rra-mini-user-guide/rra-mini-user-guide.component';
import { TermsOfUseComponent } from '../../dialogs/terms-of-use/terms-of-use.component';
import { AccessibilityStatementComponent } from '../../dialogs/accessibility-statement/accessibility-statement.component';
import { CreateUser } from '../../models/user.model';
import { AggregationService } from '../../services/aggregation.service';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { NavigationService } from '../../services/navigation/navigation.service';
import { FileUploadClientService } from '../../services/file-client.service';
import { GalleryService } from '../../services/gallery.service';
import { SetBuilderService } from './../../services/set-builder.service';
import { AlertComponent } from '../../dialogs/alert/alert.component';
import { UserLanguageComponent } from '../../dialogs/user-language/user-language.component';
import { translate } from '@ngneat/transloco';

@Component({
  selector: 'app-top-menus',
  templateUrl: './top-menus.component.html',
  styleUrls: ['./top-menus.component.scss']
})
export class TopMenusComponent implements OnInit {
  docUrl: string;
  dialogRef: MatDialogRef<any>;
  showFullAccessKey = false;

  @Input()
  skin: string;

  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public aggregationSvc: AggregationService,
    public fileSvc: FileUploadClientService,
    public setBuilderSvc: SetBuilderService,
    public dialog: MatDialog,
    public router: Router,
    private _hotkeysService: HotkeysService,
    private gallerySvc: GalleryService,
    private navSvc: NavigationService
  ) { }

  ngOnInit(): void {
    ChangeDetectionStrategy.OnPush;
    this.docUrl = this.configSvc.docUrl;
    if (localStorage.getItem('returnPath')) {
      if (!Number(localStorage.getItem('redirectid'))) {
        this.hasPath(localStorage.getItem('returnPath'));
      }
    }

    this.setupShortCutKeys();
  }

  hasPath(rpath: string) {
    if (rpath != null) {
      localStorage.removeItem('returnPath');
      this.router.navigate([rpath], { queryParamsHandling: 'preserve' });
    }
  }

  setupShortCutKeys() {
    // About
    this._hotkeysService.add(
      new Hotkey('alt+a', (event: KeyboardEvent): boolean => {
        this.about();
        return false; // Prevent bubbling
      })
    );
    // Accessibility Features
    this._hotkeysService.add(
      new Hotkey('alt+c', (event: KeyboardEvent): boolean => {
        window.open(this.docUrl + 'ApplicationDocuments/AccessibilityStatement.pdf', '_blank');
        return false; // Prevent bubbling
      })
    );
    // User Guide
    this._hotkeysService.add(
      new Hotkey('alt+g', (event: KeyboardEvent): boolean => {
        window.open(this.docUrl + 'htmlhelp/index.htm', '_blank');
        return false; // Prevent bubbling
      })
    );
    // Resource Library
    this._hotkeysService.add(
      new Hotkey('alt+l', (event: KeyboardEvent): boolean => {
        this.router.navigate(['resource-library']);
        return false; // Prevent bubbling
      })
    );
    // Parameter Editor
    this._hotkeysService.add(
      new Hotkey('alt+m', (event: KeyboardEvent): boolean => {
        return false; // Prevent bubbling
      })
    );
    // New Assessment
    this._hotkeysService.add(
      new Hotkey('alt+n', (event: KeyboardEvent): boolean => {
        const dialogRef = this.dialog.open(ConfirmComponent);
        dialogRef.componentInstance.confirmMessage = translate('dialogs.confirm create new assessment');
        dialogRef.afterClosed().subscribe((result) => {
          if (result) {
            this.router.navigate(['/landing-page-tabs'], {
              queryParams: {
                'tab': 'newAssessment'
              },
              queryParamsHandling: 'merge',
            });
          }
        });
        return false; // Prevent bubbling
      })
    );
    // User Guide (PDF)
    this._hotkeysService.add(
      new Hotkey('alt+p', (event: KeyboardEvent): boolean => {
        window.open(this.docUrl + 'cdDocs/UserGuide.pdf', '_blank');
        return false; // Prevent bubbling
      })
    );

    // Questionnaires
    // this._hotkeysService.add(new Hotkey('alt+q', (event: KeyboardEvent): boolean => {
    //   return false; // Prevent bubbling
    // }));

    // Protected Features
    this._hotkeysService.add(
      new Hotkey('alt+r', (event: KeyboardEvent): boolean => {
        this.enableProtectedFeature();
        return false; // Prevent bubbling
      })
    );
    // Assessment Documents
    this._hotkeysService.add(
      new Hotkey('alt+t', (event: KeyboardEvent): boolean => {
        return false; // Prevent bubbling
      })
    );
    // Advisory
    this._hotkeysService.add(
      new Hotkey('alt+v', (event: KeyboardEvent): boolean => {
        this.advisory();
        return false; // Prevent bubbling
      })
    );
    // Keyboard Shortcuts
    this._hotkeysService.add(
      new Hotkey('?', (event: KeyboardEvent): boolean => {
        if (!this.configSvc.isMobile()) {
          this.showKeyboardShortcuts();
        }
        return false; // Prevent bubbling
      })
    );
  }

  /**
   * Indicates if the user is currently within the Module Builder pages.
   */
  isModuleBuilder(rpath: string) {
    if (!rpath) {
      return false;
    }

    rpath = rpath.split('/')[1];
    return this.setBuilderSvc.moduleBuilderPaths.includes(rpath);
  }

  /**
   * Considers whether the app is running as CSET Online
   * or on a mobile device and decides if the item should show.
   */
  showMenuItem(item: string) {
    // This is not applicable to a large enterprise setup.
    // Also, we are hiding the FAA gallery cards for now.
    if (item == 'enable protected features') {
      return this.configSvc.behaviors?.showEnableProtectedFeatures ?? true;
    }

    if (item == 'reconfigure unc path') {
      return this.configSvc.behaviors?.showReconfigureUncPath ?? true;
    }

    if (item == 'parameter editor') {
      let show = this.configSvc.behaviors?.showMenuParameterEditor ?? true;
      show = show && !this.configSvc.isMobile();
      return show;
    }

    // This should not be offered in mobile or CSET Online
    if (item == 'import modules') {
      return !this.configSvc.isMobile() && (this.configSvc.behaviors?.showModuleImport ?? true);
    }

    // This should not be offered in mobile or CSET Online
    if (item == 'module builder') {
      return this.configSvc.behaviors?.showModuleBuilder;
    }

    if (item == 'module content report') {
      return !this.configSvc.isMobile() && (this.configSvc.behaviors?.showModuleContentReport ?? true);
    }

    if (item == 'trend') {
      return !this.configSvc.isMobile() && (this.configSvc.behaviors?.showTrend ?? true);
    }

    if (item == 'compare') {
      return !this.configSvc.isMobile() && (this.configSvc.behaviors?.showCompare ?? true);
    }

    if (item == 'language picker') {
      return this.configSvc.behaviors?.showMenuLanguagePicker ?? false;
    }

    if (item == 'resume') {
      return this.inAssessment() ?? false;
    }


    return true;
  }

  /**
   * Allows us to hide items for certain skins
   */
  showItemForCurrentSkin(item: string) {
    // custom behavior for ACET
    if (this.skin === 'ACET') {
      if (item === 'assessment documents') {
        return false;
      }
    }

    const show = this.configSvc.config.behaviors?.showAssessmentDocuments ?? true;
    return show;
  }

  /**
   *
   */
  showUserMenuItem() {
    if (this.auth.isLocal) {
      return false;
    }

    return this.router.url !== '/resource-library';
  }

  /**
   * Hides User Guide menu items that are not relevant to the current assessment.
   */
  isGuideVisible(module: string) {
    // we hide these on the phone
    if (this.configSvc.isMobile()) {
      return false;
    }

    if (this.assessSvc.assessment?.maturityModel?.modelName == module) {
      return true;
    }

    if (this.configSvc.behaviors.additionalUserGuides?.includes(module)) {
      return true;
    }

    return false;
  }

  showMenuStrip() {
    return (
      this.router.url !== '/resource-library' &&
      this.router.url !== '/importModule' &&
      !this.isModuleBuilder(this.router.url)
    );
  }

  showResourceLibraryLink() {
    return (
      !this.configSvc.isMobile() &&
      this.router.url !== '/resource-library' &&
      this.router.url !== '/importModule' &&
      !this.isModuleBuilder(this.router.url)
    );
  }

  /**
   * Determines if the user menu should display.
   */
  showUserMenu() {
    if (this.configSvc.config.isRunningAnonymous) {
      return false;
    }

    return (
      this.router.url !== '/resource-library' &&
      this.router.url !== '/importModule' &&
      !this.isModuleBuilder(this.router.url)
    );
  }

  /**
   * Determines if the 'anonymous' version of the user menu
   * should display.
   */
  showAnonymousMenu() {
    return this.configSvc.config.isRunningAnonymous;
  }

  /**
   *
   */
  editParameters() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(GlobalParametersComponent);
    this.dialogRef.afterClosed().subscribe();
  }

  enableProtectedFeature() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(EnableProtectedComponent, { disableClose: true });
    this.dialogRef.afterClosed().subscribe((results) => {
      if (results.enableFeatureButtonClicked && this.router.url == '/home/landing-page-tabs') {
        this.gallerySvc.refreshCards();
      }

      // Need to reload application in two cases.
      // Case 1: cisaWorkflow switch is now on but configSvc still has non IOD installationMode set.
      // Case 2: cisaWorkflow switch is now off but configSvc still has IOD installationMode set.
      if ((results.cisaWorkflowEnabled && this.configSvc.installationMode != 'IOD') ||
        (!results.cisaWorkflowEnabled && this.configSvc.installationMode == 'IOD')) {
        this.configSvc.setCisaAssessorWorkflow(results.cisaWorkflowEnabled).subscribe(() => {
          this.goHome();
          window.location.reload();
        });
      }
    });
  }

  setMeritExportPath() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(GlobalConfigurationComponent);
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
    this.dialogRef.afterClosed().subscribe();
  }

  exportToExcel() {
    window.location.href = this.configSvc.apiUrl + 'ExcelExport?token=' + localStorage.getItem('userToken');
  }


  exportToExcelNCUA() {
    window.location.href = this.configSvc.apiUrl + 'ExcelExportISE?token=' + localStorage.getItem('userToken');
  }

  /**
   * Show the RRA tutorial in a dialog.  This is temporary, until
   * a proper User Guide is written for RRA.
   * @returns
   */
  ransomwareReadiness() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(RraMiniUserGuideComponent);
    this.dialogRef.afterClosed().subscribe();
  }

  /**
   *
   * @returns
   */
  about() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(AboutComponent);
    this.dialogRef.afterClosed().subscribe();
  }

  /**
   *
   * @returns
   */
  termsOfUse() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(TermsOfUseComponent);
    this.dialogRef.afterClosed().subscribe();
  }

  advisory() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(AdvisoryComponent);
    this.dialogRef.afterClosed().subscribe();
  }

  accessibilityDocument() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(AccessibilityStatementComponent);
    this.dialogRef.afterClosed().subscribe();
  }

  /**
   *
   */
  editUser() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(EditUserComponent);
    this.dialogRef.afterClosed().subscribe(
      (data: CreateUser) => {
        // the update user request happened when the dialog's form was saved
        this.dialogRef = undefined;
      },
      (error) => console.log(error.message)
    );
  }

  /**
   * Display a dialog to let the user change the display language.
   */
  editLanguage() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    this.dialogRef = this.dialog.open(UserLanguageComponent);
    this.dialogRef.afterClosed().subscribe(
      (data: any) => {
        // the update user request happened when the dialog's form was saved
        this.dialogRef = undefined;
      },
      (error) => console.log(error.message)
    );
  }

  /**
   *
   */
  checkPasswordReset() {
    this.auth.passwordStatus().subscribe((passwordResetRequired: boolean) => {
      if (passwordResetRequired) {
        this.resetPassword(true);
      }
    });
  }

  resetPassword(showWarning: boolean) {
    if (localStorage.getItem('returnPath')) {
      if (!Number(localStorage.getItem('redirectid'))) {
        this.hasPath(localStorage.getItem('returnPath'));
      }
    }
    this.dialog
      .open(ChangePasswordComponent, {
        width: '300px',
        data: { primaryEmail: this.auth.email(), warning: showWarning }
      })
      .afterClosed()
      .subscribe((passwordChangeSuccess) => {
        if (passwordChangeSuccess) {
          this.dialog.open(AlertComponent, {
            data: {
              messageText: 'Your password has been changed successfully.',
              title: 'Password Changed',
              iconClass: 'cset-icons-check-circle'
            }
          });
        } else {
          this.checkPasswordReset();
        }
      });
  }

  /**
   * Returns a string with only the last 4 characters showing of a given access key.
   */
  hideAccessKey(accessKey: string) {
    if (!accessKey) {
      return null;
    }

    const hiddenChars = '●'.repeat(accessKey.substring(0, accessKey.length - 4).length);
    const lastFourChars = accessKey.substring(accessKey.length - 4);

    return hiddenChars + lastFourChars;
  }

  inAssessment() {
    return localStorage.getItem('assessmentId');
  }

  showAssessDocs() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    // , {width: '800px', height: "500px"}
    this.dialogRef = this.dialog.open(AssessmentDocumentsComponent);
    this.dialogRef.afterClosed().subscribe();
  }

  navigateTrend() {
    this.aggregationSvc.mode = 'TREND';
    this.router.navigate(['/trend']);
  }

  navigateCompare() {
    this.aggregationSvc.mode = 'COMPARE';
    this.router.navigate(['/compare']);
  }

  goHome() {
    this.assessSvc.dropAssessment();
    this.router.navigate(['/home'], { queryParams: { tab: 'myAssessments' } });
  }
}
