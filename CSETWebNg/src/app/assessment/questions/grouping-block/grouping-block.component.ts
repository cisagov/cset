import { Component, Input, OnInit } from '@angular/core';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';


@Component({
  selector: 'app-grouping-block',
  templateUrl: './grouping-block.component.html'
})
export class GroupingBlockComponent implements OnInit {

  @Input('grouping') grouping: any;


  constructor(
    public acetFilteringSvc: AcetFilteringService
  ) { }

  ngOnInit(): void {
  }

  /**
   * Indicates if the grouping is a domain
   */
  isDomain(): boolean {
    return this.grouping.GroupingType === 'Domain';
  }

  /**
   * Indicates if all domain maturity filters have been turned off for the domain
   */
  filtersAllOff(): boolean {
    if (this.isDomain()) {
      if (this.acetFilteringSvc.maturityFiltersAllOff(this.grouping.Title)) {
        return true;
      }
    }
    return false;
  }
}
