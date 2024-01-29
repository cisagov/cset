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
import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../services/maturity.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-edm-perf-summ-all-mil',
  templateUrl: './edm-perf-summ-all-mil.component.html',
  styleUrls: ['./edm-perf-summ-all-mil.component.scss', '../../reports.scss']
})
export class EdmPerfSummAllMilComponent implements OnInit, OnChanges {

  @Input()
  domains: any[];

  scores: any[];

  domainMil: any;

  constructor(
    private maturitySvc: MaturityService,
    public reportSvc: ReportService
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.maturitySvc.getEdmScores('MIL').subscribe(
      (r: any) => {
        this.scores = r;
      },
      error => console.log('RF Error: ' + (<Error>error).message)
    );
  }

  /**
   * 
   */
  ngOnChanges(): void {
    if (!!this.domains) {
      this.domainMil = this.domains.find(x => x.abbreviation == 'MIL');
    }
  }

  /**
   * Returns the question text for a MIL question.
   * @param mil 
   * @param qNum 
   */
  getText(mil: string, qNum: string): string {
    const goal = this.domainMil?.subGroupings.find(x => x.title.startsWith(mil));
    const q = goal?.questions.find(x => x.displayNumber == mil + '.' + qNum);
    return this.reportSvc.scrubGlossaryMarkup(q?.questionText);
  }

  /**
   * Returns the CSS class for the question's score.
   * @param mil 
   * @param qNum 
   */
  scoreClass(mil: string, qNum: string): string {
    if (!this.scores) {
      return '';
    }

    const p = this.scores.find(s => s.parent.title_Id == mil);
    if (p != null) {
      if (qNum == '') {
        return this.colorToClass(p.parent.color);
      }

      const q = p.children.find(c => c.title_Id == qNum);
      if (q != null) {
        return this.colorToClass(q.color);
      }
    }

    return '';
  }

  /**
   * 
   * @param color 
   */
  colorToClass(color: string) {
    if (!color) {
      return '';
    }
    switch (color.toLowerCase()) {
      case 'green':
        return 'green-score';
      case 'yellow':
        return 'yellow-score';
      case 'red':
        return 'red-score';
    }
    return '';
  }
}
