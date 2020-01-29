import { Component, OnInit } from '@angular/core';
import { AggregationService } from '../../../services/aggregation.service';

@Component({
  selector: 'app-compare-missed',
  templateUrl: './compare-missed.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareMissedComponent implements OnInit {

  missedQuestions: [];

  constructor(
    public aggregationSvc: AggregationService
  ) { }

  ngOnInit() {
    const aggregationId = this.aggregationSvc.id();

    this.aggregationSvc.getMissedQuestions().subscribe((resp: any) => {
      this.missedQuestions = resp;
    });
  }

}
