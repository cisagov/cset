import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { CisService } from '../../../../services/cis.service';

@Component({
  selector: 'app-config-cis',
  templateUrl: './config-cis.component.html'
})
export class ConfigCisComponent implements OnInit {

  assessmentId: number;

  baselineAssessmentId?: number;

  baselineCandidates: any[];

  cloneSourceCandidates: any[];

  /**
   * 
   */
  constructor(
    public assessmentSvc: AssessmentService,
    public cisSvc: CisService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.assessmentId = this.assessmentSvc.assessment?.id;

    // call API for CIS assessments other than the current one
    this.cisSvc.getMyCisAssessments().subscribe((resp: any) => {
      this.baselineAssessmentId = resp.baselineAssessmentId;
      this.cisSvc.baselineAssessmentId = resp.baselineAssessmentId;

      // remove the current assessment from the candidate lists
      this.baselineCandidates = Object.assign(resp.myCisAssessments).filter(x => x.id !== this.assessmentId);
      this.cloneSourceCandidates = Object.assign(resp.myCisAssessments).filter(x => x.id !== this.assessmentId);
    });
  }

  /**
   * Persist the user's choice of baseline assessment (or none).
   */
  changeBaseline(event: any) {
    var baselineId = event.target.value;
    this.cisSvc.saveBaseline(baselineId).subscribe();
  }
}
