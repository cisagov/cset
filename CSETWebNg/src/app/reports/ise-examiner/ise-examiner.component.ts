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
import { AssessmentService } from '../../services/assessment.service';

@Component({
  selector: 'app-ise-examiner',
  templateUrl: './ise-examiner.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class IseExaminerComponent implements OnInit {
  response: any = {};

  hasComments: any[] = [];

  examLevel: string = '';

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    private titleService: Title,
    public acetSvc: ACETService,
    public configSvc: ConfigService,
    public ncuaSvc: NCUAService,
    public findSvc: FindingsService
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Examiner Report - ISE");

    this.acetSvc.getIseAnsweredQuestions().subscribe(
      (r: any) => {
        this.response = r;
        console.log(this.response);
        this.examLevel = this.response?.matAnsweredQuestions[0]?.assessmentFactors[0]?.components[0]?.questions[0]?.maturityLevel;

        for(let i = 0; i < this.response?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) { 
          let domain = this.response?.matAnsweredQuestions[0]?.assessmentFactors[i];
          // goes through subcategories
          for(let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];
            // goes through questions
            for(let k = 0; k < subcat?.questions?.length; k++) {
              let question = subcat?.questions[k];

              if(this.examLevel === 'CORE') {
                if (question.maturityLevel === 'CORE+' && question.answerText !== 'U') {
                  this.examLevel = 'CORE+';
                }
              }
              
              if (question.comments === 'Yes' && question.comment !== '') {
                this.hasComments.push(question);
                console.log(this.hasComments);
              }
            }
          }
        }
      },
      error => console.log('Assessment Answered Questions Error: ' + (<Error>error).message)
    );
  }
  
  /**
   * checks if the quesiton needs to appear
   */ 
  requiredQuestion(q: any) {
    if (q.answerText == 'U' && q.maturityLevel == 'CORE+') {
      return false;
    }
    return true;
  }

  /**
   * checks if q is a parent question
   */ 
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
    ||   q.title == 'Stmt 22') {
      return true;
    } 
    return false;
  }
  
}