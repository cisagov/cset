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
import { ACETService } from '../../services/acet.service';
import { ConfigService } from '../../services/config.service';
import { NCUAService } from '../../services/ncua.service';
import { GroupingDescriptionComponent } from '../../assessment/questions/grouping-description/grouping-description.component';
import { ObservationsService } from '../../services/observations.service';
import { AssessmentService } from '../../services/assessment.service';
import { VersionService } from '../../services/version.service';


@Component({
  selector: 'app-ise-data',
  templateUrl: './ise-data.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class IseDataComponent implements OnInit {
  response: any = {};

  expandedOptions: Map<String, boolean> = new Map<String, boolean>();

  fileName: string = '';
  examLevel: string = '';

  versionName: string;

  currentDate: any;

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    private titleService: Title,
    public acetSvc: ACETService,
    public configSvc: ConfigService,
    public ncuaSvc: NCUAService,
    public observationSvc: ObservationsService, 
    public versionSvc: VersionService
  ) {  this.versionSvc.localVersionObservable$.subscribe(localVersion => {
    this.versionName = localVersion;
  });}

  ngOnInit(): void {
    this.titleService.setTitle("Data Report - ISE");

    this.acetSvc.getIseAnsweredQuestions().subscribe(
      (r: any) => {
        this.response = r;
        this.examLevel = this.response?.matAnsweredQuestions[0]?.assessmentFactors[0]?.components[0]?.questions[0]?.maturityLevel;
        if (this.examLevel === 'CORE') {
          for (let i = 0; i < this.response?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) {
            let domain = this.response?.matAnsweredQuestions[0]?.assessmentFactors[i];
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
        }
      },
      error => console.log('Assessment Answered Questions Error: ' + (<Error>error).message)
    );

    this.currentDate = new Date();

    // initializing all assessment factors / categories / parent questions to true (expanded)
    // used in checking if the section / question should be expanded or collapsed 
    this.expandedOptions
      .set('Stmt 1', true)
      .set('Stmt 2', true).set('Stmt 3', true)
      .set('Stmt 4', true).set('Stmt 5', true)
      .set('Stmt 6', true).set('Stmt 7', true)
      .set('Stmt 8', true).set('Stmt 9', true)
      .set('Stmt 10', true).set('Stmt 11', true)
      .set('Stmt 12', true).set('Stmt 13', true)
      .set('Stmt 14', true).set('Stmt 15', true)
      .set('Stmt 16', true).set('Stmt 17', true)
      .set('Stmt 18', true).set('Stmt 19', true)
      .set('Stmt 20', true).set('Stmt 21', true)
      .set('Stmt 22', true);

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
   * checks if q is a parent question
   */
  isParentQuestion(q: any) {
    if (q.title == 'Stmt 1'
      || q.title == 'Stmt 2'
      || q.title == 'Stmt 3'
      || q.title == 'Stmt 4'
      || q.title == 'Stmt 5'
      || q.title == 'Stmt 6'
      || q.title == 'Stmt 7'
      || q.title == 'Stmt 8'
      || q.title == 'Stmt 9'
      || q.title == 'Stmt 10'
      || q.title == 'Stmt 11'
      || q.title == 'Stmt 12'
      || q.title == 'Stmt 13'
      || q.title == 'Stmt 14'
      || q.title == 'Stmt 15'
      || q.title == 'Stmt 16'
      || q.title == 'Stmt 17'
      || q.title == 'Stmt 18'
      || q.title == 'Stmt 19'
      || q.title == 'Stmt 20'
      || q.title == 'Stmt 21'
      || q.title == 'Stmt 22') {
      return true;
    }
    return false;
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
   * translates the answer to the numerical format wanted in the CSV
   */
  answerToNumber(answerText: string) {
    switch (answerText) {
      case ('N'):
        return 0;
      case ('Y'):
        return 1;
      case ('U'):
        return 2;
    }
  }

  replaceSpaces(name: string) {
    if (name !== null && name !== undefined) {
      return name.replace(/ /g, '_');
    }
  }

}