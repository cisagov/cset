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
import { Component, OnInit } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';
import { ObservationsService } from '../../services/observations.service';
import { QuestionsService } from '../../services/questions.service';
import { NCUAService } from '../../services/ncua.service';

@Component({
  selector: 'app-ise-merit',
  templateUrl: './ise-merit.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss', '../../../assets/sass/cset-font-styles.css']
})
export class IseMeritComponent implements OnInit {
  response: any = null;
  demographics: any = null;
  answers: any = null;
  actionItemsForParent: any = null;
  files: any = null;
  actionData: any = null;

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

  subCategories: string[] = [];

  resultsOfReviewStatic: string = 'Performed review of the security program using the ISE Toolbox.';
  resultsOfReviewString: string = this.resultsOfReviewStatic + '\n\n';

  masterActionItemsMap: Map<number, any[]> = new Map<number, any[]>();

  // actionItemsMap: Map<number, Map<number, any[]>> = new Map<number, Map<number, any[]>>();
  //                 finding_Id, <question_Id, [action_Items]>
  // manualOrAutoMap: Map<number, string> = new Map<number, string>();

  sourceFilesMap: Map<number, any[]> = new Map<number, any[]>();
  regCitationsMap: Map<number, any[]> = new Map<number, any[]>();
  showActionItemsMap: Map<string, any[]> = new Map<string, any[]>(); //stores what action items to show (answered 'No')

  examLevel: string = '';

  relaventIssues: boolean = false;
  loadingCounter: number = 0;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public observationSvc: ObservationsService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    public acetSvc: ACETService,
    public ncuaSvc: NCUAService,
    public questionsSvc: QuestionsService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("MERIT Scope Report - ISE");

