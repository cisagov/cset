import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';
import { AssessmentService } from '../../../../services/assessment.service';

@Component({
  selector: 'app-cmmc-levels',
  templateUrl: './cmmc-levels.component.html'
})
export class CmmcLevelsComponent implements OnInit {

  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService
  ) { }

  ngOnInit() {
  }

}
