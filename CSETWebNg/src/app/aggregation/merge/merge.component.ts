import { Component, OnInit } from '@angular/core';
import { AggregationService } from '../../services/aggregation.service';

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
    private aggregationSvc: AggregationService
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

      console.log(resp);

      this.enchilada = resp;

      this.mergeID = resp.MergeID;



      console.log(this.mergeID);

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


  storeAnswer(q: any, ans: string) {
    console.log(q);
    console.log(ans);
    q.DefaultAnswer = ans;
    this.aggregationSvc.setMergeAnswer(q.CombinedAnswerID, ans).subscribe(x => {});
  }
}
