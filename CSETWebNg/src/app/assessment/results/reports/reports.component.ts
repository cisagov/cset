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
import { CieDocumentsComponent } from '../../../dialogs/cie-documents/cie-documents.component';

@Component({
  selector: 'app-reports',
  templateUrl: './reports.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }, 
  styleUrls: ['./reports.component.scss']

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

  confidentiality: string = 'None';
  isMobile = false;

  lastModifiedTimestamp: string = '';

  exportExtension: string;

  dialogRef: MatDialogRef<any>;
  isCyberFlorida: boolean = false;

  observations: any = null;
  numberOfContacts: number = 1;
  isConfigChainEqual: boolean = false;

  iseHasBeenSubmitted: boolean = false;

  cisaAssessorWorkflowFieldValidation: CisaWorkflowFieldValidationResponse;
  isCfEntry: boolean = false;

  currentSectionId: string | null = null;


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

    this.assessSvc.getLastModified().subscribe((data: any) => {
      this.lastModifiedTimestamp = data.lastModifiedDate;
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

    this.updateSectionId();
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
   * Opens a new browser window/tab for the specified report.
   * 
   * This will become deprecated once all report links are moved off of this page
   * and into their own sub-components.
   */
  clickReportLink(reportType: string) {
    const url = '/index.html?returnPath=report/' + reportType;
    localStorage.setItem('REPORT-' + reportType.toUpperCase(), print.toString());
    window.open(url, '_blank');
  }

  /**
   *
   */
  clickReportService(report: string) {
    this.reportSvc.getPdf(report, this.confidentiality).subscribe((data) => {
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

  onSelectSecurity(val) {
    this.confidentiality = val;
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

    if (this.reportSvc.disableIseReportLinks) {
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
      if (!this.reportSvc.disableIseReportLinks && !this.ncuaSvc.iseHasBeenSubmitted) {
        return "background-color: orange; color: white;";
      } else {
        // If not disabled & already submitted, default here
        return "background-color: #3B68AA; color: white;";
      }
    }
  }

  showAssessDocs() {
    if (this.dialog.openDialogs[0]) {
      return;
    }
    // , {width: '800px', height: "500px"}
    this.dialogRef = this.dialog.open(CieDocumentsComponent);
    this.dialogRef.afterClosed().subscribe();
  }

  updateSectionId(): void {
    if (!!this.assessSvc.assessment) {
      // Network diagram and standard assessments use the same assessment list. sectionId will be passed as DIAGRAM
      if (this.assessSvc.assessment.useStandard && !this.isMobile) {
          this.currentSectionId = 'STANDARD';
      } else if (this.assessSvc.assessment.useDiagram && !this.isMobile) {
          this.currentSectionId = 'DIAGRAM';
      } else if (this.assessSvc.usesMaturityModel('CMMC') ) {
        this.currentSectionId = 'CMMC';
      } else if (this.assessSvc.usesMaturityModel('EDM')) {
        this.currentSectionId = 'EDM';
      } else if (this.assessSvc.usesMaturityModel('CRR')) {
        this.currentSectionId = 'CRR';
      } else if (this.assessSvc.usesMaturityModel('IMR')) {
        this.currentSectionId = 'IMR';
      } else if (this.assessSvc.usesMaturityModel('CIS')) {
        this.currentSectionId = 'CIS';
      } else if (this.assessSvc.usesMaturityModel('CMMC2')) {
        this.currentSectionId = 'CMMC2';
      } else if (this.assessSvc.usesMaturityModel('RRA') && !this.isMobile) {
          this.currentSectionId = 'RRA';
      } else if (this.assessSvc.usesMaturityModel('ACET') && !this.isMobile) {
          this.currentSectionId = 'ACET';
      } else if (this.assessSvc.usesMaturityModel('MVRA') && !this.isMobile) {
          this.currentSectionId = 'MVRA';
      } else if (this.assessSvc.usesMaturityModel('CPG') && !this.isMobile) {
          this.currentSectionId = 'CPG';
      } else if (this.assessSvc.usesMaturityModel('VADR') && !this.isMobile) {
        this.currentSectionId = 'VADR';
      } else if (this.assessSvc.usesMaturityModel('C2M2') && !this.isMobile) {
        this.currentSectionId = 'C2M2';
      } else if (this.assessSvc.usesMaturityModel('SD02 Series') && !this.  isMobile) {
        this.currentSectionId = 'SD02 Series';
      } else if (this.assessSvc.usesMaturityModel('SD02 Owner') && !this.isMobile) {
        this.currentSectionId = 'SD02 Owner';
      } else if (this.assessSvc.usesMaturityModel('HYDRO') && !this.isMobile) {
        this.currentSectionId = 'HYDRO';
      } else {
        this.currentSectionId = null; // No valid section ID
      }
    } else {
      this.currentSectionId = null; // No assessment
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
    this.printInstructions = "reports.printing instructions";
  }
}
