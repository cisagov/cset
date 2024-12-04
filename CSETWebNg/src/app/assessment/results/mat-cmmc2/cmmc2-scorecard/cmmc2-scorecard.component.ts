import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-cmmc2-scorecard',
  templateUrl: './cmmc2-scorecard.component.html',
  styleUrl: './cmmc2-scorecard.component.scss'
})
export class Cmmc2ScorecardComponent implements OnInit {

  levels: any[];

  /**
   * 
   */
  constructor(
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService
  ) {}

  /**
   * 
   */
  ngOnInit(): void {
    this.maturitySvc.getCmmcScorecards().subscribe((x: any[]) => {
      this.levels = x;
    });
  }

  level(l: number) {
    if (!!this.levels) {
      return this.levels[l];
    }
    return null;
  }
}
