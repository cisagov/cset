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
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { MatDialog } from '@angular/material/dialog';
import { CharterMismatchComponent } from '../dialogs/charter-mistmatch/charter-mismatch.component';
import { AcetFilteringService } from './filtering/maturity-filtering/acet-filtering.service';
import { AssessmentService } from './assessment.service';
import { MaturityService } from './maturity.service';
import { ACETService } from './acet.service';
import { IRPService } from './irp.service';
import { MeritCheckComponent } from '../dialogs/ise-merit/merit-check.component';
import { Answer } from '../models/questions.model';
import { AuthenticationService } from './authentication.service';
import { DateAdapter } from '@angular/material/core';
import { TranslocoService } from '@ngneat/transloco';
import { ReportService } from './report.service';
import { VersionService } from './version.service';
import { forEach } from 'lodash';

let headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

/**
 * A service that checks for the NCUA examiner's installation switch,
 * and manages various ISE examination variables.
 */
@Injectable({
  providedIn: 'root'
})

export class NCUAService {

  // used to determine whether this is an NCUA installation or not
  apiUrl: string;
  switchStatus: boolean;

  // used for keeping track of which examinations are being merged
  prepForMerge: boolean = false;
  assessmentsToMerge: any[] = [];
  mainAssessCharter: string = "";
  backupCharter: string = "";
  hasShownCharterWarning: boolean = false;

  // Used to determine which kind of ISE exam is needed (SCUEP or CORE/CORE+)
  assetsAsString: string = "0";
  assetsAsNumber: number = 0;
  usingExamLevelOverride: boolean = false;
  proposedExamLevel: string = "SCUEP";
  chosenOverrideLevel: string = "No Override";

  // CORE+ question trigger/state manager
  showCorePlus: boolean = false;

  // CORE+ Only
  showExtraQuestions: boolean = false;

  // Variables to manage ISE issues state
  issuesFinishedLoading: boolean = false;
  questionCheck = new Map();
  issueObservationId = new Map();
  deleteHistory = new Set();

  // Keeps track of Issues with unassigned Types for report notification
  unassignedIssueTitles: any = [];
  unassignedIssues: boolean = false;

  // Make sure we have these variables before we submit MERIT data
  creditUnionName = "";
  creditUnionCharterNumber = "";

  ISE_StateLed: boolean = false;
  iseHasBeenSubmitted: boolean = false;
  issuesForSubmission: any;

  questions: any = null;
  iseIrps: any = null;
  information: any = null;
  version: any;

  // below fields are commented out on client request, they'll be reintroduced soon
  jsonString: any = {
    "metaData": {
      "assessmentName": '',
      "creditUnionName": '',
      "charter": '',
      "examiner": '',
      "effectiveDate": '',
      "creationDate": '',
      // "stateLed": false,
      "examLevel": '',
      // "region": 0,
      // "assets": 0,
      "guid": '',
      // "acet_version": '',
      // "db_version": ''
    },
    "issuesTotal": {
      "dors": 0,
      "examinerFindings": 0,
      "supplementalFacts": 0,
      "nonReportables": 0
    },
    "examProfileData": [],
    "questionData": []
  };
  examLevel: string = '';
  submitInProgress: boolean = false;

  // Used to manually take out the questions NCUA doesn't want in the JSON file. 
  // They said they'll revert this soon and we won't have to hardcode like this, but who knows.
  unwantedQuestionIds: number[] = [
    7746
    ,7754
    ,7755
    ,7771
    ,9918
    ,9919
    ,9920
    ,9921
    // ,9922
    // ,9923
    // ,9924
    // ,9925
    ,10926
    ,10927
    ,10928
    ,10929
    ,10930
  ];

  dummyQuestionMap: Map<number, any[]> = new Map([
    [7718, [{"examLevel": "CORE+", "title": "Stmt 3.13", "response": 2}]]
    ,[7730, [{"examLevel": "CORE+", "title": "Stmt 4.17", "response": 2}]]
    ,[7735, [{"examLevel": "CORE+", "title": "Stmt 5.12", "response": 2}]]
    ,[7790, [{"examLevel": "CORE+", "title": "Stmt 11.14", "response": 2}]]
    ,[7802, [{"examLevel": "CORE+", "title": "Stmt 12.15", "response": 2}]]
    ,[7821, [{"examLevel": "CORE+", "title": "Stmt 13.21", "response": 2}
          , {"examLevel": "CORE+", "title": "Stmt 13.22", "response": 2}]]
    ,[7850, [{"examLevel": "CORE+", "title": "Stmt 16.15", "response": 2}]]
    ,[7889, [{"examLevel": "CORE+", "title": "Stmt 19.15", "response": 2}]]

  ]);

