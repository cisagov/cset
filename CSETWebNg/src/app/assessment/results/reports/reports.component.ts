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
import { HttpClient } from '@angular/common/http';
import { Component, OnInit, AfterViewInit, ChangeDetectorRef } from '@angular/core';
import { findLastKey } from 'lodash';
import { ActivatedRoute, Router } from '../../../../../node_modules/@angular/router';
import { ACETService } from '../../../services/acet.service';
import { AssessmentService } from '../../../services/assessment.service';
import { AuthenticationService } from '../../../services/authentication.service';
import { ConfigService } from '../../../services/config.service';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { saveAs } from 'file-saver';
import { ReportService } from '../../../services/report.service';
import { data } from 'jquery';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { ExcelExportComponent } from '../../../dialogs/excel-export/excel-export.component';

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
    disableAcetReportLinks: boolean = true;
    securityIdentifier: any = [];
    securitySelected: string = "None";

    lastModifiedTimestamp = '';

    dialogRef: MatDialogRef<any>;
    /**
     *
     */
    constructor(
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        private acetSvc: ACETService,
        private router: Router,
        private route: ActivatedRoute,
        public configSvc: ConfigService,
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
    }

    /**
     *
     */
    ngOnInit() {
        this.assessSvc.currentTab = 'results';
        this.navSvc.navItemSelected.asObservable().subscribe((value: string) => {
            this.router.navigate([value], { relativeTo: this.route.parent });
        });

        // call the API for a ruling on whether all questions have been answered
        this.disableAcetReportLinks = false;
        if (this.configSvc.installationMode === 'ACET') {
            this.checkAcetDisabledStatus();
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

}