    this.acetSvc.getIseAnsweredQuestions().subscribe(
      (r: any) => {
        this.answers = r;
        this.examLevel = this.answers?.matAnsweredQuestions[0]?.assessmentFactors[0]?.components[0]?.questions[0]?.maturityLevel;

        // goes through domains
        for (let i = 0; i < this.answers?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) {
          let domain = this.answers?.matAnsweredQuestions[0]?.assessmentFactors[i];
          // goes through subcategories
          for (let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];
            // goes through questions
            for (let k = 0; k < subcat?.questions?.length; k++) {

              let question = subcat?.questions[k];
              if (question.maturityLevel === 'CORE+' && question.answerText !== 'U') {
                this.examLevel = 'CORE+';
              }

            }
          }
        }

        let examLevelString = this.examLevel.substring(0, 4);

        this.acetSvc.getActionItemsReport(this.ncuaSvc.translateExamLevelToInt(examLevelString)).subscribe((findingData: any) => {
          this.actionData = findingData;
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
          this.loadingCounter++;

        });

        this.loadingCounter++;

        this.acetSvc.getAssessmentInformation().subscribe(
          (r: any) => {
            this.demographics = r;

            this.loadingCounter++;
          },
          error => console.log('Assessment Information Error: ' + (<Error>error).message)
        )

        this.observationSvc.getAssessmentObservations().subscribe(
          (r: any) => {
            this.response = r;

            for (let i = 0; i < this.response?.length; i++) {
              if (this.ncuaSvc.translateExamLevel(this.response[i]?.question?.maturity_Level_Id).substring(0, 4) == this.examLevel.substring(0, 4)) {

                let observation = this.response[i];
                this.questionsSvc.getDetails(observation.question.mat_Question_Id, 'Maturity').subscribe(
                  (r: any) => {
                    this.files = r;

                    let sourceDocList = this.files?.listTabs[0]?.sourceDocumentsList;

                    for (let i = 0; i < sourceDocList?.length; i++) {
                      if (!this.sourceFilesMap.has(observation.finding.finding_Id)) {

                        this.sourceFilesMap.set(observation.finding.finding_Id, [sourceDocList[i]]);
                      } else {
                        let tempFileArray = this.sourceFilesMap.get(observation.finding.finding_Id);

                        tempFileArray.push(sourceDocList[i]);

                        this.sourceFilesMap.set(observation.finding.finding_Id, tempFileArray);
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

              this.resultsOfReviewString += this.inCatStringBuilder(this.dorsTotal, this.dors?.length, 'DOR');
              this.categoryBuilder(this.dors);

              this.resultsOfReviewString += this.inCatStringBuilder(this.examinerFindingsTotal, this.examinerFindings?.length, 'Examiner Finding');
              this.categoryBuilder(this.examinerFindings);

              this.resultsOfReviewString += this.inCatStringBuilder(this.supplementalFactsTotal, this.supplementalFacts?.length, 'Supplemental Fact');
              this.categoryBuilder(this.supplementalFacts);

              this.resultsOfReviewString += this.inCatStringBuilder(this.nonReportablesTotal, this.nonReportables?.length, 'Non-reportable');
              this.categoryBuilder(this.nonReportables);
            } else {
              this.resultsOfReviewString += 'No Issues were noted.';
            }

            this.loadingCounter++;
          },
          error => console.log('MERIT Report Error: ' + (<Error>error).message)
        );
      });



    // this.acetSvc.getIseSourceFiles().subscribe(
    //   (r: any) => {
    //     this.files = r;
    //     console.log(r)
    //   },
    //   error => console.log('Assessment Information Error: ' + (<Error>error).message)
    // )
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
    this.dorsTotal++;
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
    if (categories.length > 0) {
      for (let i = 0; i < categories.length; i++) {
        this.resultsOfReviewString += '\n\t ' + categories[i];
      }
      this.resultsOfReviewString += '\n\n';
    }
  }

  // gets rid of the html formatting
  cleanText(input: string) {
    let text = input;
    text = text.replace(/<.*?>/g, '');
    text = text.replace(/&#10;/g, ' ');
    text = text.replace(/&#8217;/g, '\'');
    text = text.replace(/&#160;/g, '');
    text = text.replace(/&#8221;/g, '');
    text = text.replace(/&#34;/g, '\'');
    text = text.replace(/&#167;/g, '');
    text = text.replace(/&#8211;/g, '');
    text = text.replace('ISE Reference', '');
    text = text.replace('/\s/g', ' ');
    return (text);
  }



  getParentQuestionTitle(title: string) {
    if (!this.ncuaSvc.isParentQuestion(title)) {
      let endOfTitle = title.indexOf('.');
      return title.substring(0, endOfTitle);
    }
  }

  getChildQuestionNumber(title: string) {
    if (!this.ncuaSvc.isParentQuestion(title)) {
      let startOfNumber = title.indexOf('.') + 1;
      return title.substring(startOfNumber);
    }
  }

  copyAllActionItems(allActionsInFinding: any) {
    let actionItems = [];
    let questionTitle = [];
    if (allActionsInFinding != null) {
      for (let i = 0; i < allActionsInFinding?.length; i++) {
        if (allActionsInFinding[i].action_Items.substring(allActionsInFinding[i].action_Items.length - 1) != '.') {
          allActionsInFinding[i].action_Items = allActionsInFinding[i].action_Items + '.';
        }
        actionItems.push(allActionsInFinding[i].action_Items);
        questionTitle.push(allActionsInFinding[i].question_Title);
      }

      let combinedItems = actionItems.toString();
      let array = combinedItems.split('.,');

      for (let i = 0; i < allActionsInFinding.length; i++) {
        let childNumber = this.getChildQuestionNumber(questionTitle[i]);
        if (array[i] != null && array[i] != '') {
          array[i] = childNumber + ": " + array[i] + "\n";
        }
      }
      if (array?.length == 0) {
        return "(no Action Items available)";
      }

      let formattedItems = array.join("");
      return formattedItems;
    }
  }

  areAllActionItemsBlank(allActionsInFinding: any) {
    if (allActionsInFinding != null) {
      for (let i = 0; i < allActionsInFinding?.length; i++) {

        if (allActionsInFinding[i].action_Items != null && allActionsInFinding[i].action_Items != '') {
          return false;
        }
      }
      return true;

    }
  }

  copyAllSourceFiles(id: number) {
    if (this.sourceFilesMap.has(id)) {
      let copyString = '';
      let allSourceFiles = this.sourceFilesMap.get(id);
      for (let i = 0; i < allSourceFiles.length; i++) {
        copyString += allSourceFiles[i].title + ' (Section: ' + allSourceFiles[i].sectionRef + ')\n'
      }
      return copyString;
    } else {
      return '(no Source Files available)';
    }
  }
}
