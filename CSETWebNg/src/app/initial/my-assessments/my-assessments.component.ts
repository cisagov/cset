////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { FileUploadClientService } from '../../services/file-client.service';
import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Sort } from '@angular/material/sort';
import { Router } from '@angular/router';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { AlertComponent } from '../../dialogs/alert/alert.component';
import { ImportAssessmentService } from '../../services/import-assessment.service';
import { UploadExportComponent } from '../../dialogs/upload-export/upload-export.component';
import { Title } from '@angular/platform-browser';
import { NavigationService } from '../../services/navigation/navigation.service';
import { QuestionFilterService } from '../../services/filtering/question-filter.service';
import { ReportService } from '../../services/report.service';
import { firstValueFrom, of } from 'rxjs';
import { concatMap, map, tap, catchError } from 'rxjs/operators';
import { NavTreeService } from '../../services/navigation/nav-tree.service';
import { LayoutService } from '../../services/layout.service';
import { Comparer } from '../../helpers/comparer';
import {
  ExportAssessmentComponent
} from '../../dialogs/assessment-encryption/export-assessment/export-assessment.component';
import { DateTime } from 'luxon';
import { TranslocoService } from '@jsverse/transloco';
import { DateAdapter } from '@angular/material/core';
import { ConversionService } from '../../services/conversion.service';
import { FileExportService } from '../../services/file-export.service';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { HostListener } from '@angular/core';

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
  done?: boolean;
  favorite?: boolean;
  firstName?: string;
  lastName?: string;
}

@Component({
  selector: 'app-my-assessments',
  templateUrl: 'my-assessments.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' },
  standalone: false
})
export class MyAssessmentsComponent implements OnInit {
  comparer: Comparer = new Comparer();
  sortedAssessments: UserAssessment[] = [];
  unsupportedImportFile: boolean = false;

  browserIsIE: boolean = false;

  // contains CSET or ACET; used for tooltips, etc
  appName: string;
  appTitle: string;


  exportExtension: string;
  importExtensions: string = '.csetw';
  exportAllInProgress: boolean = false;

  timer = ms => new Promise(res => setTimeout(res, ms));
  currentFilter: 'all' | 'done' | 'pending' | 'favorite' = 'all';
  private gridApi!: GridApi;

  columnDefs: ColDef[] = [];

  defaultColDef: ColDef = {
    resizable: true,
    sortable: true,
    filter: true
  };
  dynamicGridHeight: number = 600;
  private readonly minGridHeight = 300;

  constructor(
    public configSvc: ConfigService,
    public authSvc: AuthenticationService,
    private router: Router,
    public assessSvc: AssessmentService,
    public dialog: MatDialog,
    public importSvc: ImportAssessmentService,
    public fileExportSvc: FileExportService,
    public fileSvc: FileUploadClientService,
    public titleSvc: Title,
    public navSvc: NavigationService,
    public navTreeSvc: NavTreeService,
    private filterSvc: QuestionFilterService,
    public tSvc: TranslocoService,
    public layoutSvc: LayoutService,
    public dateAdapter: DateAdapter<any>,
    public reportSvc: ReportService,
    public conversionSvc: ConversionService
  ) {
  }

  ngOnInit() {
    this.getAssessments();
    this.calculateGridHeight();

    this.browserIsIE = /msie\s|trident\//i.test(window.navigator.userAgent);
    this.titleSvc.setTitle(this.configSvc.config.behaviors.defaultTitle);
    this.appTitle = this.configSvc.config.behaviors.defaultTitle;
    this.appName = 'CSET';

    if (localStorage.getItem('returnPath')) {
    } else {
      this.navTreeSvc.clearTree(this.navSvc.getMagic());
    }


    this.configSvc.getCisaAssessorWorkflow().subscribe((resp: boolean) => {
      this.configSvc.userIsCisaAssessor = resp
      this.initializeColumnDefs()
      if (this.gridApi) {
        this.gridApi.setGridOption('columnDefs', this.columnDefs);
      }
    });
    this.tSvc.langChanges$.subscribe((lang: string) => {
      this.updateGridTranslations();
    });
  }

  updateGridTranslations(): void {
    this.initializeColumnDefs();
    if (this.gridApi) {
      this.gridApi.setGridOption('columnDefs', this.columnDefs);
    }
  }

