import { Component, OnInit } from '@angular/core';
import { AggregationService } from '../../services/aggregation.service';
import { AssessmentService } from '../../services/assessment.service';
import { MergeQuestionDetailComponent } from '../../dialogs/merge-question-detail/merge-question-detail.component';
import { MatDialogRef, MatDialog } from '@angular/material';

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
      this.mergeID = resp.MergeID;
    });
  }

  /**
   * If there are no spaces in the question text assume it's a hex string
   * @param q
   */
  applyWordBreak(q: any) {
    if (q.QuestionText.indexOf(' ') >= 0) {
      return "normal";
    }
    return "break-all";
  }

  /**
   * Send the merge answer to the API.
   */
  storeAnswer(q: any, ans: string) {
    q.DefaultAnswer = ans;
    this.aggregationSvc.setMergeAnswer(q.CombinedAnswerID, ans).subscribe();
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
