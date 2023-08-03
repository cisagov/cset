import { Component } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { DemographicService } from '../../../../services/demographic.service';

@Component({
  selector: 'app-assessment-config-iod',
  templateUrl: './assessment-config-iod.component.html',
  styleUrls: ['./assessment-config-iod.component.scss']
})
export class AssessmentConfigIodComponent {

  iodDemographics: any = {};

  contacts: any[];

  annualRevPctOptions: any[];

  annualPeopleServedOptions: any[];

  constructor(
    public assessmentSvc: AssessmentService,
    private demoSvc: DemographicService
  ) {

  }


  changeCriticalService(evt: any) {
    this.iodDemographics.criticalServiceName = evt.target.value;
    this.updateDemographics();
  }

  changePointOfContact(evt: any) {
    this.iodDemographics.pointOfContact = evt.target.value;
    this.updateDemographics();
  }

  updateDemographics() {
    this.demoSvc.updateDemographic(this.iodDemographics);
  }


  /**
   * Some fields are only intended to be shown for
   * certain assessment/modules.
   */
  isTargetModule(): boolean {
    return (['CRR', 'EDM', 'CIS', 'RRA'].includes(this.assessmentSvc.assessment.maturityModel.modelName));
  }
}
