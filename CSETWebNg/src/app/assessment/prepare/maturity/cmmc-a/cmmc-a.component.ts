import { Component, OnInit } from '@angular/core';
import { Navigation2Service } from '../../../../services/navigation2.service';
import { AssessmentService } from '../../../../services/assessment.service';

@Component({
  selector: 'app-cmmc-a',
  templateUrl: './cmmc-a.component.html'
})
export class CmmcAComponent implements OnInit {

  constructor(
    private assessSvc: AssessmentService,
    public navSvc2: Navigation2Service,
  ) { }

  ngOnInit() {
  }

}
