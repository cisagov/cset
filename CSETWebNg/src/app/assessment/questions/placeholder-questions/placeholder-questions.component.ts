import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { NavigationService } from '../../../services/navigation.service';

@Component({
  selector: 'app-placeholder-questions',
  templateUrl: './placeholder-questions.component.html',
  styleUrls: ['./placeholder-questions.component.scss']
})
export class PlaceholderQuestionsComponent implements OnInit {

  constructor(
    private navSvc: NavigationService,
    private assessSvc: AssessmentService,
    public configSvc: ConfigService
  ) { }

  ngOnInit(): void {
    this.assessSvc.currentTab = 'questions';
  }

  /**
   * Navigate the user to the Assessment Config page
   */
  navToAssessConfig() {
    if (this.assessSvc.assessment.workflow == 'TSA') {
      this.navSvc.navDirect('info-tsa');
    } else {
      this.navSvc.navDirect('info1');
    }
  }
}
