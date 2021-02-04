import { group } from '@angular/animations';
import { Component, Input, OnInit } from '@angular/core';
import { MaturityDomain } from '../../../models/mat-detail.model';
import { MaturityDomainRemarks, QuestionGrouping } from '../../../models/questions.model';
import { AssessmentService } from '../../../services/assessment.service';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { MaturityService } from '../../../services/maturity.service';


@Component({
  selector: 'app-grouping-block',
  templateUrl: './grouping-block.component.html'
})
export class GroupingBlockComponent implements OnInit {

  @Input('grouping') grouping: QuestionGrouping;

  /**
   * 
   */
  constructor(
    public assessSvc: AssessmentService,
    public acetFilteringSvc: AcetFilteringService,
    public maturityFilteringService: MaturityFilteringService,
    public matSvc: MaturityService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {    
  }

  /**
   * 
   */
  submitTextComment(grouping:QuestionGrouping){
    const id = grouping.GroupingID;
    const strRemark = grouping.DomainRemark;
    const remark: MaturityDomainRemarks = {
      Group_Id: id,
      DomainRemark: strRemark
    };

    this.matSvc.postDomainObservation(remark).subscribe();
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