  initializeColumnDefs() {
    this.columnDefs = [
      {
        field: 'assessmentName',
        headerName: this.tSvc.translate('assessment name'),
        sortable: true,
        filter: true,
        flex: 2,
        cellRenderer: (params: any) => {
          return `
    <button class="btn btn-link tw:text-left tw:justify-start tw:h-full tw:w-full"
            data-action="navigate"
            data-assessment-id="${params.data.assessmentId}"
            style="text-align: left; justify-content: flex-start;"
            tabindex="0">
      ${params.value}
    </button>
  `;
        }
      },
      {
        field: 'type',
        headerName: this.tSvc.translate('assessment type'),
        sortable: true,
        filter: true,
        flex: 1,
        cellRenderer: (params: any) => `<div class="tw:flex tw:items-center tw:h-full tw:text-sm">${params.value}</div>`
      },
      {
        field: 'lastModifiedDate',
        headerName: this.tSvc.translate('last modified'),
        sortable: true,
        flex: 1,
        valueFormatter: (params) => {
          if (!params.value) return '';

          let dateObj;
          if (params.value && typeof params.value === 'object' && params.value.toJSDate) {
            dateObj = params.value.toJSDate();
          } else if (typeof params.value === 'string') {
            dateObj = new Date(params.value);
          } else if (params.value instanceof Date) {
            dateObj = params.value;
          } else {
            return '';
          }

          // Format as M/D/YYYY (e.g., 8/20/2025)
          return dateObj.toLocaleDateString('en-US', {
            month: 'numeric',
            day: 'numeric',
            year: 'numeric'
          });
        },
        cellRenderer: (params: any) => {
          // Use the formatted value, not the raw value
          const formattedDate = params.valueFormatted || params.value;
          return `<div class="tw:flex tw:items-center tw:h-full tw:text-sm">${formattedDate}</div>`;
        }
      },
      {
        field: 'creatorName',
        headerName: this.tSvc.translate('primary assessor'),
        sortable: true,
        flex: 1,
        hide: !this.showColumn('primary-assessor'),
        valueGetter: (params) => `${params.data.firstName || ''} ${params.data.lastName || ''}`.trim(),
        cellRenderer: (params: any) => `<div class="tw:flex tw:items-center tw:h-full tw:text-sm">${params.value}</div>`
      },
      {
        headerName: this.tSvc.translate('status'),
        width: 250,
        cellRenderer: (params: any) => {
          const assessment = params.data;
          const percentage = this.getCompletionPercentage(assessment);
          const favoriteIcon = assessment.favorite ? 'favorite' : 'favorite_border';
          const favoriteClass = assessment.favorite ? 'tw:text-red-500' : 'tw:text-gray-400';
          const reviewFlag = (assessment.markedForReview || assessment.altTextMissing);
          const flagClass = reviewFlag ? 'tw:text-orange-500' : 'tw:text-gray-400';
          const tooltipText = this.getProgressTooltip(assessment);

          return `
          <div class="tw:flex tw:items-center tw:gap-2 tw:h-full tw:py-2">
            <button class="btn btn-ghost hover:!tw:rounded-lg tw:btn-xs p-1 tw:min-h-0 tw:h-auto hover:tw:bg-base-200"
                    data-action="toggleFavorite"
                    data-assessment-id="${assessment.assessmentId}"
                    title="${assessment.favorite ? 'Remove from favorites' : 'Add to favorites'}">
              <span class="material-icons text-lg ${favoriteClass}">
                ${favoriteIcon}
              </span>
            </button>

            <span class="cursor-pointer cset-icons-flag-dark tw:text-lg p-1 ${flagClass}"
                  title="${reviewFlag ? 'Assessment requires review' : 'No review required'}">
            </span>

            <div class="tw:flex-1 tw:min-w-0">
              <progress class="progress custom-progress tw:w-full h-2 cursor-pointer"
                        value="${percentage}"
                        max="100"
                        title="${tooltipText}"></progress>
            </div>

            <span class="tw:text-sm tw:text-gray-500 tw:min-w-fit tw:font-medium">
              ${percentage}%
            </span>
          </div>
        `;
        },
        sortable: false,
        filter: false,
        flex: 2
      },
      {
        headerName: 'Actions',
        cellRenderer: this.actionsRenderer.bind(this),
        sortable: false,
        filter: false,
        width: this.showColumn('export json') ? 345 : 200,
        pinned: 'right'
      }
    ];
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
    }

    if (column == 'analytics') {
      return false;
    }

    if (column == 'export') {
      return true;
    }

    if (column == 'export json') {
      return this.configSvc.userIsCisaAssessor;
    }

