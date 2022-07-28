import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog/public-api';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { NavigationService } from '../../../../services/navigation.service';

@Component({
  selector: 'app-assessment-info-tsa',
  templateUrl: './assessment-info-tsa.component.html'
})
export class AssessmentInfoTsaComponent implements OnInit {

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService
  ) { }

  ngOnInit(): void {
    this.navSvc.setCurrentPage('info-tsa');

    if (this.assessSvc.assessment.workflow === 'TSA') {
      this.navSvc.setWorkflow("tsa");
    } else {
      this.navSvc.setWorkflow('omni');
    }
  }

}
