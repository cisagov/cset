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
import { Component, OnInit, AfterViewInit, ChangeDetectorRef, Inject } from '@angular/core';
import { ActivatedRoute, Router } from '../../../../../node_modules/@angular/router';
import { ACETService } from '../../../services/acet.service';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { saveAs } from 'file-saver';
import { ReportService } from '../../../services/report.service';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { ExcelExportComponent } from '../../../dialogs/excel-export/excel-export.component';
import { DemographicExtendedService } from '../../../services/demographic-extended.service';
import { MatSnackBar, MatSnackBarRef, MAT_SNACK_BAR_DATA } from '@angular/material/snack-bar';
import { FileUploadClientService } from '../../../services/file-client.service';
import { AuthenticationService } from '../../../services/authentication.service';
import { NCUAService } from '../../../services/ncua.service';
import { ObservationsService } from '../../../services/observations.service';
import { CisaWorkflowFieldValidationResponse } from '../../../models/demographics-iod.model';
import { TranslocoService } from '@ngneat/transloco';
import { ConversionService } from '../../../services/conversion.service';

@Component({
  selector: 'app-reports',
  templateUrl: './reports.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ReportsComponent implements OnInit, AfterViewInit {
  /**
   * Indicates if all ACET questions have been answered.  This is only
   * used when the ACET model is in use and this is an ACET installation.
   */
  unassignedIssueTitles: any = [];

  disableAcetReportLinks: boolean = true;
  disableIseReportLinks: boolean = true;
  disableEntirePage: boolean = false;

  securityIdentifier: any = [];
  securitySelected: string = 'None';
  isMobile = false;

  lastModifiedTimestamp = '';

  exportExtension: string;

  dialogRef: MatDialogRef<any>;
  isCyberFlorida: boolean = false;

  observations: any = null;
  numberOfContacts: number = 1;
  isConfigChainEqual: boolean = false;

  iseHasBeenSubmitted: boolean = false;

  cisaAssessorWorkflowFieldValidation: CisaWorkflowFieldValidationResponse;
  isCfEntry: boolean = false;

  /**
   *
   */
  constructor(
    private _snackBar: MatSnackBar,
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private acetSvc: ACETService,
    private ncuaSvc: NCUAService,
    public observationsSvc: ObservationsService,
    public fileSvc: FileUploadClientService,
    public authSvc: AuthenticationService,
    private router: Router,
    private route: ActivatedRoute,
    public configSvc: ConfigService,
    public demoSvc: DemographicExtendedService,
    private cdr: ChangeDetectorRef,
    private reportSvc: ReportService,
    private convertSvc: ConversionService,
    public dialog: MatDialog
  ) {
    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe((data: any) => {
        this.assessSvc.assessment = data;
      });
    }
    if (this.configSvc.mobileEnvironment) {
      this.isMobile = true;
    } else {
      this.isMobile = false;
    }
    this.assessSvc.currentTab = 'results';
    this.isConfigChainEqual = this.arraysEqual(this.configSvc.config.currentConfigChain, ['TSA', 'TSAonline']);
  }

  arraysEqual(a, b) {
    if (a === b) { return true; }
    if (a == null || b == null) { return false; }
    if (a.length !== b.length) { return false; }

    // If you don't care about the order of the elements inside
    // the array, you should sort both arrays here.

    for (let i = 0; i < a.length; ++i) {
      if (a[i] !== b[i]) { return false; }
    }
    return true;
  }

  openSnackBar() {
    this._snackBar.openFromComponent(PrintSnackComponent, {
      verticalPosition: 'top',
      horizontalPosition: 'center'
    });
  }

  /**
   *
   */
  ngOnInit() {
    this.exportExtension = localStorage.getItem('exportExtension');

    this.navSvc.navItemSelected.asObservable().subscribe((value: string) => {
      this.router.navigate([value], { relativeTo: this.route.parent });
    });

    // call the API for a ruling on whether all questions have been answered
    this.disableAcetReportLinks = false;
    this.disableIseReportLinks = false;
    if (this.configSvc.installationMode === 'ACET') {
      if (this.assessSvc.isISE()) {
        this.checkIseDisabledStatus();

        this.getAssessmentObservations();
      } else {
        this.checkAcetDisabledStatus();
      }
    }

    if (this.configSvc.installationMode === 'IOD') {
      this.reportSvc.validateCisaAssessorFields().subscribe((result: CisaWorkflowFieldValidationResponse) => {
        this.cisaAssessorWorkflowFieldValidation = result;
        if (!this.cisaAssessorWorkflowFieldValidation?.isValid) {
          this.disableEntirePage = true;
        }
      });
    }

    // disable everything if this is a Cyber Florida and demographics aren't complete
    if (this.configSvc.installationMode === 'CF') {
      this.isCyberFlorida = true;
      this.demoSvc.getDemoAnswered().subscribe((answered: boolean) => {
        this.disableEntirePage = false;
      });
    } else {
      this.isCyberFlorida = false;
    }

    this.reportSvc.getSecurityIdentifiers().subscribe((data) => {
      this.securityIdentifier = data;
    });

    this.assessSvc.getLastModified().subscribe((data: string) => {
      this.lastModifiedTimestamp = data;
    });

    // If this is an ISE, check if the assessment has been submitted or not
    if (this.assessSvc.isISE()) {
      this.ncuaSvc.getSubmissionStatus().subscribe((result: any) => {
        this.iseHasBeenSubmitted = result;
      });
    }

    // Moved this from the assessment-convert-cf component
    // determine if this assessment is a Cyber Florida "entry" assessment.
    if (this.assessSvc.assessment?.origin == 'CF') {
      this.convertSvc.isEntryCfAssessment().subscribe((resp: boolean) => {
        this.isCfEntry = resp;
      });
    }

    this.configSvc.getCisaAssessorWorkflow().subscribe((resp: boolean) => this.configSvc.cisaAssessorWorkflow = resp);
  }

  /**
   *
   */
  ngAfterViewInit() {
    this.cdr.detectChanges();
  }

  /**
   * Decides whether the Observation Tear-Out Sheets
   * link should be shown.
   */
  showObservationTearouts() {
    if (this.assessSvc.isISE()) {
      return false;
    }

    if (this.isMobile) {
      return false;
    }

    return this.configSvc.behaviors.showObservations;
  }

  /**
   *
   */
  clickReportLink(reportType: string, print: boolean = false) {
    const url = '/index.html?returnPath=report/' + reportType;
    localStorage.setItem('REPORT-' + reportType.toUpperCase(), print.toString());
    localStorage.setItem('report-confidentiality', this.securitySelected);
    window.open(url, '_blank');
  }

  /**
   *
   */
  clickReportService(report: string) {
    this.reportSvc.getPdf(report, this.securitySelected).subscribe((data) => {
      saveAs(data, 'test.pdf');
    });
  }

  /**
   * If all ACET statements are not answered, set the 'disable' flag
   * to true.
   */
  checkAcetDisabledStatus() {
    this.disableAcetReportLinks = true;
    if (!this.assessSvc.usesMaturityModel('ACET')) {
      return;
    }

    this.acetSvc.getAnswerCompletionRate().subscribe((percentAnswered: number) => {
      if (percentAnswered == 100) {
        this.disableAcetReportLinks = false;
      }
    });
  }

  /**
   * If all ACET ISE statements are not answered, set the 'disable' flag
   * to true.
   */
  checkIseDisabledStatus() {
    this.disableIseReportLinks = true;
    if (!this.assessSvc.isISE()) {
      return;
    }
    this.acetSvc.getIseAnswerCompletionRate().subscribe((percentAnswered: number) => {
      if (percentAnswered == 100) {
        this.disableIseReportLinks = false;
      }
    });
  }

  /**
   * Gets all ISE Observations/Issues,
   * then stores them in an array if the exam levels match (SCUEP alone, CORE/CORE+ together)
   */
  getAssessmentObservations() {
    this.ncuaSvc.unassignedIssueTitles = [];
    this.observationsSvc.getAssessmentObservations().subscribe(
      (r: any) => {
        this.observations = r;
        let title = '';

        for (let i = 0; i < this.observations?.length; i++) {
          // substringed this way to cut off the '+' from 'CORE+' so it's still included with a CORE assessment
          if (
            this.ncuaSvc.translateExamLevel(this.observations[i]?.question?.maturity_Level_Id).substring(0, 4) ==
            this.ncuaSvc.getExamLevel().substring(0, 4)
          ) {
            if (this.observations[i]?.finding?.type == null || this.observations[i]?.finding?.type == '') {
              title = this.observations[i]?.category?.title + ', ' + this.observations[i]?.question?.question_Title;
              this.ncuaSvc.unassignedIssueTitles.push(title);
            }
          }
        }
        if (this.ncuaSvc.unassignedIssueTitles?.length == 0) {
          this.ncuaSvc.unassignedIssues = false;
        } else {
          this.ncuaSvc.unassignedIssues = true;
        }
      },
      (error) => console.log('Observations Error: ' + (<Error>error).message)
    );
  }

  onSelectSecurity(val) {
    this.securitySelected = val;
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

  /**
   *
   */
  clickExport(jsonOnly: boolean = false) {
    // get short-term JWT from API
    this.authSvc.getShortLivedTokenForAssessment(this.assessSvc.assessment.id).subscribe((response: any) => {
      let url = this.fileSvc.exportUrl + '?token=' + response.token;

      if (jsonOnly) {
        url = this.fileSvc.exportJsonUrl + "?token=" + response.token;
      }

      window.location.href = url;
    });
  }

  disableSubmitButton() {
    if (this.ncuaSvc.ISE_StateLed) {
      return false;
    }
    if (this.ncuaSvc.creditUnionName == null || this.ncuaSvc.creditUnionName == '') {
      return true;
    }

    if (this.ncuaSvc.assetsAsNumber == null || this.ncuaSvc.assetsAsNumber == 0) {
      return true;
    }

    if (this.ncuaSvc.unassignedIssues) {
      return true;
    }

    if (this.ncuaSvc.submitInProgress) {
      return true;
    }

    if (this.disableIseReportLinks) {
      return true;
    }
    return false;
  }

  getSubmitButtonStyle() {
    // If Disabled
    if (this.disableSubmitButton()) {
      return "background-color: gray; color: white;";
    } else {
      // If not disabled and also not submitted yet
      if (!this.iseHasBeenSubmitted && !this.ncuaSvc.iseHasBeenSubmitted) {
        return "background-color: orange; color: white;";
      } else {
        // If not disabled & already submitted, default here
        return "background-color: #3B68AA; color: white;";
      }
    }
  }

}

@Component({
  selector: 'snack-bar-component-example-snack',
  template:
    '<span>{{ tSvc.translate(printInstructions) }}</span><button (click)="snackBarRef.dismiss()">{{ tSvc.translate(\'buttons.close\') }}</button>',
  styles: ['']
})
export class PrintSnackComponent implements OnInit {
  constructor(public snackBarRef: MatSnackBarRef<PrintSnackComponent>,
    @Inject(MAT_SNACK_BAR_DATA) public data: any,
    public tSvc: TranslocoService
  ) { }

  printInstructions: string;

  ngOnInit() {
    const isRunningInElectron = localStorage.getItem('isRunningInElectron') === 'true';
    if (isRunningInElectron) {
      this.printInstructions =
        'reports.printing instructions electron';
    } else {
      this.printInstructions =
        'reports.printing instructions non-electron';
    }
  }
}
