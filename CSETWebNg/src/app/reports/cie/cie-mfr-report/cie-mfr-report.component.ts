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
import { Component, OnInit, ViewChild, Pipe } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ReportService } from '../../../services/report.service';
import { ACETService } from '../../../services/acet.service';
import { ConfigService } from '../../../services/config.service';
import { NCUAService } from '../../../services/ncua.service';
import { GroupingDescriptionComponent } from '../../../assessment/questions/grouping-description/grouping-description.component';
import { ObservationsService } from '../../../services/observations.service';
import { AssessmentService } from '../../../services/assessment.service';
import { QuestionsService } from '../../../services/questions.service';
import { CieService } from '../../../services/cie.service';
import { AuthenticationService } from '../../../services/authentication.service';
import { FileUploadClientService } from '../../../services/file-client.service';
import { QuestionFilterService } from '../../../services/filtering/question-filter.service';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { QuestionFiltersReportsComponent } from '../../../dialogs/question-filters-reports/question-filters-reports.component';

@Component({
  selector: 'app-cie-mfr-report',
  templateUrl: './cie-mfr-report.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss', './cie-mfr-report.component.scss'],
  host: { class: 'd-flex flex-column flex-11a' }
})

export class CieMfrReportComponent implements OnInit {
  response: any = {};
  documents: any = {};


  hasComments: any[] = [];
  // showSubcats: Map<String, boolean> = new Map<String, boolean>();
  expandedOptions: Map<String, boolean> = new Map<String, boolean>();
  shouldIShowMap: Map<String, boolean> = new Map<String, boolean>();

  examLevel: string = '';
  loading: boolean = true;

  principleFound: boolean = false;
  phaseFound: boolean = false;

  principleTitleList: string[] = [];
  phaseTitleList: string[] = [];

  filterDialogRef: MatDialogRef<QuestionFiltersReportsComponent>;

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    private titleService: Title,
    public cieSvc: CieService,
    public configSvc: ConfigService,
    public observationSvc: ObservationsService,
    private authSvc: AuthenticationService,
    private fileSvc: FileUploadClientService,
    private dialog: MatDialog,
    private filterSvc: QuestionFilterService
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Marked for Review CIE - Report");

    this.cieSvc.getCieAllMfrQuestionsWithDocuments().subscribe(
      (r: any) => {
        this.response = r;
        // goes through domains
        for (let i = 0; i < this.response?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) {
          let domain = this.response?.matAnsweredQuestions[0]?.assessmentFactors[i];

          if (domain?.questions?.length > 0) {
            this.principleFound = true;
          }
          // goes through subcategories
          for (let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];
            this.expandedOptions.set('Principle_' + domain?.title, false);
            this.principleTitleList.push('Principle_' + domain?.title);
            this.phaseTitleList.push('Phase_' + domain?.title);
            // this.showSubcats.set(domain?.title + '_' + subcat?.title, true);
            // goes through questions
            if (subcat?.questions?.length > 0) {
              this.phaseFound = true;
            }
            for (let k = 0; k < subcat?.questions?.length; k++) {
              let question = subcat?.questions[k];
              this.expandedOptions.set('Phase_' + domain?.title + '_' + subcat?.title, false);
                this.phaseTitleList.push('Phase_' + domain?.title + '_' + subcat?.title);
              //this.expandedOptions.set(domain?.title + '_' + subcat?.title, false);

            }
          }
        }
        this.loading = false;
      },
      error => console.log('Assessment Answered Questions Error: ' + (<Error>error).message)
    );
  }

  /**
   *
   */
  download(doc: any) {
    // get short-term JWT from API
    this.authSvc.getShortLivedToken().subscribe((response: any) => {
      const url = this.fileSvc.downloadUrl + doc.document_Id + "?token=" + response.token;
      window.location.href = url;
    });
  }

  /**
   *
   */
  downloadFile(document) {
    this.fileSvc.downloadFile(document.document_Id).subscribe((data: Response) => {
      // this.downloadFileData(data),
    },
      error => console.log(error)
    );
  }

  /**
   * Flips the 'expand' boolean value based off the given 'title' key
   */
  toggleExpansion(title: string) {
    let expand = this.expandedOptions.get(title);
    this.expandedOptions.set(title, !expand);
    return expand;
  }

  /**
   * checks if section should expand by checking the boolean value attached to the 'title'
   */
  shouldExpand(title: string) {
    if (this.expandedOptions.get(title)) {
      return true;
    }
    return false;
  }

  getClasses(q: any, top: boolean) {
    let combinedClass = '';
    if (q.title.length == 10 || q.title.charAt(q.title.length - 1) == '0') {
      combinedClass = 'background-3 ';
    }

    if (top) {
      if (q.freeResponseText == null) {
        combinedClass += 'full-border ';
      }
      else {
        combinedClass += 'top-half-border';
      }
    }
    else{
      combinedClass += 'bottom-half-border';
    }
    return combinedClass;
  }

  /**
   * Controls the mass expansion/collapse of all subcategories on the screen.
   * @param mode
   */
  expandAll(mode: boolean, principleOrPhase: string) {
    if (principleOrPhase == 'Principle') {
      for(let i = 0; i < this.principleTitleList.length; i++ ) {
        this.expandedOptions.set(this.principleTitleList[i], mode);
      }
    }
    if (principleOrPhase == 'Phase') {
      for(let i = 0; i < this.phaseTitleList.length; i++ ) {
        this.expandedOptions.set(this.phaseTitleList[i], mode);
      }
    }
  }

  /**
   * Re-evaluates the visibility of all questions/subcategories/categories
   * based on the current filter settings.
   * Also re-draws the sidenav category tree, skipping categories
   * that are not currently visible.
   */
  refreshQuestionVisibility(matLevel: number) {
    this.filterSvc.evaluateFiltersForReportCategories(this.response?.matAnsweredQuestions[0], matLevel);
  }

  /**
   *
   */
  showFilterDialog(matLevel: number) {
    this.filterDialogRef = this.dialog.open(QuestionFiltersReportsComponent);
    this.filterDialogRef.componentInstance.filterChanged.asObservable().subscribe(() => {
      this.refreshQuestionVisibility(matLevel);
    });
    this.filterDialogRef
      .afterClosed()
      .subscribe(() => {
        this.refreshQuestionVisibility(matLevel);
      });
  }
}
