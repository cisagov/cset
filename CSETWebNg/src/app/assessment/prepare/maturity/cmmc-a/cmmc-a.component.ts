import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';
import { AssessmentService } from '../../../../services/assessment.service';

@Component({
  selector: 'app-cmmc-a',
  templateUrl: './cmmc-a.component.html'
})
export class CmmcAComponent implements OnInit {

  constructor(
    private assessSvc: AssessmentService,
    public navSvc2: NavigationService,
  ) { }

  ngOnInit() {
  }

}
