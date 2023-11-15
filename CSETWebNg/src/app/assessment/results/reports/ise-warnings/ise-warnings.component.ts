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
  @Input() disableIseReportLinks;

  constructor(
    public assessSvc: AssessmentService,
    public ncuaSvc: NCUAService
  ) {}

  isAssessmentPageFilled() {
    if (this.ncuaSvc.creditUnionName == '' || this.ncuaSvc.creditUnionName === null || this.ncuaSvc.assetsAsNumber == 0) {
      return false;
    }
    return true;
  }
}
