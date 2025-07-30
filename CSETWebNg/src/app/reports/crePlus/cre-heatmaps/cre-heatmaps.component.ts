////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { AssessmentService } from '../../../services/assessment.service';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@jsverse/transloco';
import { Title } from '@angular/platform-browser';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-cre-heatmaps',
  templateUrl: './cre-heatmaps.component.html',
  styleUrls: ['../../reports.scss', './cre-heatmaps.component.scss'],
  standalone: false,
})
export class CreHeatmapsComponent implements OnInit {

  title: string;
  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;


  model22;
  model23;
  model24;



  constructor(
    public assessSvc: AssessmentService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService,
    public titleService: Title,
    public route: ActivatedRoute
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    setTimeout(() => {
      this.title = this.tSvc.translate('reports.core.cre.heatmap report.title');
      this.titleService.setTitle(this.title);
    }, 500);

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;
    });

    this.reportSvc.getModelContent('22').subscribe((x) => {
      this.model22 = x;
      this.consolidateQuestions(this.model22);
    });
    this.reportSvc.getModelContent('23').subscribe((x) => {
      this.model23 = x;
      this.consolidateQuestions(this.model23);
    });
    this.reportSvc.getModelContent('24').subscribe((x) => {
      this.model24 = x;
      this.consolidateQuestions(this.model24);
    });
  }


  /**
   * Lumps questions from goals into a domain-level collection
   */
  consolidateQuestions(model: any) {
    for (let domain of model.groupings) {
      domain.consolidatedQuestions = [];
      for (let sg of domain.groupings) {
        for (let q of sg.questions) {
          domain.consolidatedQuestions.push(q);
          q.displayNumberShort = this.parseQNumber(q.displayNumber);
        }
      }
    }
  }

  parseQNumber(title: string) {
    const dotIdx = title.lastIndexOf('.') + 1;
    return 'Q' + title.substring(dotIdx);
  }


  /**
  * Sets the coloring of a cell based on its answer.
  * @param answer 
  */
  answerCellClass(answer: string) {
    switch (answer) {
      case 'Y':
        return 'green-score';
      case 'I':
        return 'blue-score';
      case 'S':
        return 'gold-score';
      case 'N':
        return 'red-score';
      case 'U':
        return 'light-gray-score';
      case null:
        return 'default-score';
    }
  }

}
