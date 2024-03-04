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
import { Component, OnInit, ViewChild } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { QuestionsService } from '../../services/questions.service';
import { ACETService } from '../../services/acet.service';
import { ConfigService } from '../../services/config.service';
import { NCUAService } from '../../services/ncua.service';
import { GroupingDescriptionComponent } from '../../assessment/questions/grouping-description/grouping-description.component';
import { ObservationsService } from '../../services/observations.service';
import { AssessmentService } from '../../services/assessment.service';

@Component({
  selector: 'app-ise-examination',
  templateUrl: './ise-examination.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class IseExaminationComponent implements OnInit {
  response: any = {};
  observationResponse: any = {};
  actionItemsForParent: any = {};
  actionData: any = {};
  files: any = {};

  expandedOptions: Map<String, boolean> = new Map<String, boolean>();
  storeIndividualIssues: Map<String, String> = new Map<String, String>();
  showSubcats: Map<String, boolean> = new Map<String, boolean>();

  masterActionItemsMap: Map<number, any[]> = new Map<number, any[]>();

  sourceFilesMap: Map<number, any[]> = new Map<number, any[]>();
  regCitationsMap: Map<number, any[]> = new Map<number, any[]>();
  showActionItemsMap: Map<string, any[]> = new Map<string, any[]>(); //stores what action items to show (answered 'No')

  examinerFindings: string[] = [];
  examinerFindingsTotal: number = 0;
  examinerFindingsInCat: string = '';

  dors: string[] = [];
  dorsTotal: number = 0;
  dorsInCat: string = '';

  supplementalFacts: string[] = [];
  supplementalFactsTotal: number = 0;
  supplementalFactsInCat: string = '';

  nonReportables: string[] = [];
  nonReportablesTotal: number = 0;
  nonReportablesInCat: string = '';

  summaryStatic: string = 'Performed review of the security program using the ISE Toolbox.';
  summaryForCopy: string = this.summaryStatic + '\n\n';

  resultsOfReviewForCopy: string = '';

  examLevel: string = '';

  relaventIssues: boolean = false;
  loadingCounter: number = 0;

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    private titleService: Title,
    public questionsSvc: QuestionsService,
    public acetSvc: ACETService,
    public configSvc: ConfigService,
    public ncuaSvc: NCUAService,
    public observationSvc: ObservationsService
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Examination Report - ISE");


    this.acetSvc.getIseAnsweredQuestions().subscribe(
      (r: any) => {
        this.response = r;
        this.examLevel = this.response?.matAnsweredQuestions[0]?.assessmentFactors[0]?.components[0]?.questions[0]?.maturityLevel;

        // goes through domains
        for (let i = 0; i < this.response?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) {
          let domain = this.response?.matAnsweredQuestions[0]?.assessmentFactors[i];
          // goes through subcategories
          for (let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];

            // initializing all assessment factors / categories / parent questions to true (expanded)
            // used in checking if the section / question should be expanded or collapsed
            this.expandedOptions.set(subcat?.title, true);
            if (subcat?.questions[0]?.maturityLevel !== 'CORE+') {
              this.showSubcats.set(subcat.title, true);
            } else {
              this.showSubcats.set(subcat.title, false);
            }

            // goes through questions
            for (let k = 0; k < subcat?.questions?.length; k++) {
              let question = subcat?.questions[k];

              if (k === 0) {
                this.expandedOptions.set(question.title, true);
                this.storeIndividualIssues.set(question.title, '');
              }

              if (question.maturityLevel === 'CORE+' && question.answerText !== 'U') {
                this.examLevel = 'CORE+';
              }

              if (question.maturityLevel === 'CORE+' && this.requiredQuestion(question)) {
                this.showSubcats.set(subcat?.title, true);
              }
              if (this.requiredQuestion(question) && this.ncuaSvc.isParentQuestion(question)) {
                let issueText = '';
                issueText += 'Title: ' + question.title + '\n';
                issueText += 'Question Text: ' + question.questionText + '\n';
                issueText += 'Results of Review: ';

                if (question.comments === 'Yes') {
                  issueText += question.comment + '\n';
                } else {
                  issueText += '[ No Results of Review given. ]\n';
                }

                issueText += '\n';
                this.storeIndividualIssues.set(question.title, issueText); //stores the issue for individual copy buttons

                this.resultsOfReviewForCopy += issueText;
              }
              this.loadingCounter++;
            }
          }
        }

        let examLevelString = this.examLevel.substring(0, 4);

        this.acetSvc.getActionItemsReport(this.ncuaSvc.translateExamLevelToInt(examLevelString)).subscribe((observationData: any) => {
          this.actionData = observationData;

          for (let i = 0; i < this.actionData?.length; i++) {
            let actionItemRow = this.actionData[i];

            if (actionItemRow.action_Items != '') { //filters out 'deleted' action items
              if (!this.masterActionItemsMap.has(actionItemRow.observation_Id)) {

                this.masterActionItemsMap.set(actionItemRow.observation_Id, [actionItemRow]);
              } else {
                let tempActionArray = this.masterActionItemsMap.get(actionItemRow.observation_Id);

                tempActionArray.push(actionItemRow);

                this.masterActionItemsMap.set(actionItemRow.observation_Id, tempActionArray);
              }
            }
          }
        });


        this.observationSvc.getAssessmentObservations().subscribe(
          (f: any) => {
            this.observationResponse = f;

            for (let i = 0; i < this.observationResponse?.length; i++) {
              if (this.ncuaSvc.translateExamLevel(this.observationResponse[i]?.question?.maturity_Level_Id).substring(0, 4) == this.examLevel.substring(0, 4)) {
                let observation = this.observationResponse[i];
                this.questionsSvc.getDetails(observation.question.mat_Question_Id, 'Maturity').subscribe(
                  (r: any) => {
                    this.files = r;

                    let sourceDocList = this.files?.listTabs[0]?.sourceDocumentsList;

                    for (let i = 0; i < sourceDocList?.length; i++) {
                      if (!this.sourceFilesMap.has(observation.finding.observation_Id)) {

                        this.sourceFilesMap.set(observation.finding.observation_Id, [sourceDocList[i]]);
                      } else {
                        let tempFileArray = this.sourceFilesMap.get(observation.finding.observation_Id);

                        tempFileArray.push(sourceDocList[i]);

                        this.sourceFilesMap.set(observation.finding.observation_Id, tempFileArray);
                      }
                    }
                  }
                );
                if (observation.finding.type === 'Examiner Finding') {
                  this.addExaminerFinding(observation.category.title);
                }
                if (observation.finding.type === 'DOR') {
                  this.addDOR(observation.category.title);
                }
                if (observation.finding.type === 'Supplemental Fact') {
                  this.addSupplementalFact(observation.category.title);
                }
                if (observation.finding.type === 'Non-reportable') {
                  this.addNonReportable(observation.category.title);
                }
                this.relaventIssues = true;
              }
            }

            if (this.relaventIssues) {

              this.summaryForCopy += this.inCatStringBuilder(this.dorsTotal, this.dors?.length, 'DOR');
              this.categoryBuilder(this.dors);

              this.summaryForCopy += this.inCatStringBuilder(this.examinerFindingsTotal, this.examinerFindings?.length, 'Examiner Finding');
              this.categoryBuilder(this.examinerFindings);


              this.summaryForCopy += this.inCatStringBuilder(this.supplementalFactsTotal, this.supplementalFacts?.length, 'Supplemental Fact');
              this.categoryBuilder(this.supplementalFacts);

              this.summaryForCopy += this.inCatStringBuilder(this.nonReportablesTotal, this.nonReportables?.length, 'Non-reportable');
              this.categoryBuilder(this.nonReportables);
            } else {
              this.summaryForCopy += 'No Issues were noted.';
            }

            this.loadingCounter++;
          },
          error => console.log('Observations Error: ' + (<Error>error).message)
        );


      },
      error => console.log('Assessment Answered Questions Error: ' + (<Error>error).message)
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

  /**
   * trims the child number '.#' off the given 'title', leaving what the parent 'title' should be
   */
  getParentQuestionTitle(title: string) {
    if (!this.ncuaSvc.isParentQuestion(title)) {
      let endOfTitle = 6;
      // checks if the title is double digits ('Stmt 10' through 'Stmt 22')
      if (title.charAt(6) != '.') {
        endOfTitle = endOfTitle + 1;
      }
      return title.substring(0, endOfTitle);
    }
  }
  /**
   * checks if the question needs to appear
   */
  requiredQuestion(q: any) {
    if (this.questionsSvc.answerButtonLabel('ISE', q.answerText) == 'Unanswered' && q.maturityLevel == 'CORE+') {
      return false;
    }
    return true;
  }

  addExaminerFinding(title: any) {
    if (!this.examinerFindings.includes(title)) {
      this.examinerFindings.push(title);
    }
    this.examinerFindingsTotal++;
  }

  addDOR(title: any) {
    if (!this.dors.includes(title)) {
      this.dors.push(title);
    }
    this.dorsTotal = this.dorsTotal + 1;
  }

  addSupplementalFact(title: any) {
    if (!this.supplementalFacts.includes(title)) {
      this.supplementalFacts.push(title);
    }
    this.supplementalFactsTotal++;
  }

  addNonReportable(title: any) {
    if (!this.nonReportables.includes(title)) {
      this.nonReportables.push(title);
    }
    this.nonReportablesTotal++;
  }

  inCatStringBuilder(total: number, length: number, findingName: string) {
    let inCategory = '';
    if (total === 1) {
      inCategory = total + ' ' + findingName + ' was drafted in the following category:';
    } else if (total > 1 && length === 1) {
      inCategory = total + ' ' + findingName + 's were drafted in the following category:';
    } else if (total > 1 && length > 1) {
      inCategory = total + ' ' + findingName + 's were drafted in the following categories:';
    }

    return inCategory;
  }

  categoryBuilder(categories: string[]) {
    for (let i = 0; i < categories.length; i++) {
      this.summaryForCopy += '\n\t ' + categories[i];
    }
    this.summaryForCopy += '\n\n';
  }

  print() {
    window.print();
  }

  getChildQuestionNumber(title: string) {
    if (!this.ncuaSvc.isParentQuestion(title)) {
      let startOfNumber = title.indexOf('.') + 1;
      return title.substring(startOfNumber);
    }
  }

  checkShowActionItemMap(title: string, actionNum: number) {
    let array = this.showActionItemsMap.get(title);
    if (array.includes(actionNum.toString())) {
      return true;
    }
    return false;
  }

}