import { Component, OnInit, ViewChild } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation.service';
import { DemographicService } from '../../../../services/demographic.service';
import { ConfigService } from '../../../../services/config.service';

@Component({
  selector: 'app-assessment2-info',
  templateUrl: './assessment2-info.component.html'
})
export class Assessment2InfoComponent implements OnInit {

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private demoSvc: DemographicService,
    private configSvc: ConfigService
  ) { }

  @ViewChild('demographics') demographics;

  ngOnInit() {
    this.demoSvc.id = (this.assessSvc.id());
  }

  isDisplayed():boolean{
    let isStandard = this.assessSvc.assessment?.useStandard;
    let isNotAcetModel = !(this.assessSvc.usesMaturityModel('ACET'));
    
    let show = !this.configSvc.acetInstallation || isStandard;
    
    return show || isNotAcetModel;    
  }

}
