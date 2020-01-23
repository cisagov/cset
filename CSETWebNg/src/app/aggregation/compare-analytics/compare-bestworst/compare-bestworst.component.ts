import { Component, OnInit } from '@angular/core';
import { NavigationAggregService } from '../../../services/navigationAggreg.service';
import { AggregationService } from '../../../services/aggregation.service';
import { AggregationChartService } from '../../../services/aggregation-chart.service';

@Component({
  selector: 'app-compare-bestworst',
  templateUrl: './compare-bestworst.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})
export class CompareBestworstComponent implements OnInit {

  constructor(
    public navSvc: NavigationAggregService,
    public aggregationSvc: AggregationService,
    public aggregChartSvc: AggregationChartService
  ) { }

  ngOnInit() {

  }

  loadPage() {
    this.loadCategoryList();
  }


  loadCategoryList() {
    this.aggregationSvc.getBestToWorst().subscribe((x: any) => {
      console.log(x);
    });
  }

}
