import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { NavigationService } from '../../../services/navigation.service';

@Component({
  selector: 'app-placeholder-questions',
  templateUrl: './placeholder-questions.component.html'
})
export class PlaceholderQuestionsComponent implements OnInit {

  constructor(
    private navSvc: NavigationService,
    private assessSvc: AssessmentService
  ) { }

  ngOnInit(): void {
    this.assessSvc.currentTab = 'questions';
  }

  /**
   * Navigate the user to the Assessment Config page
   */
  navToAssessConfig() {
    this.navSvc.navDirect('info1');
  }
}
