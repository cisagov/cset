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
import { Component, OnInit } from '@angular/core';
import { AggregationService } from '../../services/aggregation.service';
import { AssessmentService } from '../../services/assessment.service';
import { MergeQuestionDetailComponent } from '../../dialogs/merge-question-detail/merge-question-detail.component';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-merge',
  templateUrl: './merge.component.html'
})
export class MergeComponent implements OnInit {

  mergeID: string;
  enchilada: any;

  dialogRef: MatDialogRef<any>;

  /**
   * Constructor.
   * @param aggregationSvc
   */
  constructor(
    private aggregationSvc: AggregationService,
    public assessmentSvc: AssessmentService,
    public dialog: MatDialog
  ) { }

  /**
   *
   */
  ngOnInit() {
  }

  /**
   *
   */
  startMerge() {
    this.aggregationSvc.getMergeSourceAnswers().subscribe((resp: any) => {
      this.enchilada = resp;
      this.mergeID = resp.mergeID;
    });
  }

  /**
   * If there are no spaces in the question text assume it's a hex string
   * @param q
   */
  applyWordBreak(q: any) {
    if (q.questionText.indexOf(' ') >= 0) {
      return "normal";
    }
    return "break-all";
  }

  /**
   * Send the merge answer to the API.
   */
  storeAnswer(q: any, ans: string) {
    q.defaultAnswer = ans;
    this.aggregationSvc.setMergeAnswer(q.combinedAnswerID, ans).subscribe();
  }

  editDetail() {
    this.dialogRef = this.dialog.open(MergeQuestionDetailComponent);
    this.dialogRef
      .afterClosed()
      .subscribe(
        (data: any) => {
          // do something?
          this.dialogRef = undefined;
        },
        error => console.log(error.message)
      );
  }
}
