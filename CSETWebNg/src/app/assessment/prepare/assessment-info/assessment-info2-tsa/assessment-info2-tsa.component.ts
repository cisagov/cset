import { Component, OnInit, ViewChild } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation.service';
import { DemographicService } from '../../../../services/demographic.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentDemographicsComponent } from '../assessment-demographics/assessment-demographics.component';


@Component({
  selector: 'app-assessment-info2-tsa',
  templateUrl: './assessment-info2-tsa.component.html',
  styleUrls: ['./assessment-info2-tsa.component.scss']
})
export class AssessmentInfo2TsaComponent implements OnInit {
  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private demoSvc: DemographicService,
    public configSvc: ConfigService,
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

    return show || isNotAcetModel;
  }

  /**
   *
   */
  contactsUpdated() {
    this.demographics?.refreshContacts();
  }
}



