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
import { FileUploadClientService } from "../../services/file-client.service";
import { Component, OnInit } from "@angular/core";
import { MatDialog } from "@angular/material/dialog";
import { Sort } from "@angular/material/sort";
import { Router } from "@angular/router";
import { AssessmentService } from "../../services/assessment.service";
import { AuthenticationService } from "../../services/authentication.service";
import { ConfigService } from "../../services/config.service";
import { ConfirmComponent } from "../../dialogs/confirm/confirm.component";
import { AlertComponent } from "../../dialogs/alert/alert.component";
import { ImportAssessmentService } from "../../services/import-assessment.service";
import { UploadExportComponent } from "../../dialogs/upload-export/upload-export.component";
import { Title } from "@angular/platform-browser";
import { NavigationService } from "../../services/navigation/navigation.service";
import { QuestionFilterService } from '../../services/filtering/question-filter.service';
import { ReportService } from '../../services/report.service';
import { concatMap, map } from "rxjs/operators";
import { NCUAService } from "../../services/ncua.service";
import { NavTreeService } from "../../services/navigation/nav-tree.service";
import { LayoutService } from "../../services/layout.service";
import { Comparer } from "../../helpers/comparer";
import { ExportPasswordComponent } from '../../dialogs/assessment-encryption/export-password/export-password.component';
import { DateTime } from "luxon";
import { NcuaExcelExportComponent } from "../../dialogs/excel-export/ncua-export/ncua-excel-export.component";
import { TranslocoService } from "@ngneat/transloco";
import { DateAdapter } from '@angular/material/core';
import { HydroService } from "../../services/hydro.service";
import { CieService } from "../../services/cie.service";
import { ConversionService } from "../../services/conversion.service";


interface UserAssessment {
  isEntry: boolean;
  isEntryString: string;
  assessmentId: number;
  assessmentName: string;
  useDiagram: boolean;
  useStandard: boolean;
  useMaturity: boolean;
  type: string;
  assessmentCreatedDate: string;
  creatorName: string;
  lastModifiedDate: DateTime;
  markedForReview: boolean;
  altTextMissing: boolean;
  selectedMaturityModel?: string;
  selectedStandards?: string;
  completedQuestionsCount: number;
  totalAvailableQuestionsCount: number;
  questionAlias: string;
  iseSubmission: boolean;
  submittedDate?: Date;
}

