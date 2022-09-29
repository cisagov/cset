////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewChecked, AfterViewInit, ViewChild } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';
import { ConfigService } from '../../services/config.service';
import { NCUAService } from '../../services/ncua.service';
import { GroupingDescriptionComponent } from '../../assessment/questions/grouping-description/grouping-description.component';
import { FindingsService } from '../../services/findings.service';

@Component({
  selector: 'app-ise-examination',
  templateUrl: './ise-examination.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class IseExaminationComponent implements OnInit {
  response: any = {};
  findingsResponse: any = {};
  expandedOptions: Map<String, boolean> = new Map<String, boolean>();

  examinerFindings: string[] = [];
  dors: string[] = [];
  supplementalFacts: string[] = [];

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public acetSvc: ACETService,
    public configSvc: ConfigService,
    public ncuaSvc: NCUAService,
    public findSvc: FindingsService
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Examination Report - ISE");

    this.acetSvc.getIseAnsweredQuestions().subscribe(
      (r: any) => {
        this.response = r;
        console.log(this.response);
      },
      error => console.log('Assessment Information Error: ' + (<Error>error).message)
    );

    this.findSvc.GetAssessmentFindings().subscribe(
      (f: any) => {
        this.findingsResponse = f;  

        for(let i = 0; i < this.findingsResponse?.length; i++) {
          let finding = this.findingsResponse[i];
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

    // initializing all assessment factors / categories / parent questions to false
    // used in checking if the section / question should be expanded or collapsed 
    this.expandedOptions
      .set('Information Security Program', false)       .set('Governance', false)
      .set('Risk Assessment', false)                    .set('Incident Response', false)
      .set('Technology Service Providers', false)       .set('Business Continuity / Disaster Recovery', false)
      .set('Cybersecurity Controls', false)             .set('Information Security Program', false)
      .set('Controls Testing', false)                   .set('Corrective Actions', false)
      .set('Training', false)                           .set('Vulnerability & Patch Management', false)
      .set('Anti-Virus/Anti-Malware', false)            .set('Access Controls', false)
      .set('Network Security', false)                   .set('Data Leakage Protection', false)
      .set('Change & Configuration Management', false)  .set('Monitoring', false)
      .set('Logging', false)                            .set('Data Governance', false)
      .set('Conversion', false)                         .set('Software Development Process', false)
      .set('Internal Audit Program', false)             .set('Stmt 1', false)
      .set('Stmt 2', false)                             .set('Stmt 3', false)
      .set('Stmt 4', false)                             .set('Stmt 5', false)
      .set('Stmt 6', false)                             .set('Stmt 7', false)
      .set('Stmt 8', false)                             .set('Stmt 9', false)
      .set('Stmt 10', false)                            .set('Stmt 11', false)
      .set('Stmt 12', false)                            .set('Stmt 13', false)
      .set('Stmt 14', false)                            .set('Stmt 15', false)
      .set('Stmt 16', false)                            .set('Stmt 17', false)
      .set('Stmt 18', false)                            .set('Stmt 19', false)
      .set('Stmt 20', false)                            .set('Stmt 21', false)
      .set('Stmt 22', false);
  }

  /**
   * Flips the 'expand' boolean value based off the given 'title' key
   */
  toggleExpansion(title: string) {
    let extend = this.expandedOptions.get(title);
    this.expandedOptions.set(title, !extend);
    return extend;
  }
  /**
   * checks if section should expand by checking the boolean value attached to the 'title'
   */
  shouldExpand(title: string) {
    if(this.expandedOptions.get(title)) {
      return true;
    }
    return false;
  }
  /**
   * checks if q is a parent question
   */ 
  isParentQuestion(q: any) {
    if ( this.requiredQuestion(q)
    &&   q.title == 'Stmt 1' 
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
    ||   q.title == 'Stmt 16') {
      return true;
    } 
    return false;
  }
  /**
   * trims the '.<#>' off the given 'title', leaving what the parent 'title' should be
   */ 
  getParentQuestionTitle(title: string) {
    if(!this.isParentQuestion(title)) {
      // console.log(title.substring(0, 6));
      return title.substring(0, 6);
    }
  }
  /**
   * checks if the quesiton needs to appear
   */ 
  requiredQuestion(q: any) {
    if (this.configSvc.answerLabels[q.answerText] == 'Unanswered' && q.maturityLevel == 'CORE+') {
      return false;
    }
    return true;
  }
  
}