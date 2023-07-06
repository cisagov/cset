import { Component } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { AuthenticationService } from '../../../../services/authentication.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentDetail } from '../../../../models/assessment-info.model';

@Component({
  selector: 'app-key-report',
  templateUrl: './key-report.component.html',
  styleUrls: ['./key-report.component.scss']
})
export class KeyReportComponent {
  assessment: AssessmentDetail = {};
  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService
   
  ) { }

  ngOnInit(): void {
    console.log(this.assessSvc.id())
    // if (this.assessSvc.id()) {
    //   this.assessSvc.loadAssessment(this.assessSvc.id())
    //   this.assessment = this.assessSvc.assessment;
    // }
  }
  
}
