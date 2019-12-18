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
}