@Component({
  selector: "app-my-assessments",
  templateUrl: "my-assessments.component.html",
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class MyAssessmentsComponent implements OnInit {
  comparer: Comparer = new Comparer();
  sortedAssessments: UserAssessment[] = [];
  unsupportedImportFile: boolean = false;

  browserIsIE: boolean = false;

  // contains CSET or ACET; used for tooltips, etc
  appName: string;
  appTitle: string;
  isTSA: boolean = false;
  isCSET: boolean = false;
  isCF: boolean = false;
  exportExtension: string;
  importExtensions: string;

  displayedColumns: string[] = ['assessment', 'lastModified', 'creatorName', 'markedForReview', 'removeAssessment', 'exportAssessment'];

  prepForMerge: boolean = false;

  exportAllInProgress: boolean = false;

  preventEncrypt: boolean = true;
  disabledEncrypt: boolean = false;

  timer = ms => new Promise(res => setTimeout(res, ms));
  

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
    public navTreeSvc: NavTreeService,
    private filterSvc: QuestionFilterService,
    public tSvc: TranslocoService,
    private ncuaSvc: NCUAService,
    public layoutSvc: LayoutService,
    public dateAdapter: DateAdapter<any>,
    public reportSvc: ReportService,
    private hydroSvc: HydroService,
    public cieSvc: CieService,
    public conversionSvc: ConversionService
  ) { }

  ngOnInit() {
    this.getAssessments();

    this.browserIsIE = /msie\s|trident\//i.test(window.navigator.userAgent);
    this.exportExtension = localStorage.getItem('exportExtension');
    this.importExtensions = localStorage.getItem('importExtensions');
    this.titleSvc.setTitle(this.configSvc.config.behaviors.defaultTitle);
    this.appTitle = this.configSvc.config.behaviors.defaultTitle;
    this.appName = 'CSET';
    switch (this.configSvc.installationMode || '') {
      case 'ACET':
        this.preventEncrypt = true;
        this.updateEncryptPreference();
        this.ncuaSvc.reset();
        break;
      case 'TSA':
        // ACET files shouldn't be imported into the TSA version
        this.importExtensions = this.importExtensions.replace(', .acet', '');
        this.isTSA = true;
        break;
      case 'CF':
        this.isCF = true;
        this.navTreeSvc.clearNoMatterWhat();
        break;
      default:
        this.isCSET = true;
    }

    if (localStorage.getItem("returnPath")) { }
    else {
      this.navTreeSvc.clearTree(this.navSvc.getMagic());      
    }
    // if(this.isCF){
    //   this.navTreeSvc.clearNoMatterWhat();
    // }

    this.ncuaSvc.assessmentsToMerge = [];
    this.cieSvc.assessmentsToMerge = [];

    this.assessSvc.getEncryptPreference().subscribe((result: boolean) => this.preventEncrypt = result);

    this.configSvc.getCisaAssessorWorkflow().subscribe((resp: boolean) => this.configSvc.cisaAssessorWorkflow = resp);
  }

  /**
   * Determines if a particular column should be included in the display.
   */
  showColumn(column: string) {
    if (column == 'primary-assessor') {
      // hide the column for anonymous - there is no primary assessor user
      if (this.configSvc.config.isRunningAnonymous) {
        return false;
      }

      if (this.ncuaSvc.switchStatus) {
        return false;
      }
    }

    if (column == 'analytics') {
      if (this.ncuaSvc.switchStatus) {
        return false;
      }

      return false;
    }

    if (column == 'ise-submitted') {
      if (this.ncuaSvc.switchStatus) {
        return true;
      } else {
        return false;
      }
    }

    if (column == 'export') {
      return true;
    }

    if (column == 'export json') {
      return this.configSvc.cisaAssessorWorkflow;
    }

    return true;
  }

  showCsetOrigin(): boolean {
    return this.configSvc.installationMode === 'CSET';
  }

  showAcetOrigin(): boolean {
    return this.configSvc.installationMode === 'ACET';
  }

  getAssessments() {
    this.sortedAssessments = null;
    this.filterSvc.refresh();
    //NOTE THIS remove to disable the menu items when clearing
    localStorage.removeItem("assessmentId");
    const rid = localStorage.getItem("redirectid");
    if (rid != null) {
      localStorage.removeItem("redirectid");
      this.navSvc.beginAssessment(+rid);
    }

    let assessmentiDs = [];

    this.assessSvc.getAssessmentsCompletion().pipe(
      concatMap((assessmentsCompletionData: any[]) =>
        this.assessSvc.getAssessments().pipe(
          map((assessments: UserAssessment[]) => {
            assessments.forEach((item, index, arr) => {
              if(this.isCF){
                assessmentiDs.push(item.assessmentId);
                item.isEntry = false;                
              }
              let type = '';
              if (item.useDiagram) type += ', Diagram';
              item.questionAlias = 'questions';
              if (item.useMaturity) {
                type += ', ' + item.selectedMaturityModel;
                if (item.selectedMaturityModel === 'ISE') {
                  item.questionAlias = 'statements';
                }
              }
              if (item.useStandard && item.selectedStandards) type += ', ' + item.selectedStandards;
              if (type.length > 0) type = type.substring(2);
              item.type = type;
              let currentAssessmentStats = assessmentsCompletionData.find(x => x.assessmentId === item.assessmentId);
              item.completedQuestionsCount = currentAssessmentStats?.completedCount;
              item.totalAvailableQuestionsCount =
                (currentAssessmentStats?.totalMaturityQuestionsCount ?? 0) +
                (currentAssessmentStats?.totalDiagramQuestionsCount ?? 0) +
                (currentAssessmentStats?.totalStandardQuestionsCount ?? 0);              
            });
            if(this.isCF){
              this.conversionSvc.isEntryCfAssessments(assessmentiDs).subscribe(
                (result: any) => {
                  result.forEach((element: any) => {
                    let assessment = assessments.find(x => x.assessmentId === element.assessmentId);
                    if (assessment) {
                      assessment.isEntry = element.isEntry;
                      assessment.isEntryString = element.isEntry ? 'Entry' : 'Full';                        
                      if(assessment.isEntry)
                        assessment.totalAvailableQuestionsCount = 20;
                    }
                  });
                  this.sortedAssessments = assessments;
                }
              );
            }
            else{
              this.sortedAssessments = assessments;
            }
          },
            error => {
              console.log(
                "Unable to get Assessments for " +
                this.authSvc.email() +
                ": " +
                (<Error>error).message
              );
            }
          )
        ))).subscribe();
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
      .isDeletePermitted(assessment.assessmentId)
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
          // "Are you sure you want to remove '" +
          // assessment.assessmentName +
          // "'?";
          this.tSvc.translate('dialogs.remove assessment', { assessmentName: assessment.assessmentName });
        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.assessSvc.removeMyContact(assessment.assessmentId).subscribe(
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
          return this.comparer.compare(a.assessmentName, b.assessmentName, isAsc);
        case "date":
          return this.comparer.compare(a.lastModifiedDate, b.lastModifiedDate, isAsc);
        case "assessor":
          return this.comparer.compare(a.creatorName, b.creatorName, isAsc);
        case "type":
          return this.comparer.compare(a.type, b.type, isAsc);
        case "status":
          return this.comparer.compareBool(a.markedForReview, b.markedForReview, isAsc);
        case "ise-submitted":
          return this.comparer.compareIseSubmission(a.submittedDate, b.submittedDate, isAsc);
        default:
          return 0;
      }
    });
  }

  logout() {
    this.authSvc.logout();
  }

  clickDownloadLink(ment_id: number, jsonOnly: boolean = false) {
    if (!this.preventEncrypt) {
      let dialogRef = this.dialog.open(ExportPasswordComponent);
      dialogRef.afterClosed().subscribe(result => {

        // get short-term JWT from API
        this.authSvc.getShortLivedTokenForAssessment(ment_id).subscribe((response: any) => {
          let url = this.fileSvc.exportUrl + "?token=" + response.token;

          if (jsonOnly) {
            url = this.fileSvc.exportJsonUrl + "?token=" + response.token;
          }

          if (result.password != null && result.password != "") {
            url = url + "&password=" + result.password;
          }

          if (result.hint != null && result.hint != "") {
            url = url + "&passwordHint=" + result.hint;
          }

          //if electron
          window.location.href = url;

          //if browser
          //window.open(url, "_blank");
        });
      });
    } else {
      this.authSvc.getShortLivedTokenForAssessment(ment_id).subscribe((response: any) => {
        let url = this.fileSvc.exportUrl + "?token=" + response.token;

        if (jsonOnly) {
          url = this.fileSvc.exportJsonUrl + "?token=" + response.token;
        }

        //if electron
        window.location.href = url;

        //if browser
        //window.open(url, "_blank");
      });
    }

  }

  /**
   *
   * @param event
   */
  importAssessmentFile(event) {
    let dialogRef = null;
    this.unsupportedImportFile = false;
    if (event.target.files[0].name.endsWith(".csetw")
      || event.target.files[0].name.endsWith(".acet")) {
      // Call Standard import service
      dialogRef = this.dialog.open(UploadExportComponent, {
        data: { files: event.target.files, IsNormalLoad: true }
      });
    } else {
      if (this.authSvc.isLocal) {
        dialogRef = this.dialog.open(UploadExportComponent, {
          data: { files: event.target.files, IsNormalLoad: false }
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

  /**
   *
   */
  exportToExcelAllAcet() {
    window.location.href = this.configSvc.apiUrl + 'ExcelExportAllNCUA?token=' + localStorage.getItem('userToken');
  }

  openExportDecisionDialog() {
    let dialogRef = this.dialog.open(NcuaExcelExportComponent, {
      data: {
        assessments: this.sortedAssessments
      }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result != undefined) {
        window.location.href = this.configSvc.apiUrl + 'ExcelExportAllNCUA?token=' + localStorage.getItem('userToken') + '&type=' + result;
      }
    });
  }

  proceedToMerge() {
    this.router.navigate(['/examination-merge']);
  }

  proceedToCieMerge() {
    this.router.navigate(['/merge-cie-analysis']);
  }

  clickNewAssessmentButton() {
    this.router.navigate(['/home'], { queryParams: { tab: 'newAssessment' } })
  }

  //translates assessment.lastModifiedDate to the system time, without changing lastModifiedDate
  systemTimeTranslator(dateString: string, format: string) {
    var dtD = DateTime.fromISO(dateString);
    let localDate = '';
    if (format == 'med') {
      localDate = dtD.setLocale(this.tSvc.getActiveLang()).toLocaleString(DateTime.DATETIME_MED_WITH_SECONDS);
    }
    else if (format == 'short') {
      localDate = dtD.setLocale(this.tSvc.getActiveLang()).toLocaleString(DateTime.DATE_SHORT);
    }

    return localDate;
  }

  exportAllAssessments() {
    this.exportAllInProgress = true;
    this.exportAllLoop();
  }


  async exportAllLoop() { // allows for multiple api calls
    for (let i = 0; i < this.sortedAssessments.length; i++) {
      let a = document.getElementById('assess-' + i + '-export');
      a.click();
      await this.timer(1500); // prevents api calls from canceling each other
    }

    this.exportAllInProgress = false;
  }

  updateEncryptPreference() {
    this.disabledEncrypt = true;
    this.assessSvc.persistEncryptPreference(this.preventEncrypt);
    this.disabledEncrypt = false;
  }

  temp() {
    this.assessSvc.moveActionItemsFrom_IseActions_To_HydroData().subscribe();
  }

}
