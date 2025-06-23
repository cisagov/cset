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
import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-cre-core-report-grid',
  standalone: false,
  templateUrl: './cre-core-report-grid.component.html',
  styleUrls: ['../../reports.scss']
})
export class CreCoreReportGridComponent implements OnInit {

  @Input() modelId: number;

  model: any;
  groupings: [];

  constructor(
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService
  ) { }

  ngOnInit(): void {
    this.reportSvc.getModelContent(this.modelId.toString()).subscribe((x) => {
      this.model = x;

      this.groupings = this.model?.groupings;
    });
  }

  /**
  * Sets the coloring of a cell based on its answer.
  * @param answer 
  */
  answerCellClass(answer: string) {
    console.log(answer);
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
      case null:
        return 'default-score';
    }
  }
}
