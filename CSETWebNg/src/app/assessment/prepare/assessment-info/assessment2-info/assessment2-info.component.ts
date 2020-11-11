import { Component, OnInit, ViewChild } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation.service';
import { DemographicService } from '../../../../services/demographic.service';

@Component({
  selector: 'app-assessment2-info',
  templateUrl: './assessment2-info.component.html'
})
export class Assessment2InfoComponent implements OnInit {

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private demoSvc: DemographicService
  ) { }

  @ViewChild('demographics') demographics;

  ngOnInit() {
    this.demoSvc.id = (this.assessSvc.id());
  }

}
