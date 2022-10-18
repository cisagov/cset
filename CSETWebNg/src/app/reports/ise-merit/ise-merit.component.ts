import { Component, OnInit} from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';
import { FindingsService } from '../../services/findings.service';
import { StylesheetMap } from '@angular/flex-layout';
// import { MatTooltipModule } from '@angular/material/tooltip';

@Component({
  selector: 'app-ise-merit',
  templateUrl: './ise-merit.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss', '../../../assets/sass/cset-font-styles.css']
})
export class IseMeritComponent implements OnInit {
  response: any = null; 
  demographics: any = null; 
  answers: any = null;

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

  actionItemExample1: string = '1.	The security program must be approved by the Board of Directors.';
  actionItemExample2: string = '2.	Strengthen the security program policies to include critical controls, activities, requirements, and expectations the credit union intends to perform, monitor, manage, and report.';
  actionItemAll: string = this.actionItemExample1 + '\n' + this.actionItemExample2;

  examLevel: string = '';


  constructor(
    public analysisSvc: ReportAnalysisService,
    public findSvc: FindingsService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    public acetSvc: ACETService,
    // public tooltip: MatTooltipModule,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("MERIT Scope Report - ISE");

    this.findSvc.GetAssessmentFindings().subscribe(
      (r: any) => {
        this.response = r;  
        console.log(this.response);
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
        console.log(this.answers);
        this.examLevel = this.answers?.matAnsweredQuestions[0]?.assessmentFactors[0]?.components[0]?.questions[0]?.maturityLevel;

        if(this.examLevel === 'CORE') {
          // goes through domains
          for(let i = 0; i < this.answers?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) { 
            let domain = this.answers?.matAnsweredQuestions[0]?.assessmentFactors[i];
            // goes through subcategories
            for(let j = 0; j < domain.components?.length; j++) {
              let subcat = domain?.components[j];
              // goes through questions
              for(let k = 0; k < subcat?.questions?.length; k++) {
                let question = subcat?.questions[k];

                if (question.maturityLevel === 'CORE+' && question.answerText !== 'U') {
                  this.examLevel = 'CORE+';
                }
              }
            }
          }
        }
      },
    )

    // console.log('length is: ' + this.response?.length);

    // for(let i = 0; i < this.response?.length; i++) {
    //   console.log(this.response + ' this.response thing');
    //   let finding = this.response[i];
    //   console.log(finding + ' finding thing');
    // }
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
    this.dorsTotal = this.dorsTotal + 1;
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
      this.examLevel = 'Unknown';
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
    for(let i = 0; i < categories.length; i++) {
      this.resultsOfReviewString += '\n\t ' + categories[i];
    }
    this.resultsOfReviewString += '\n\n';
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

}
