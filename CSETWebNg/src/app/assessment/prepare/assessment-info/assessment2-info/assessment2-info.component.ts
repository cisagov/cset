import { Component, OnInit, ViewChild } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { DemographicService } from '../../../../services/demographic.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentDemographicsComponent } from '../assessment-demographics/assessment-demographics.component';
import { NCUAService } from '../../../../services/ncua.service';

@Component({
  selector: 'app-assessment2-info',
  templateUrl: './assessment2-info.component.html'
})
export class Assessment2InfoComponent implements OnInit {

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private demoSvc: DemographicService,
    public ncuaSvc: NCUAService,
    public configSvc: ConfigService
  ) { }

  @ViewChild('demographics') demographics: AssessmentDemographicsComponent;

  ngOnInit() {
    this.demoSvc.id = (this.assessSvc.id());
  }

  /**
   *
   * @returns
   */
  isDisplayed(): boolean {
    let isStandard = this.assessSvc.assessment?.useStandard;
    let isNotAcetModel = !(this.assessSvc.usesMaturityModel('ACET'));

    let show = (this.configSvc.installationMode !== "ACET") || isStandard;

    return ((show || isNotAcetModel) && (!this.ncuaSvc.switchStatus));
  }

  /**
   *
   */
  contactsUpdated() {
    this.demographics?.refreshContacts();
  }

  showContacts() {
    return this.configSvc.behaviors.showContacts;
  }

  usingIse() {
    if (this.ncuaSvc.switchStatus && this.assessSvc.usesMaturityModel('ISE')) {
      return true;
    } else {
      return false;
    }
  }
}
