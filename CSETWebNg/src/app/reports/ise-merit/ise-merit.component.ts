import { Component, OnInit} from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';
import { FindingsService } from '../../services/findings.service';
import { QuestionsService } from '../../services/questions.service';
import { forEach } from 'lodash';

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

  examinerFindings: string[] = [];
  examinerFindingsTotal: number = 0;
  examinerFindingsInCat: string = '';

  dors: string[] = [];
  dorsTotal: number = 0;
  dorsInCat: string = '';

  supplementalFacts: string[] = [];
  supplementalFactsTotal: number = 0;
  supplementalFactsInCat: string = '';

  subCategories: string[] = [];

  resultsOfReviewStatic: string = 'Performed review of the security program using the ISE Toolbox.';
  resultsOfReviewString: string = this.resultsOfReviewStatic + '\n\n';

  actionItemsMap: Map<number, any[]> = new Map<number, any[]>();
  regCitationsMap: Map<number, any[]> = new Map<number, any[]>();
  showActionItemsMap: Map<string, any[]> = new Map<string, any[]>(); //stores what action items to show (answered 'No')

  examLevel: string = '';

  // parentQuestions = new Set(["Stmt 1", "Stmt 2", "Stmt 3", "Stmt 4", "Stmt 5", "Stmt 6", "Stmt 7", 
  //                               "Stmt 8", "Stmt 9", "Stmt 10", "Stmt 11", "Stmt 12", "Stmt 13", "Stmt 14", 
  //                               "Stmt 15", "Stmt 16", "Stmt 17", "Stmt 18", "Stmt 19", "Stmt 20", "Stmt 21", 
  //                               "Stmt 22"]);

  constructor(
    public analysisSvc: ReportAnalysisService,
    public findSvc: FindingsService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    public acetSvc: ACETService,
    public questionsSvc: QuestionsService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("MERIT Scope Report - ISE");

    this.findSvc.GetAssessmentFindings().subscribe(
      (r: any) => {
        this.response = r;  
        console.log(this.response)
        this.translateExamLevel(this.response[0]?.question?.maturity_Level_Id);

        for(let i = 0; i < this.response?.length; i++) {
          let finding = this.response[i];
          if(finding.finding.type === 'Examiner Finding') {
            this.addExaminerFinding(finding.category.title);
          }
          if(finding.finding.type === 'DOR') {
            this.addDOR(finding.category.title);
          }
          if(finding.finding.type === 'Supplemental Fact') {
            this.addSupplementalFact(finding.category.title);
          }
        }

        this.resultsOfReviewString += this.inCatStringBuilder(this.examinerFindingsTotal, this.examinerFindings?.length, 'Examiner Finding');
        this.categoryBuilder(this.examinerFindings);

        this.resultsOfReviewString += this.inCatStringBuilder(this.dorsTotal, this.dors?.length, 'DOR');
        this.categoryBuilder(this.dors);

        this.resultsOfReviewString += this.inCatStringBuilder(this.supplementalFactsTotal, this.supplementalFacts?.length, 'Supplemental Fact');
        this.categoryBuilder(this.supplementalFacts);

      },
      error => console.log('MERIT Report Error: ' + (<Error>error).message)
    );

    this.acetSvc.getAssessmentInformation().subscribe(
      (r: any) => {
        this.demographics = r;
      },
      error => console.log('Assessment Information Error: ' + (<Error>error).message)
    )

    this.acetSvc.getIseAnsweredQuestions().subscribe(
      (r: any) => {
        this.answers = r;
        this.examLevel = this.answers?.matAnsweredQuestions[0]?.assessmentFactors[0]?.components[0]?.questions[0]?.maturityLevel;

        // goes through domains
        for(let i = 0; i < this.answers?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) { 
          let domain = this.answers?.matAnsweredQuestions[0]?.assessmentFactors[i];
          // goes through subcategories
          for(let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];
            // goes through questions
            let parentQuestionId = subcat?.questions[0].matQuestionId;
            for(let k = 0; k < subcat?.questions?.length; k++) {
              
              let question = subcat?.questions[k];
              if( k == 0 ){
                this.questionsSvc.getActionItems(question.matQuestionId).subscribe(
                  (r: any) => {
                    this.actionItemsForParent = r;
                    for(let m = 0; m < this.actionItemsForParent?.length; m++){
                      let parentAction = this.actionItemsForParent[m].action_Items;
                      let regCitation = this.actionItemsForParent[m].regulatory_Citation;

                      if(!this.actionItemsMap.has(question.matQuestionId)){
                        this.actionItemsMap.set(question.matQuestionId, [parentAction]);
                        this.regCitationsMap.set(question.matQuestionId, [regCitation]);
                      } else {
                        let tempActionArray = this.actionItemsMap.get(question.matQuestionId);
                        let tempCitationArray = this.regCitationsMap.get(question.matQuestionId);

                        tempActionArray.push(parentAction);
                        tempCitationArray.push(regCitation);

                        this.actionItemsMap.set(question.matQuestionId, tempActionArray);
                        this.regCitationsMap.set(question.matQuestionId, tempCitationArray);
                      }
                    }
                  }
                )
              }

              if (question.answerText == 'N') {
                let parentTitle = this.getParentQuestionTitle(question.title);

                if(!this.showActionItemsMap.has(parentTitle)){
                  this.showActionItemsMap.set(parentTitle, [this.getChildQuestionNumber(question.title)]);
                } else {
                  let tempShowActionArray = this.showActionItemsMap.get(parentTitle);

                  tempShowActionArray.push(this.getChildQuestionNumber(question.title));

                  this.showActionItemsMap.set(parentTitle, tempShowActionArray);
                }
              }
            
              if (question.maturityLevel === 'CORE+' && question.answerText !== 'U') {
                this.examLevel = 'CORE+';
              }

              // if(k == subcat?.questions?.length - 1 || (j == 0 && k == 9)) { //checks if the last child question
              //   if(j == 0 && k == 9) { //checks if in Stmt 1 or Stmt 2 (they're in the same subcat)
              //     parentQuestionId = subcat?.questions[k].matQuestionId;
              //   }
              //   console.log('called')
              //   this.removeUnusedActionItems(parentQuestionId, question.title)
              // }
            }
          }
        }
      },
    )

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
    this.examinerFindingsTotal ++;
  }

  addDOR(title: any) {
    if (!this.dors.includes(title)) {
      this.dors.push(title);
    }
    this.dorsTotal ++;
  }

  addSupplementalFact(title: any) {
    if (!this.supplementalFacts.includes(title)) {
      this.supplementalFacts.push(title);
    }
    this.supplementalFactsTotal ++;
  }

  translateExamLevel(examLevel: number) {
    if(examLevel === 17) {
      this.examLevel = 'SCUEP';
    } else if (examLevel === 18) {
      this.examLevel = 'CORE';
    } else {
      this.examLevel = 'Loading...';
    }
  }

  inCatStringBuilder(total: number, length: number, findingName: string) {
    let inCategory = '';
    if (total === 1) {
      inCategory = total + ' ' + findingName + ' was drafted in the following category:';
    } else if (total > 1 && length === 1) {
      inCategory = total +  ' ' + findingName + 's were drafted in the following category:';
    } else if (total > 1 && length > 1) {
      inCategory = total +  ' ' + findingName + 's were drafted in the following categories:';
    }

    return inCategory;
  }

  categoryBuilder(categories: string[]) {
    if(categories.length > 0) {
      for(let i = 0; i < categories.length; i++) {
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
    text = text.replace (/&#8221;/g, '');
    text = text.replace(/&#34;/g, '\'');
    text = text.replace(/&#167;/g, '');
    text = text.replace('ISE Reference', '');
    text = text.replace('/\s/g', ' ');
    return (text);
  }

  isParentQuestion(q: any) {
    if ( q.title == 'Stmt 1' 
    ||   q.title == 'Stmt 2'
    ||   q.title == 'Stmt 3'
    ||   q.title == 'Stmt 4'
    ||   q.title == 'Stmt 5'
    ||   q.title == 'Stmt 6'
    ||   q.title == 'Stmt 7'
    ||   q.title == 'Stmt 8'
    ||   q.title == 'Stmt 9'
    ||   q.title == 'Stmt 10'
    ||   q.title == 'Stmt 11'
    ||   q.title == 'Stmt 12'
    ||   q.title == 'Stmt 13'
    ||   q.title == 'Stmt 14'
    ||   q.title == 'Stmt 15'
    ||   q.title == 'Stmt 16'
    ||   q.title == 'Stmt 17'
    ||   q.title == 'Stmt 18'
    ||   q.title == 'Stmt 19'
    ||   q.title == 'Stmt 20'
    ||   q.title == 'Stmt 21'
    ||   q.title == 'Stmt 22'
    ||   q.title == 'Stmt 23') {
      return true;
    } 
    return false;
  }

  getParentQuestionTitle(title: string) {
    if(!this.isParentQuestion(title)) {
      let endOfTitle = title.indexOf('.');
      return title.substring(0, endOfTitle);
    }
  }

  getChildQuestionNumber(title: string) {
    if(!this.isParentQuestion(title)) {
      let startOfNumber = title.indexOf('.') + 1;
      return title.substring(startOfNumber);
    }
  }

  copyAllActionItems(input: any, title: string) {
    let combinedItems = input.toString();
    let array = combinedItems.split(".,");

    for (let i = 0; i < array.length; i++) {
      let count = i+1;
      if(this.checkShowActionItemMap(title, count)) {
        // console.log('i: ' + i + '\n')
        // console.log('count: ' + count + '\n')
        // console.log('array[i]: ' + array[i] + '\n')

	      array[i] = count + ": " + array[i] + "\n";
      } else {
        array[i] = "";
      }
    }
    let formattedItems = array.join("");
    return formattedItems;
  }

  checkShowActionItemMap(title: string, actionNum: number) {
    let array = this.showActionItemsMap.get(title);
    if(array != null && array.includes(actionNum.toString())){
      return true;
    }
    return false;
  }

  // removeUnusedActionItems(id: number, title: string) {
  //   console.log('title: ' + title)

  //   console.log('id: ' + id)

  //   if(this.actionItemsMap.has(id)) {
  //     let prevActionItemsArray = this.actionItemsMap.get(id);
  //     console.log('inside actionItemsMap')
  //     let showActionItemsArray = this.showActionItemsMap.get(this.getParentQuestionTitle(title));

  //     if(prevActionItemsArray.length !== showActionItemsArray.length) {
  //       let newActionItemsArray = [];

  //       for(let i = 0; i < prevActionItemsArray.length; i++) {
  //         if(showActionItemsArray.includes(i + 1)) {
  //           newActionItemsArray.push([prevActionItemsArray[i]]);
  //         }
  //       }
  //       console.log('before removal' + prevActionItemsArray)
  //       console.log('after removal' + newActionItemsArray)

  //       this.actionItemsMap.set(id, newActionItemsArray);
  //     }
  //   }
  // }

}
