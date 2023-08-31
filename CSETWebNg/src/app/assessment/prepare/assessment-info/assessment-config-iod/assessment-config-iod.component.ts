import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { DemographicService } from '../../../../services/demographic.service';
import { ConfigService } from '../../../../services/config.service';
import { DemographicIodService } from '../../../../services/demographic-iod.service';
import { DemographicsIod } from '../../../../models/demographics-iod.model';
import { AssessmentContactsResponse } from '../../../../models/assessment-info.model';
import { User } from '../../../../models/user.model';

@Component({
  selector: 'app-assessment-config-iod',
  templateUrl: './assessment-config-iod.component.html',
  styleUrls: ['./assessment-config-iod.component.scss']
})
export class AssessmentConfigIodComponent implements OnInit {
  iodDemographics: DemographicsIod = {};

  demographics: any = {};

  contacts: User[];

  constructor(
    public assessmentSvc: AssessmentService,
    private demoSvc: DemographicService,
    private iodDemoSvc: DemographicIodService
  ) {}

  ngOnInit() {
    this.demoSvc.getDemographic().subscribe((data: any) => {
      this.demographics = data;
    });

    this.iodDemoSvc.getDemographics().subscribe((data: any) => {
      this.iodDemographics = data;
      this.refreshContacts()
    });
  }

  changeCriticalService(evt: any) {
    this.demographics.criticalServiceName = evt.target.value;
    this.updateDemographics();
  }

  changePointOfContact(evt: any) {
    this.demographics.pointOfContact = evt.target.value;
    this.updateDemographics();
  }

  updateDemographics() {
    this.demoSvc.updateDemographic(this.demographics);
  }

  updateIodDemographics() {
    this.iodDemoSvc.updateDemographic(this.iodDemographics);
  }

  refreshContacts() {
    if (this.assessmentSvc.id()) {
      this.assessmentSvc.getAssessmentContacts().then((data: AssessmentContactsResponse) => {
        this.contacts = data.contactList;
      });
    }
  }

  /**
   * Some fields are only intended to be shown for
   * certain assessment/modules.
   */
  // I don't think this check is needed since we are only showing this page in IOD mode (unless we only want to show for certain models within IOD mode)
  // isTargetModule(): boolean {
  //   return (['CRR', 'EDM', 'CIS', 'RRA', 'IMR', 'CPG', 'MVRA'].includes(this.assessmentSvc.assessment.maturityModel.modelName))
  //   && this.configSvc.installationMode === 'IOD';
  // }
}