    return true;
  }

  showCsetOrigin(): boolean {
    return this.configSvc.installationMode === 'CSET';
  }

  getAssessments() {
    this.sortedAssessments = null;
    this.filterSvc.refresh();
    //NOTE THIS remove to disable the menu items when clearing
    localStorage.removeItem('assessmentId');
    const rid = localStorage.getItem('redirectid');
    if (rid != null) {
      localStorage.removeItem('redirectid');
      this.navSvc.beginAssessment(+rid);
    }
    this.assessSvc.getAssessmentsCompletion().pipe(
      concatMap((assessmentsCompletionData: any[]) =>
        this.assessSvc.getAssessments().pipe(
          map((assessments: UserAssessment[]) => {
            assessments.forEach((item, index, arr) => {

              // determine assessment type display
              item.type = this.determineAssessmentType(item);


              let currentAssessmentStats = assessmentsCompletionData.find(x => x.assessmentId === item.assessmentId);
              item.completedQuestionsCount = currentAssessmentStats?.completedCount;
              item.totalAvailableQuestionsCount =
                (currentAssessmentStats?.totalMaturityQuestionsCount ?? 0) +
                (currentAssessmentStats?.totalDiagramQuestionsCount ?? 0) +
                (currentAssessmentStats?.totalStandardQuestionsCount ?? 0);


            });


            this.sortedAssessments = assessments;
          },
            error => {
              console.error(
                'Unable to get Assessments for ' +
                this.authSvc.email() +
                ': ' +
                (<Error>error).message
              );
            }
          )
        ))).subscribe();
  }

  /**
   *
   */
  determineAssessmentType(item: UserAssessment) {
    let type = '';

    if (item.useDiagram) type += ', Diagram';
    item.questionAlias = 'questions';

    if (item.useMaturity) {
      type += ', ' + this.getMaturityModelShortName(item);
    }
    if (item.useStandard && item.selectedStandards) type += ', ' + item.selectedStandards;
    if (type.length > 0) type = type.substring(2);

    return type;
  }

  /**
   * Tries to find a "model short title" in the language files.
   * If it can't find a defintion, just use the selected model's title.
   */
  getMaturityModelShortName(a: UserAssessment) {
    const key = `modules.${a.selectedMaturityModel.toLowerCase()}.model short title`;
    const val = this.tSvc.translate(key);
    if (key == val) {
      return a.selectedMaturityModel;
    }
    return val;
  }

  /**
   *
   */
  hasPath(rpath: string) {
    if (rpath != null) {
      localStorage.removeItem('returnPath');
      this.router.navigate([rpath], { queryParamsHandling: 'preserve' });
    }
  }

  /**
   * "Deletes" an assessment by removing the current user from it.  The assessment
   * is not deleted, but will no longer appear in the current user's list.
   */
  removeAssessment(assessment: UserAssessment, assessmentIndex: number) {
    this.assessSvc.getAssessmentToken(assessment.assessmentId).then(() => {
      this.assessSvc.isDeletePermitted().subscribe(canDelete => {
        if (!canDelete) {
          this.dialog.open(AlertComponent, {
            data: { messageText: 'You cannot remove an assessment that has other users.' }
          });
          return;
        }

        const dialogRef = this.dialog.open(ConfirmComponent);
        dialogRef.componentInstance.confirmMessage =
          this.tSvc.translate('dialogs.remove assessment', { assessmentName: assessment.assessmentName });

        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.assessSvc.removeMyContact(assessment.assessmentId).pipe(
              tap(() => {
                const index = this.sortedAssessments.findIndex(a => a.assessmentId === assessment.assessmentId);
                if (index > -1) {
                  this.sortedAssessments.splice(index, 1);
                }

                if (this.gridApi) {
                  this.gridApi.setGridOption('rowData', this.filteredAssessments);
                }
              }),
              catchError(error => {
                this.dialog.open(AlertComponent, {
                  data: { messageText: error.statusText }
                });
                return of(null);
              })
            ).subscribe();
          }
        });
      });
    });
  }


  /**
   *
   */
  sortData(sort: Sort) {
    if (!sort.active || sort.direction === '') {
      return;
    }

    this.sortedAssessments.sort((a, b) => {
      const isAsc = sort.direction === 'asc';
      switch (sort.active) {
        case 'assessment':
          return this.comparer.compare(a.assessmentName, b.assessmentName, isAsc);
        case 'date':
          return this.comparer.compare(a.lastModifiedDate, b.lastModifiedDate, isAsc);
        case 'assessor':
          return this.comparer.compare(a.creatorName, b.creatorName, isAsc);
        case 'type':
          return this.comparer.compare(a.type, b.type, isAsc);
        case 'status':
          return this.comparer.compareBool(a.markedForReview, b.markedForReview, isAsc);
        case 'ise-submitted':
          return this.comparer.compareIseSubmission(a.submittedDate, b.submittedDate, isAsc);
        default:
          return 0;
      }
    });
  }

  /**
   *
   */
  logout() {
    this.authSvc.logout();
  }

  /**
   *
   */
  async clickDownloadLink(assessment_id: number, jsonOnly: boolean = false) {
    const obs = this.assessSvc.getEncryptPreference();
    const prom = firstValueFrom(obs);
    prom.then((response: boolean) => {
      let encryption = response;

      if (encryption || jsonOnly) {
        let dialogRef = this.dialog.open(ExportAssessmentComponent, {
          data: { jsonOnly, encryption }
        });

        dialogRef.afterClosed().subscribe(result => {
          let url = this.fileSvc.exportUrl;

          this.authSvc.getShortLivedTokenForAssessment(assessment_id).subscribe((response: any) => {
            if (result) {
              if (jsonOnly) {
                url = this.fileSvc.exportJsonUrl;
              }

              let params = '';

              if (result.removePCII) {
                params = params + '&removePCII=' + result.removePCII;
              }

              if (result.encryptionData.password != null && result.encryptionData.password !== '') {
                params = params + '&password=' + result.encryptionData.password;
              }

              if (result.encryptionData.hint != null && result.encryptionData.hint !== '') {
                params = params + '&passwordHint=' + result.encryptionData.hint;
              }

              if (params.length > 0) {
                url = url + '?' + params.replace(/^&/, '');
              }
              this.fileExportSvc.fetchAndSaveFile(url, response.token);
            }


          });
        });
      } else {
        this.authSvc.getShortLivedTokenForAssessment(assessment_id).subscribe((response: any) => {
          let url = this.fileSvc.exportUrl;
          this.fileExportSvc.fetchAndSaveFile(url, response.token);
        });
      }
      ;
    });
  }

  /**
   *
   * @param event
   */
  importAssessmentFile(event) {
    let dialogRef = null;
    this.unsupportedImportFile = false;
    if (event.target.files[0].name.endsWith('.csetw')
      || event.target.files[0].name.endsWith('.acet')) {
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


  clickNewAssessmentButton() {
    this.router.navigate(['/home'], { queryParams: { tab: 'newAssessment' } });
  }

  //translates assessment.lastModifiedDate to the system time, without changing lastModifiedDate
  systemTimeTranslator(dateString: string, format: string) {
    var dtD = DateTime.fromISO(dateString);
    let localDate = '';
    if (format == 'med') {
      localDate = dtD.setLocale(this.tSvc.getActiveLang()).toLocaleString(DateTime.DATETIME_MED_WITH_SECONDS);
    } else if (format == 'short') {
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


  temp() {
    this.assessSvc.moveActionItemsFrom_IseActions_To_HydroData().subscribe();
  }

  get filteredAssessments(): UserAssessment[] {
    if (!this.sortedAssessments) return [];
    switch (this.currentFilter) {
      case 'done':
        return this.sortedAssessments.filter(a => a.done == true);
      case 'pending':
        return this.sortedAssessments.filter(a => a.done == false);
      case 'favorite':
        return this.sortedAssessments.filter(a => a.favorite == true);
      default:
        return this.sortedAssessments;
    }
  }

  setFilter(filter: 'all' | 'done' | 'pending' | 'favorite'): void {
    this.currentFilter = filter;
  }

  getCompletionPercentage(assessment: UserAssessment): number {
    if (!assessment.totalAvailableQuestionsCount || assessment.totalAvailableQuestionsCount === 0) {
      return 0;
    }
    return Math.round((assessment.completedQuestionsCount / assessment.totalAvailableQuestionsCount) * 100);
  }
  // Actions cell with delete and export buttons
  actionsRenderer(params: any): string {
    const assessment = params.data;
    const assessmentId = assessment.assessmentId;
    const rowIndex = params.rowIndex;

    let buttons = `
    <button class="btn btn-ghost btn-sm hover:btn-error"
            data-action="delete"
            data-assessment-id="${assessmentId}"
            data-row-index="${rowIndex}"
            title="Remove assessment">
      <span class="cset-icons-trash-x tw:text-sm mr-2"></span>
      <span class="text-nowrap">Remove</span>
    </button>
  `;

    if (this.showColumn('export')) {
      buttons += `
      <button class="btn btn-ghost btn-sm ml-1"
              data-action="export"
              data-assessment-id="${assessmentId}"
              title="Export assessment">
        <span class="cset-icons-export-up tw:text-sm mr-2"></span>
        <span class="text-nowrap">Export</span>
      </button>
    `;
    }

    if (this.showColumn('export json')) {
      buttons += `
      <button class="btn btn-ghost btn-sm ml-1"
              data-action="exportJson"
              data-assessment-id="${assessmentId}"
              title="Export assessment JSON">
        <span class="cset-icons-export-up tw:text-sm mr-2"></span>
        <span class="text-nowrap">Export JSON</span>
      </button>
    `;
    }

    return `<div class="tw:flex tw:h-full tw:gap-1">${buttons}</div>`;
  }

  onGridReady(params: GridReadyEvent): void {
    this.gridApi = params.api;
    params.api.sizeColumnsToFit();
    setTimeout(() => {
      this.calculateGridHeight();
    }, 50);
  }

  getProgressTooltip(assessment: UserAssessment): string {
    if (assessment.selectedMaturityModel === 'CIS' || assessment.selectedMaturityModel === 'SD02 Series') {
      return this.tSvc.translate('welcome page.blank assessment');
    }

    if (assessment.totalAvailableQuestionsCount > 0) {
      return `${assessment.completedQuestionsCount}/${assessment.totalAvailableQuestionsCount} questions answered`;
    }

    return this.tSvc.translate('welcome page.blank assessment');
  }

  onCellClicked(event: any): void {
    const target = event.event.target;
    const actionElement = target.closest('[data-action]');
    if (!actionElement) return;

    const action = actionElement.getAttribute('data-action');
    const assessmentId = parseInt(actionElement.getAttribute('data-assessment-id'));

    switch (action) {
      case 'navigate':
        this.navSvc.beginAssessment(assessmentId);
        break;

      case 'toggleFavorite':
        const assessment = this.filteredAssessments.find(a => a.assessmentId === assessmentId);
        if (assessment) {
          this.toggleFavorite(assessment);
        }
        break;

      case 'delete':
        const rowIndex = parseInt(actionElement.getAttribute('data-row-index'));
        const assessmentToDelete = this.filteredAssessments.find(a => a.assessmentId === assessmentId);
        if (assessmentToDelete) {
          this.removeAssessment(assessmentToDelete, rowIndex);
        }
        break;

      case 'export':
        this.clickDownloadLink(assessmentId);
        break;

      case 'exportJson':
        this.clickDownloadLink(assessmentId, true);
        break;
    }
  }

  toggleFavorite(assessment: UserAssessment): void {
    const newFavoriteStatus = !assessment.favorite;

    this.assessSvc.getAssessmentToken(assessment.assessmentId).then(() => {
      this.assessSvc.setAssessmentFavorite(newFavoriteStatus).subscribe({
        next: () => {
          assessment.favorite = newFavoriteStatus;
          if (this.gridApi) {
            try {
              this.gridApi.refreshCells({
                force: true
              });
            } catch (error) {
              console.error('Error refreshing grid cells:', error);
            }
          }
        },
        error: (error) => {
          console.error('Failed to update favorite status:', error);
        }
      });
    });
  }
  private calculateGridHeight(): void {
    if (typeof window === 'undefined') return;

    const viewportHeight = window.innerHeight;

    const grid = document.querySelector('.ag-root-wrapper') as HTMLElement;
    const gridTop = grid?.getBoundingClientRect().top;
    const bottomPadding = 25;
    const footer = document.querySelector('#accordionFooter') as HTMLElement;
    const footerHeight = footer?.getBoundingClientRect().height;

    const availableHeight = viewportHeight - gridTop - bottomPadding - footerHeight;

    // Ensure minimum height
    this.dynamicGridHeight = Math.max(availableHeight, this.minGridHeight);
  }
  @HostListener('window:resize', ['$event'])
  onResize(event: any): void {
    this.calculateGridHeight();
    if (this.gridApi) {
      // Refresh grid layout after height change
      setTimeout(() => {
        this.gridApi.sizeColumnsToFit();
      }, 100);
    }
  }
}
