import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-edm-perf-summ-mil1',
  templateUrl: './edm-perf-summ-mil1.component.html',
  styleUrls: ['../../reports.scss']
})
export class EdmPerfSummMil1Component implements OnInit {

  
  @Input()
  domains: any[];


 
  /**
   * Constructor.
   */
  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {

  }

  /**
   * Returns the list of domains in MIL-1.  This section does not
   * display MIL2-5.
   */
  getDomainsForDisplay() {
    return this.domains.filter(x => x.Abbreviation != "MIL");
  }

  /**
   * Returns the goals for the specified domain.
   * @param domain 
   */
  getGoals(domain: any) {
    return domain.SubGroupings.filter(x => x.GroupingType == "Goal");
  }
}
