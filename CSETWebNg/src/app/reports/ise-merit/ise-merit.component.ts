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
  workPerformed: boolean = null;
  resultsOfReviewText: string = null;

  examinerFindings: string[] = [];
  dors: string[] = [];
  supplementalFacts: string[] = [];

  constructor(
    public analysisSvc: ReportAnalysisService,
    public findSvc: FindingsService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("MERIT Scope Report - ISE");

    this.findSvc.GetAssessmentFindings().subscribe(
      (r: any) => {
        this.response = r;  
        console.log(this.response); 

        console.log('length is: ' + this.response?.length);
        for(let i = 0; i < this.response?.length; i++) {
          let finding = this.response[i];
          if(finding.finding.type === 'Examiner Finding') {
            this.examinerFindings.push(finding.category.title);
          }
          if(finding.finding.type === 'DOR') {
            this.dors.push(finding.category.title);
          }
          if(finding.finding.type === 'Supplemental Fact') {
            this.supplementalFacts.push(finding.category.title);
          }
        }
      },
      error => console.log('MERIT Report Error: ' + (<Error>error).message)
    );

    // console.log('length is: ' + this.response?.length);

    // for(let i = 0; i < this.response?.length; i++) {
    //   console.log(this.response + ' this.response thing');
    //   let finding = this.response[i];
    //   console.log(finding + ' finding thing');
    // }
  }

  addExaminerFinding(finding: any) {
    this.examinerFindings.push(finding.category.title);
  }

  addDOR(finding: any) {
    this.dors.push(finding.category.title);
  }

  addSupplementalFact(finding: any) {
    this.supplementalFacts.push(finding.category.title);
  }

  wastedSpace(){
    return;
  }


}
