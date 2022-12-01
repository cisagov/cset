////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { FindingsService } from '../../../services/findings.service';

@Component({
    selector: 'app-reports',
    templateUrl: './reports.component.html',
    // tslint:disable-next-line:use-host-property-decorator
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
    securitySelected: string = "None";
    isMobile = false;

    lastModifiedTimestamp = '';

    exportExtension: string;

    dialogRef: MatDialogRef<any>;
    isCyberFlorida: boolean = false;

    findings: any = null;

    /**
     *
     */
    constructor(
        private _snackBar: MatSnackBar,
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        private acetSvc: ACETService,
        private ncuaSvc: NCUAService,
        public findSvc: FindingsService,
        public fileSvc: FileUploadClientService,
        public authSvc: AuthenticationService,
        private router: Router,
        private route: ActivatedRoute,
        public configSvc: ConfigService,
        public demoSvc: DemographicExtendedService,
        private cdr: ChangeDetectorRef,
        private reportSvc: ReportService,
        public dialog: MatDialog
    ) {
        if (this.assessSvc.assessment == null) {
            this.assessSvc.getAssessmentDetail().subscribe(
                (data: any) => {
                    this.assessSvc.assessment = data;
                });
        }
        if (this.configSvc.mobileEnvironment) {
            this.isMobile = true;
        } else {
            this.isMobile = false;
        }
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

        this.assessSvc.currentTab = 'results';
        this.navSvc.navItemSelected.asObservable().subscribe((value: string) => {
            this.router.navigate([value], { relativeTo: this.route.parent });
        });

        // call the API for a ruling on whether all questions have been answered
        this.disableAcetReportLinks = false;
        this.disableIseReportLinks = false;
        if (this.configSvc.installationMode === 'ACET') {
            if (this.assessSvc.isISE()) {
                this.checkIseDisabledStatus();

                this.getAssessmentFindings();
            }
            else {
                this.checkAcetDisabledStatus();
            }
        }

        // disable everything if this is a Cyber Florida and demographics aren't complete
        if (this.configSvc.installationMode === 'CF') {
            this.isCyberFlorida = true;
            this.demoSvc.getDemoAnswered().subscribe((answered: boolean) => {
                this.disableEntirePage = !answered;
            });
        }
        else {
            this.isCyberFlorida = false;
        }

        this.reportSvc.getSecurityIdentifiers().subscribe(data => {
            this.securityIdentifier = data;
        })

        this.assessSvc.getLastModified().subscribe((data: string) => {
            this.lastModifiedTimestamp = data;
        });
    }


    /**
     *
     */
    ngAfterViewInit() {
        this.cdr.detectChanges();
    }

    /**
     *
     * @param reportType
     */
    clickReportLink(reportType: string, print: boolean = false) {

        let url = '/index.html?returnPath=report/' + reportType;
        localStorage.setItem('REPORT-' + reportType.toUpperCase(), print.toString());

        if (reportType === 'crrreport') {
            localStorage.setItem('crrReportConfidentiality', this.securitySelected);
        }

        window.open(url, "_blank");
    }

    clickReportService(report: string) {
        this.reportSvc.getPdf(report, this.securitySelected).subscribe(data => {
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
        // the below code needs converted to ISE stuff
        this.acetSvc.getIseAnswerCompletionRate().subscribe((percentAnswered: number) => {
            if (percentAnswered == 100) {
                this.disableIseReportLinks = false;
            }
        });
    }

    /**
     * Gets all ISE Findings/Issues, 
     * then stores them in an array if the exam levels match (SCUEP alone, CORE/CORE+ together)
     */
    getAssessmentFindings() {
        this.ncuaSvc.unassignedIssueTitles = [];
        this.findSvc.GetAssessmentFindings().subscribe(
          (r: any) => {
            this.findings = r;
            let title = '';
            
            for (let i = 0; i < this.findings?.length; i++) {
                // substringed this way to cut off the '+' from 'CORE+' so it's still included with a CORE assessment
                if (this.ncuaSvc.translateExamLevel(this.findings[i]?.question?.maturity_Level_Id).substring(0, 4) == this.ncuaSvc.getExamLevel().substring(0, 4)) {
                    if (this.findings[i]?.finding?.type == null || this.findings[i]?.finding?.type == '') {
                        title = this.findings[i]?.category?.title + ', ' + this.findings[i]?.question?.question_Title;
                        this.ncuaSvc.unassignedIssueTitles.push(title);
                    }
                }
            }
            if (this.ncuaSvc.unassignedIssueTitles?.length == 0){
                this.ncuaSvc.unassignedIssues = false;
            } else {
                this.ncuaSvc.unassignedIssues = true;
            }

    
          },
          error => console.log('Findings Error: ' + (<Error>error).message)
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
        this.dialogRef
            .afterClosed()
            .subscribe();
    }

    exportToExcel() {
        window.location.href = this.configSvc.apiUrl + 'ExcelExport?token=' + localStorage.getItem('userToken');
    }

    /**
     * 
     */
    clickExport() {
        // get short-term JWT from API
        this.authSvc.getShortLivedTokenForAssessment(this.assessSvc.assessment.id)
            .subscribe((response: any) => {
                const url =
                    this.fileSvc.exportUrl + "?token=" + response.token;

                //if electron
                window.location.href = url;
            });
    }
}

@Component({
    selector: 'snack-bar-component-example-snack',
    template: ' <span class="">To print or save any of these reports as PDF, click the report which will open in a new window. In the top right corner of the web page, click the … button (Settings and more, ALT + F) and navigate to Print. To export a copy of your assessment to another location (.csetw), click the CSET logo in the top left corner of the page. Under My Assessments, you will see your assessment and an Export button on the right hand side of the page. </span> <button (click)="snackBarRef.dismiss()">Close</button> ',
    styles: [
        '',
    ],
})

export class PrintSnackComponent {
    constructor(
        public snackBarRef: MatSnackBarRef<PrintSnackComponent>,
        @Inject(MAT_SNACK_BAR_DATA) public data: any) {
    }

    closeMe() {

    }
}