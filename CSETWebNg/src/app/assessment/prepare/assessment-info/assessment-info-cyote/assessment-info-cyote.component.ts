import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog/public-api';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { MaturityService } from '../../../../services/maturity.service';
import { NavigationService } from '../../../../services/navigation.service';

@Component({
  selector: 'app-assessment-info-cyote',
  templateUrl: './assessment-info-cyote.component.html'
})
export class AssessmentInfoCyoteComponent implements OnInit {

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService
  ) { }

  ngOnInit(): void {
    this.navSvc.setCurrentPage('info-cyote');
    this.navSvc.setWorkflow("CYOTE");
  }

}