  // CORE+ 3.13, CORE+ 4.17, CORE+ 5.12, 11.14, 12.15, 13.21, 13.22, 16.15, 19.15, 
  // were removed, need to add a dummy record to the new file


  // CORE+ 7.13, 8.17, 8.18, 9.21
  // were added, so these need to be hidden from the file
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    public dialog: MatDialog,
    public acetFilteringSvc: AcetFilteringService,
    private maturitySvc: MaturityService,
    private acetSvc: ACETService,
    private irpSvc: IRPService,
    private assessmentSvc: AssessmentService,
    private authSvc: AuthenticationService,
    private dateAdapter: DateAdapter<any>,
    private tSvc: TranslocoService,
    private reportSvc: ReportService,
    public versionSvc: VersionService
  ) {
    this.versionSvc.localVersionObservable$.subscribe(localVersion => {
      this.version = localVersion;
    });
    this.init();
  }

  async init() {
    this.getSwitchStatus();
  }

  /*
  * The master switch for all extra ISE functionality
  */
  getSwitchStatus() {
    this.http.get(this.configSvc.apiUrl + 'isExaminersModule', headers).subscribe((
      response: boolean) => {
      if (this.configSvc.installationMode === 'ACET') {
        this.switchStatus = response;
        /// ISE doesn't want any language options for their installation, so this makes sure the language is set to english.
        /// Prevents the case where 1.'ACET' is installed, 2.the language is changed to spanish, 
        /// and then 3.'ISE' is installed and uses the same database (so the existing 'es' language stays and can't be switched)
        if (this.switchStatus == true) {
          let defaultLang = this.configSvc.config.defaultLang;
          this.tSvc.setActiveLang(defaultLang);
          this.authSvc.setUserLang(defaultLang).subscribe(() => {
            this.dateAdapter.setLocale(defaultLang);
          });
        }
      }
    }
    );
  }


  /*
  * The following functions are all used for the 'Assessment merge' functionality
  */

  // Opens merge toggle checkboxes on the assessment selection (landing) page
  prepExaminationMerge() {
    if (this.prepForMerge === false) {
      this.prepForMerge = true;
    } else if (this.prepForMerge === true) {
      this.assessmentsToMerge = [];
      this.mainAssessCharter = "";
      this.backupCharter = "";
      this.hasShownCharterWarning = false;
      this.prepForMerge = false;
    }
  }

  // Adds or removes selected ISE examinations to the list to merge
  modifyMergeList(assessment: any, event: any) {
    let tempCharter = "";
    const optionChecked = event.target.checked;

    if (optionChecked) {
      tempCharter = this.pullAssessmentCharter(assessment);

      // Sets a fallback charter number if the user deselects the first exam that they selected
      if (this.assessmentsToMerge.length === 1) {
        this.backupCharter = tempCharter;
      }

      if (this.mainAssessCharter === "") {
        this.mainAssessCharter = tempCharter;
      }

      if (this.mainAssessCharter !== tempCharter && this.hasShownCharterWarning === false) {
        this.openCharterWarning();
      }

      this.assessmentsToMerge.push(assessment.assessmentId);
    } else {
      const index = this.assessmentsToMerge.indexOf(assessment.assessmentId);
      this.assessmentsToMerge.splice(index, 1);

      if (index === 0) {
        this.mainAssessCharter = this.backupCharter;
      }

      if (this.assessmentsToMerge.length === 0) {
        this.mainAssessCharter = "";
        this.backupCharter = "";
      }
    }
  }

  pullAssessmentCharter(assessment: any) {
    // All ISE charters start on the 4th character (after the 'ISE' and space) and are 5 digits long.
    let charterNum = "";
    for (let i = 4; i < 9; i++) {
      charterNum += assessment.assessmentName[i];
    }

    return charterNum;
  }

  openCharterWarning() {
    let dialogRef = this.dialog.open(CharterMismatchComponent, {
      width: '250px',
    });

    dialogRef.afterClosed().subscribe(result => {
      this.hasShownCharterWarning = true;
    });
  }

  // Fires off 2 - 10 assessments to the API to run the stored proc to check for conflicting answers
  getAnswers() {
    let id1 = this.assessmentsToMerge[0];
    let id2 = this.assessmentsToMerge[1];
    let id3 = (this.assessmentsToMerge[2] !== undefined ? this.assessmentsToMerge[2] : 0);
    let id4 = (this.assessmentsToMerge[3] !== undefined ? this.assessmentsToMerge[3] : 0);
    let id5 = (this.assessmentsToMerge[4] !== undefined ? this.assessmentsToMerge[4] : 0);
    let id6 = (this.assessmentsToMerge[5] !== undefined ? this.assessmentsToMerge[5] : 0);
    let id7 = (this.assessmentsToMerge[6] !== undefined ? this.assessmentsToMerge[6] : 0);
    let id8 = (this.assessmentsToMerge[7] !== undefined ? this.assessmentsToMerge[7] : 0);
    let id9 = (this.assessmentsToMerge[8] !== undefined ? this.assessmentsToMerge[8] : 0);
    let id10 = (this.assessmentsToMerge[9] !== undefined ? this.assessmentsToMerge[9] : 0);

    headers.params = headers.params.set('id1', id1).set('id2', id2).set('id3', id3).set('id4', id4)
      .set('id5', id5).set('id6', id6).set('id7', id7).set('id8', id8).set('id9', id9).set('id10', id10);

    return this.http.get(this.configSvc.apiUrl + 'getMergeData', headers)
  }

  getNames() {
    let id1 = this.assessmentsToMerge[0];
    let id2 = this.assessmentsToMerge[1];
    let id3 = (this.assessmentsToMerge[2] !== undefined ? this.assessmentsToMerge[2] : 0);
    let id4 = (this.assessmentsToMerge[3] !== undefined ? this.assessmentsToMerge[3] : 0);
    let id5 = (this.assessmentsToMerge[4] !== undefined ? this.assessmentsToMerge[4] : 0);
    let id6 = (this.assessmentsToMerge[5] !== undefined ? this.assessmentsToMerge[5] : 0);
    let id7 = (this.assessmentsToMerge[6] !== undefined ? this.assessmentsToMerge[6] : 0);
    let id8 = (this.assessmentsToMerge[7] !== undefined ? this.assessmentsToMerge[7] : 0);
    let id9 = (this.assessmentsToMerge[8] !== undefined ? this.assessmentsToMerge[8] : 0);
    let id10 = (this.assessmentsToMerge[9] !== undefined ? this.assessmentsToMerge[9] : 0);

    headers.params = headers.params.set('id1', id1).set('id2', id2).set('id3', id3).set('id4', id4)
      .set('id5', id5).set('id6', id6).set('id7', id7).set('id8', id8).set('id9', id9).set('id10', id10);

    return this.http.get(this.configSvc.apiUrl + 'getMergeNames', headers);
  }


  /*
  * The following functions are used to help manage some of the ISE Maturity model "state". I realize
  * this probably isn't ideal in an application as big as CSET, but this is the fastest way to iterate
  * over client requests until things solidify and they stop changing things back and forth.
  */

  // Clears necessary variables on assessment drop
  reset() {
    this.questionCheck.clear();
    this.issueObservationId.clear();
    this.deleteHistory.clear();
  }

  // Pull Credit Union filter data to be used in ISE assessment detail filter search
  getCreditUnionData() {
    headers.params = headers.params.set('model', 'ISE');
    return this.http.get(this.configSvc.apiUrl + 'getCreditUnionData', headers);
  }

  //Manage the ISE maturity levels.
  updateAssetSize(amount: string) {
    this.assetsAsString = amount;
    this.assetsAsNumber = parseInt(amount);
    this.getExamLevelFromAssets();
  }

  regionCodeTranslator(regionCode: number) {
    switch (regionCode) {
      case (1):
        return '1 - Eastern';
      case (2):
        return '2 - Southern';
      case (3):
        return '3 - Western';
      case (8):
        return '8 - ONES';
    }
  }

  checkExamLevel() {
    if (this.usingExamLevelOverride === false) {
      this.getExamLevelFromAssets();
    } else if (this.usingExamLevelOverride === true) {
      return this.chosenOverrideLevel;
    }
  }

  getExamLevelFromAssets() {
    if (!this.isIse()) {
      return;
    }

    if (this.assetsAsNumber > 50000000) {
      this.proposedExamLevel = 'CORE';
      if (this.usingExamLevelOverride === false) {
        this.maturitySvc.saveLevel(2).subscribe();
      }
    } else {
      this.proposedExamLevel = 'SCUEP';
      if (this.usingExamLevelOverride === false) {
        this.maturitySvc.saveLevel(1).subscribe();
      }
    }
  }

  updateExamLevelOverride(level: number) {
    if (!this.isIse()) {
      return;
    }

    if (level === 0) {
      this.usingExamLevelOverride = false;
      this.chosenOverrideLevel = "No Override";
      this.getExamLevelFromAssets();
    } else if (level === 1) {
      this.usingExamLevelOverride = true;
      this.chosenOverrideLevel = "SCUEP";
      this.maturitySvc.saveLevel(1).subscribe();
    } else if (level === 2) {
      this.usingExamLevelOverride = true;
      this.chosenOverrideLevel = "CORE";
      this.maturitySvc.saveLevel(2).subscribe();
    }
    this.refreshGroupList(level);
  }

  refreshGroupList(level: number) {
    this.acetFilteringSvc.resetDomainFilters(level);
  }

  getExamLevel() {
    if (this.usingExamLevelOverride === false) {
      return (this.proposedExamLevel);
    } else if (this.usingExamLevelOverride === true) {
      return (this.chosenOverrideLevel);
    }
  }

  showCorePlusOnlySubCats(id: number) {
    if (id >= 2567 && this.getExamLevel() === 'CORE') {
      return true;
    }
  }

  setExtraQuestionStatus(option: boolean) {
    this.showExtraQuestions = option;
  }

  getExtraQuestionStatus() {
    return this.showExtraQuestions;
  }

  toggleExtraQuestionStatus() {
    this.showExtraQuestions = !this.showExtraQuestions;
  }

  // Used to check answer completion for ISE reports
  getIseAnsweredQuestions() {
    return this.http.get(this.apiUrl + 'reports/acet/getIseAnsweredQuestions', headers);
  }

  // translates the maturity_Level_Id into the maturity_Level
  translateExamLevel(matLevelId: number) {
    if (matLevelId === 17) {
      return 'SCUE';
    } else if (matLevelId === 18 || matLevelId === 19) {
      return 'CORE';
    }
  }

  // translates the maturity_Level_Id into the maturity_Level
  translateExamLevelToInt(matLevelString: string) {
    if (matLevelString === 'SCUE') { //SCUEP, but cut off because the substring(0, 4)
      return 17;
    } else if (matLevelString === 'CORE') {
      return 18;
    }
  }

  isParentQuestion(title: string) {
    if (title.toString().includes('.')) {
      return false;
    }
    return true;
  }

  isIse() {
    return this.assessmentSvc.assessment?.maturityModel?.modelName === 'ISE';
  }

  submitToMerit() {
    this.submitInProgress = true;
    this.questionResponseBuilder(this.issuesForSubmission);
    this.iseIrpResponseBuilder();
  }

  answerTextToNumber(text: string) {
    switch (text) {
      case 'Y':
        return 0;
      case 'N':
        return 1;
      case 'U':
        return 2;
    }
  }

  /**
   * trims the child number '.#' off the given 'title', leaving what the parent 'title' should be
   */
  getParentQuestionTitle(title: string) {
    if (!this.isParentQuestion(title)) {
      let endOfTitle = 6;
      // checks if the title is double digits ('Stmt 10' through 'Stmt 22')
      if (title.charAt(6) != '.') {
        endOfTitle = endOfTitle + 1;
      }
      return title.substring(0, endOfTitle);
    }
  }

  /**
   * trims the child number 'Stmt ' off the given 'title', leaving what the statement number the 'title' is from
   */
  getParentQuestionTitleNumber(title: string) {
    if (this.isParentQuestion(title)) {
      let spaceIndex = title.indexOf(' ') + 1;
      let number = Number.parseInt(title.substring(spaceIndex));
      return number;
    }
  }

  questionResponseBuilder(findings) {
    this.acetSvc.getIseAllQuestions().subscribe(
      (r: any) => {
        this.questions = r;
        this.information = this.questions.information;
        this.examLevel = this.getExamLevel();

        // goes through domains
        for (let i = 0; i < this.questions?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) {
          let domain = this.questions?.matAnsweredQuestions[0]?.assessmentFactors[i];
          // goes through subcategories
          for (let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];
            let childResponses = {
              "title": subcat?.questions[0].title,  //uses parent's title
              "parentNumber": this.getParentQuestionTitleNumber(subcat?.questions[0].title),
              "category": subcat?.title,
              "examLevel": '',
              "issues":
              {
                "dors": 0,
                "examinerFindings": 0,
                "supplementalFacts": 0,
                "nonReportables": 0
              },
              "children": []
            };

            // this makes sure the questions with out-of-order IDs stay in the intended order
            let questions = subcat?.questions?.sort(
              (a, b) => {
                if (a.title.length == b.title.length) {
                  return a.title > b.title ? 1 : ((b.title > a.title ? -1 : 0));
                }
                return a.title.length > b.title.length ? 1 : ((b.title.length > a.title.length ? -1 : 0));
            });

            // goes through questions
            for (let k = 0; k < questions.length; k++) {
              let question = subcat?.questions[k];
              if (childResponses.examLevel === '') {
                childResponses.examLevel = question.maturityLevel;
              }
              if (k != 0) { //don't want parent questions being included with children
                if (!this.unwantedQuestionIds.includes(question.matQuestionId)) {
                  if (this.examLevel === 'SCUEP' && question.maturityLevel !== 'SCUEP') {
                    question.answerText = 'U';
                  }
  
                  else if (this.examLevel === 'CORE' || this.examLevel === 'CORE+') {
                    if (question.maturityLevel === 'CORE+' && question.answerText !== 'U') {
                      this.examLevel = 'CORE+';
                    }
                    else if (question.maturityLevel === 'SCUEP') {
                      question.answerText = 'U';
                    }
                  }
  
                  childResponses.children.push({
                    "examLevel": question.maturityLevel, 
                    "title": question.title,
                    "response": this.answerTextToNumber(question.answerText)
                  });
                }

                // adding in dummy questions to keep the schema the same for the client (they know, we will remove soon)
                if (k == subcat?.questions?.length - 1 && this.dummyQuestionMap.has(question.matQuestionId)) {
                  let dummyQuestions = this.dummyQuestionMap.get(question.matQuestionId);

                  for (let dummy of dummyQuestions) {
                    childResponses.children.push({
                      "examLevel": dummy.examLevel, 
                      "title": dummy.title,
                      "response": dummy.response
                    });
                  }
                }
                
              } else { //if it's a parent question, deal with possible issues (their term for 'findings')
                for (let m = 0; m < findings?.length; m++) {
                  if (findings[m]?.question?.mat_Question_Id == question.matQuestionId
                    && this.translateExamLevel(findings[m]?.question?.maturity_Level_Id) == this.examLevel.substring(0, 4)
                  ) {
                    switch (findings[m]?.finding?.type) {
                      case "DOR":
                        childResponses.issues.dors++;
                        this.jsonString.issuesTotal.dors++;
                        break;
                      case "Examiner Finding":
                        childResponses.issues.examinerFindings++;
                        this.jsonString.issuesTotal.examinerFindings++;
                        break;
                      case "Supplemental Fact":
                        childResponses.issues.supplementalFacts++;
                        this.jsonString.issuesTotal.supplementalFacts++;
                        break;
                      case "Non-reportable":
                        childResponses.issues.nonReportables++;
                        this.jsonString.issuesTotal.nonReportables++;
                        break;
                      default:
                        break;
                    }
                  }
                }
              }
            }

            this.jsonString.questionData.push(childResponses);
          }
        }

        this.metaDataBuilder();
      },
      error => {
        console.log(error);
        let msg = "<br><p>Error" + error + "}}</p>";
        this.dialog.open(MeritCheckComponent, {
          disableClose: true, data: { title: "MERIT Error", messageText: msg }
        });
        this.jsonStringReset();
      }
    );
  }

  iseIrpResponseBuilder() {
    this.irpSvc.getIRPList().subscribe(
      (r: any) => {
        this.iseIrps = r.headerList[5]; //these are all the IRPs for ISE. If this changes in the future, this will need updated

        for (let i = 0; i < this.iseIrps?.irpList?.length; i++) {
          let currentIrp = this.iseIrps?.irpList[i];

          let irpResponse = { "examProfileNumber": currentIrp.item_Number, "response": currentIrp.response };
          this.jsonString.examProfileData.push(irpResponse);
        }

      },
      error => {
        console.log(error);
        let msg = "<br><p>Error" + error + "}}</p>";
        this.dialog.open(MeritCheckComponent, {
          disableClose: true, data: { title: "MERIT Error", messageText: msg }
        });
        this.jsonStringReset();
      }
    );
  }

  metaDataBuilder() {
    // below fields are commented out on client request, they'll be reintroduced soon
    let metaDataInfo = {
      "assessmentName": this.information.assessment_Name,
      "creditUnionName": this.information.credit_Union_Name,
      "charter": this.information.charter,
      "examiner": this.information.assessor_Name.trim(),
      "effectiveDate":  this.reportSvc.applyJwtOffset(this.information.assessment_Effective_Date, 'date'), //DateTime.fromISO(this.information.assessment_Effective_Date),
      "creationDate": this.reportSvc.applyJwtOffset(this.information.assessment_Creation_Date, 'datetime').replace(',',''),
      // "stateLed": this.assessmentSvc.assessment.isE_StateLed,
      "examLevel": this.examLevel,
      // "region": this.assessmentSvc.assessment.regionCode,
      // "assets": this.assessmentSvc.assessment.assets,
      "guid": this.questions.assessmentGuid,
      // "acet_version": this.version,
      // "db_version": this.questions.csetVersion
    };

    this.jsonString.metaData = metaDataInfo;

    this.saveToJsonFile(JSON.stringify(this.jsonString), this.jsonString.metaData.guid);
  }

  saveToJsonFile(data: string, guid: string) {
    const fileValue = new MeritFileExport();
    fileValue.data = data;
    fileValue.guid = guid;

    this.doesDirectoryExist().subscribe(
      (exists: boolean) => {
        if (exists === false) {
          let msg = `<br><p>The Submission Export Path is not accessible.</p>
                         <p>Please make sure the directory exists and is viewable.</p>`;
          this.dialog.open(MeritCheckComponent, {
            disableClose: true, data: { title: "Submission Error", messageText: msg }
          });
          this.jsonStringReset();
        }
        else if (exists === true) {
          this.acetSvc.doesMeritFileExist(fileValue).subscribe(
            (bool: any) => {
              let exists = bool; //true if it exists, false if not

              if (!exists) { //and eventually an 'overwrite' boolean or something
                this.newMeritFileSteps(fileValue);
                this.updateSubmissionStatus().subscribe(result => { });
              } else {

                let msg = `<br>
                  <p>This examination has been previously submitted.</p>
                  <br>
                  <p>Would you like to <strong>overwrite</strong> the previous submission data?</p>`;

                this.dialog.open(MeritCheckComponent, {
                  disableClose: true, data: { title: "Submission Warning", messageText: msg }

                }).afterClosed().subscribe(overrideChoice => {
                  if (overrideChoice == 'new') {
                    fileValue.overwrite = false;
                    this.acetSvc.overrideMeritFile(fileValue).subscribe(
                      (guidCarrier: any) => {
                        let msg = `<br><p>The file '<strong>` + guidCarrier.guid + `.json</strong>' was successfully created.</p>`;
                        this.dialog.open(MeritCheckComponent, {
                          disableClose: true, data: { title: "Submission Success", messageText: msg }
                        })
                        this.jsonStringReset();
                        this.updateSubmissionStatus().subscribe(result => {
                          this.getSubmissionStatus().subscribe((result: any) => {
                            this.iseHasBeenSubmitted = result;
                          });
                        });
                      },
                      error => {
                        let msg = "<br><p>Could not overwrite the file.  " + error.error + "</p>";
                        this.dialog.open(MeritCheckComponent, {
                          disableClose: true, data: { title: "Submission Error", messageText: msg }
                        });
                        this.jsonStringReset();
                      }
                    );
                  } else if (overrideChoice == 'overwrite') {
                    fileValue.overwrite = true;
                    this.acetSvc.overrideMeritFile(fileValue).subscribe(
                      (guidCarrier: any) => {
                        msg = `<br><p>The file '<strong>` + guidCarrier.guid + `.json</strong>' was successfully overwritten.</p>`;
                        this.dialog.open(MeritCheckComponent, {
                          disableClose: true, data: { title: "Submission Success", messageText: msg }
                        })
                        this.jsonStringReset();

                        this.updateSubmissionStatus().subscribe(result => {
                          this.getSubmissionStatus().subscribe((result: any) => {
                            this.iseHasBeenSubmitted = result;
                          });
                        });
                      },
                      error => {
                        let msg = "<br><p>Could not write the file." + error.error + "</p>";
                        this.dialog.open(MeritCheckComponent, {
                          disableClose: true, data: { title: "Submission Error", messageText: msg }
                        });
                        this.jsonStringReset();
                      }
                    );
                  } else {
                    this.jsonStringReset();
                  }
                });
              }

            }
          )
        }
      },
      error => {
        console.log(error);
        let msg = "<br><p>" + error.error + "</p>";
        this.dialog.open(MeritCheckComponent, {
          disableClose: true, data: { title: "Submission Error", messageText: msg }
        });
        this.jsonStringReset();
      }
    )
  }

  newMeritFileSteps(fileValue: MeritFileExport) {

    //fileValue.data = JSON.stringify(this.jsonString);

    this.acetSvc.newMeritFile(fileValue).subscribe(
      (r: any) => {
        let msg = `<br><p>The file '<strong>` + fileValue.guid + `.json</strong>' was successfully created.</p>`;
        this.dialog.open(MeritCheckComponent, {
          disableClose: true, data: { title: "Submission Success", messageText: msg }
        })
        this.jsonStringReset();

        this.updateSubmissionStatus().subscribe(result => {
          this.getSubmissionStatus().subscribe((result: any) => {
            this.iseHasBeenSubmitted = result;
          });
        });
      },
      error => {
        console.log(error);
        let msg = "<br><p>Error:" + error.error + "</p>";
        this.dialog.open(MeritCheckComponent, {
          disableClose: true, data: { title: "Submission Error", messageText: msg }
        });
        this.jsonStringReset();
      }
    );
  }

  jsonStringReset() {
    this.jsonString = { // resets the string to blank values
      "metaData": {
        "assessmentName": '',
        "creditUnionName": '',
        "charter": '',
        "examiner": '',
        "effectiveDate": '',
        "creationDate": '',
        "examLevel": '',
        "region": 0,
        "assets": 0,
        "stateLed": false,
        "guid": '',
        "acet_version": '',
        "db_version": ''
      },
      "issuesTotal": {
        "dors": 0,
        "examinerFindings": 0,
        "supplementalFacts": 0,
        "nonReportables": 0
      },
      "examProfileData": [],
      "questionData": []
    };

    this.submitInProgress = false;
  }

  doesDirectoryExist() {
    return this.http.get(this.configSvc.apiUrl + 'doesMeritDirectoryExist', headers);
  }

  getUncPath() {
    return this.http.get(this.configSvc.apiUrl + 'getUncPath', headers);
  }

  saveUncPath(newPath: string) {
    const uncPathCarrier = new MeritFileExport();
    uncPathCarrier.data = newPath;
    return this.http.post(this.configSvc.apiUrl + 'saveUncPath', uncPathCarrier, headers);
  }

  getSubmissionStatus() {
    return this.http.get(this.configSvc.apiUrl + 'getIseSubmissionStatus');
  }

  updateSubmissionStatus() {
    return this.http.post(this.configSvc.apiUrl + 'updateIseSubmissionStatus', headers);
  }

  /**
   * block answer for ease of testing while in development mode, but don't have the time to make it
   */
  answerAllQuestionsYes() {
    let answerList: Answer[] = [];

    // for
  }

}

export class MeritFileExport {
  overwrite: boolean;
  data: string;
  guid: string;
}
