import { Component, Input, OnInit } from '@angular/core';
import { MaturityFiltersService } from '../../../services/MaturityFiltering/maturity-filters.service';

@Component({
  selector: 'app-grouping-block',
  templateUrl: './grouping-block.component.html'
})
export class GroupingBlockComponent implements OnInit {

  @Input('grouping') grouping: any;


  constructor(
    public acetFiltersSvc: MaturityFiltersService
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
      if (this.acetFiltersSvc.maturityFiltersAllOff(this.grouping.Title)) {
        return true;
      }
    }
    return false;
  }
}
