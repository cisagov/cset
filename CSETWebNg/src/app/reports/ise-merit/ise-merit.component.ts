import { Component, OnInit} from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';
import { FindingsService } from '../../services/findings.service';

@Component({
  selector: 'app-ise-merit',
  templateUrl: './ise-merit.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class IseMeritComponent implements OnInit {
  response: any = null; 
  demographics: any = null; 

  examinerFindings: string[] = [];
  examinerFindingsTotal: number = 0;

  dors: string[] = [];
  dorsTotal: number = 0;

  supplementalFacts: string[] = [];
  supplementalFactsTotal: number = 0;


  subCategories: string[] = [];

  previousIssue: any = null;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public findSvc: FindingsService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    public acetSvc: ACETService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("MERIT Scope Report - ISE");

    this.findSvc.GetAssessmentFindings().subscribe(
      (r: any) => {
        this.response = r;  

        for(let i = 0; i < this.response?.length; i++) {
          let finding = this.response[i];
          if(finding.finding.type === 'Examiner Finding') {
            this.addExaminerFinding(finding.category.title);
          }
          if(finding.finding.type === 'DOR') {
            this.addDOR(finding.category.title);
          }
          if(finding.finding.type === 'Supplemental Fact') {
            console.log(i);
            this.addSupplementalFact(finding.category.title);
          }
        }
      },
      error => console.log('MERIT Report Error: ' + (<Error>error).message)
    );

    this.acetSvc.getAssessmentInformation().subscribe(
      (r: any) => {
        this.demographics = r;
        console.log(this.response);
      },
      error => console.log('Assessment Information Error: ' + (<Error>error).message)
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
    console.log(title + 'here');
    if (!this.supplementalFacts.includes(title)) {
      console.log(title);
      this.supplementalFacts.push(title);
    }
    this.supplementalFactsTotal ++;
  }

}
