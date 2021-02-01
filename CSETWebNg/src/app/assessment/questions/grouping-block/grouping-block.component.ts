import { Component, Input, OnInit } from '@angular/core';
import { QuestionGrouping } from '../../../models/questions.model';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';


@Component({
  selector: 'app-grouping-block',
  templateUrl: './grouping-block.component.html'
})
export class GroupingBlockComponent implements OnInit {

  @Input('grouping') grouping: QuestionGrouping;


  constructor(
    public acetFilteringSvc: AcetFilteringService,
    public maturityFilteringService: MaturityFilteringService
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
   * Indicates if the domain label should be shown
   */
  isDomainVisible(): boolean {
    if (!this.isDomain()) {
      return false;
    }

    // ACET domains are always visible
    if (this.maturityFilteringService.assesmentSvc.assessment.MaturityModel.ModelName == 'ACET') {
      return true;
    }

    // hide invisible domains
    if (!this.grouping.Visible) {
      return false;
    }

    return true;
  }

  /**
   * Indicates if all domain maturity filters have been turned off for the domain
   */
  allDomainMaturityLevelsHidden(): boolean {
    if (this.isDomain()) {
      if (this.acetFilteringSvc.allDomainMaturityLevelsHidden(this.grouping.Title)) {
        return true;
      }
    }
    return false;
  }
}
