import { Component, Input } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { NCUAService } from '../../../../services/ncua.service';


@Component({
  selector: 'app-ise-warnings',
  templateUrl: './ise-warnings.component.html',
  styleUrls: ['./ise-warnings.component.scss']
})
export class IseWarningsComponent {
  @Input() iseHasBeenSubmitted;
  @Input() disableIseReportLinks; // <-- Checks for unanswered questions

  missingFields = [];

  constructor(
    public assessSvc: AssessmentService,
    public ncuaSvc: NCUAService
  ) {}

  ngOnInit() {
    this.checkMissingFields();
  }

  checkMissingFields() {
    if (this.ncuaSvc.creditUnionName == '' || this.ncuaSvc.creditUnionName === null) {
      this.missingFields.push("Credit union name");
    }

    if (this.ncuaSvc.assetsAsNumber == 0 || this.ncuaSvc.assetsAsString == null || this.assessSvc.assessment.assets == null) {
      this.missingFields.push("Assets");
    }
  }

  isAssessmentPageFilled() {
    if (this.ncuaSvc.creditUnionName == '' || this.ncuaSvc.creditUnionName === null 
      || this.ncuaSvc.assetsAsNumber == 0 || this.ncuaSvc.assetsAsString == null) {
      return false;
    }
    return true;
  }
}
