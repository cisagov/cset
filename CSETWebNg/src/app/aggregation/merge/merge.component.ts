import { Component, OnInit } from '@angular/core';
import { AggregationService } from '../../services/aggregation.service';
import { AssessmentService } from '../../services/assessment.service';

@Component({
  selector: 'app-merge',
  templateUrl: './merge.component.html'
})
export class MergeComponent implements OnInit {

  mergeID: string;
  enchilada: any;

  /**
   * Constructor.
   * @param aggregationSvc
   */
  constructor(
    private aggregationSvc: AggregationService,
    public assessmentSvc: AssessmentService
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
    this.aggregationSvc.getSourceAnswers().subscribe((resp: any) => {
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
}
