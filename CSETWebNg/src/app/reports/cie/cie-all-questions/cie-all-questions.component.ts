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
import { ReportService } from '../../../services/report.service';
import { ACETService } from '../../../services/acet.service';
import { ConfigService } from '../../../services/config.service';
import { NCUAService } from '../../../services/ncua.service';
import { GroupingDescriptionComponent } from '../../../assessment/questions/grouping-description/grouping-description.component';
import { ObservationsService } from '../../../services/observations.service';
import { AssessmentService } from '../../../services/assessment.service';
import { QuestionsService } from '../../../services/questions.service';
import { CieService } from '../../../services/cie.service';
@Component({
  selector: 'app-cie-all-questions',
  templateUrl: './cie-all-questions.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss', './cie-all-questions.component.scss']
})
export class CieAllQuestionsComponent {

  response: any = {};

  hasComments: any[] = [];
  showSubcats: Map<String, boolean> = new Map<String, boolean>();
  expandedOptions: Map<String, boolean> = new Map<String, boolean>();

  examLevel: string = '';
  loading: boolean = true;

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    private titleService: Title,
    public cieSvc: CieService,
    public configSvc: ConfigService,
    public observationSvc: ObservationsService
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Export All CIE-CSET - Report");

    
    this.cieSvc.getCieAllQuestions().subscribe(
      (r: any) => {
        this.response = r;
        console.log(this.response)
        // this.examLevel = this.response?.matAnsweredQuestions[0]?.assessmentFactors[0]?.components[0]?.questions[0]?.maturityLevel;

        // goes through domains
        for (let i = 0; i < this.response?.matAnsweredQuestions[0]?.assessmentFactors?.length; i++) {
          let domain = this.response?.matAnsweredQuestions[0]?.assessmentFactors[i];
          // goes through subcategories
          for (let j = 0; j < domain.components?.length; j++) {
            let subcat = domain?.components[j];
            this.expandedOptions.set(domain?.title + '_' + subcat?.title, false);

            this.showSubcats.set(domain?.title + '_' + subcat?.title, true);
            // goes through questions
            for (let k = 0; k < subcat?.questions?.length; k++) {
              let question = subcat?.questions[k];

              //if (question.maturityLevel === 'CORE+' && this.requiredQuestion(question)) {
                this.expandedOptions.set(domain?.title + '_' + subcat?.title, false);

                this.showSubcats.set(domain?.title + '_' + subcat?.title, true);
              //}
            }
          }
        }

        this.loading = false;
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

  getClasses(q: any, top: boolean) {
    let combinedClass = '';
    if (q.title.length == 10 || q.title.charAt(q.title.length - 1) == '0') {
      combinedClass = 'background-3 ';
    }

    if (top) {
      if (q.freeResponseText == null) {
        combinedClass += 'full-border ';
      }
      else {
        combinedClass += 'top-half-border';
      }
    }
    else{
      combinedClass += 'bottom-half-border';
    }
    console.log(combinedClass)
    return combinedClass;
  }
}