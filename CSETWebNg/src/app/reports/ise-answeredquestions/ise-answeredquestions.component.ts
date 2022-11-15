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
import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';
import { ACETService } from '../../services/acet.service';
import { ConfigService } from '../../services/config.service';
import { NCUAService } from '../../services/ncua.service';
import { QuestionsService } from '../../services/questions.service';

@Component({
  selector: 'app-ise-answeredquestions',
  templateUrl: './ise-answeredquestions.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class IseAnsweredQuestionsComponent implements OnInit {
  response: any = {};

  showSubcats: Map<String, boolean> = new Map<String, boolean>();

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public acetSvc: ACETService,
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
    public ncuaSvc: NCUAService
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Answered Statements Report - ISE");

    this.acetSvc.getIseAnsweredQuestions().subscribe(
      (r: any) => {
        this.response = r;

        // goes through domains
        for(let i = 0; i < this.response?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) { 
          let domain = this.response?.matAnsweredQuestions[0]?.assessmentFactors[i];
          // goes through subcategories
          for(let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];
            // goes through questions
            for(let k = 0; k < subcat?.questions?.length; k++) {
              let question = subcat?.questions[k];

              if (question.maturityLevel === 'CORE+' && this.requiredQuestion(question)) {
                this.showSubcats.set(subcat?.title, true);
              }
            }
          }
        }
        
      },
      error => console.log('Assessment Information Error: ' + (<Error>error).message)
    );

    this.showSubcats
    .set('Information Security Program', true)       .set('Governance', true)
    .set('Risk Assessment', true)                    .set('Incident Response', true)
    .set('Technology Service Providers', true)       .set('Business Continuity / Disaster Recovery', true)
    .set('Cybersecurity Controls', true)             .set('Information Security Program', true)
    .set('Controls Testing', true)                   .set('Corrective Actions', true)
    .set('Training', true)                           .set('Vulnerability & Patch Management', true)
    .set('Anti-Virus/Anti-Malware', true)            .set('Access Controls', true)
    .set('Network Security', true)                   .set('Data Leakage Protection', true)
    .set('Change & Configuration Management', true)  .set('Monitoring', false)
    .set('Logging', false)                            .set('Data Governance', false)
    .set('Conversion', false)                         .set('Software Development Process', false)
    .set('Internal Audit Program', false)             .set('Asset Inventory', true)
    .set('Policies & Procedures', true);
  }

  requiredQuestion(q: any) {
    if (q.answerText == 'U' && q.maturityLevel == 'CORE+') {
      return false;
    }
    return true;
  }

  parentQuestion(q: any) {
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
  
}