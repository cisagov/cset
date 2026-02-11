////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Component, Input } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { MaturityService } from '../../../services/maturity.service';
import { TranslocoService } from '@jsverse/transloco';
import { TypescriptDefaultsService } from '@ngstack/code-editor';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { AssessmentDetail } from '../../../models/assessment-info.model';

@Component({
  selector: 'app-cmmc2-scorecard-report',
  templateUrl: './cmmc2-scorecard-report.component.html',
  styleUrls: ['../../../reports/reports.scss'],
  standalone: false,
    // eslint-disable-next-line
    host: {
      'class': 'force-light-mode',
      '[attr.data-theme]': '"light"',
      '[attr.data-bs-theme]': '"light"'
    }
})
export class Cmmc2ScorecardReportComponent {

  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;

  @Input()
  scorecards: any[];
  response: AssessmentDetail;
  targetLevel: number;

  /**
   * 
   */
  constructor(
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public tSvc: TranslocoService,
    public titleService: Title,
    public configSvc: ConfigService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.tSvc.selectTranslate('scorecard report', {}, { scope: 'reports' })
      .subscribe(title => {
        this.titleService.setTitle(title + ' - ' + this.configSvc.behaviors.defaultTitle)
      });

    this.assessSvc.getAssessmentDetail().subscribe(
      (r: AssessmentDetail) => {
        this.response = r;
      }
    );

    this.maturitySvc.getCmmcScorecards().subscribe((x: any) => {
      this.targetLevel = x.targetLevel;
      this.scorecards = x.levelScorecards;
    });
  }

  /**
   * 
   */
  scorecardForLevel(l: number) {
    return this.scorecards?.find(x => x.level == l);
  }

  /**
   * 
   */
  printReport() {
    window.print();
  }
}
