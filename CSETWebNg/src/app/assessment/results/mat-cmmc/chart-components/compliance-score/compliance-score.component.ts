import { Component, OnInit } from '@angular/core';
import { CmmcStyleService } from '../../../../../services/cmmc-style.service';

@Component({
  selector: 'app-compliance-score',
  templateUrl: './compliance-score.component.html',
  styleUrls: ['/sass/cmmc-results.scss']
})
export class ComplianceScoreComponent implements OnInit {

  constructor(
    public cmmcStyleSvc: CmmcStyleService
  ) { }

  ngOnInit(): void {
    this.cmmcStyleSvc.getData();
  }

}
