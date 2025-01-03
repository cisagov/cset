import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../../services/assessment.service';
import { MaturityService } from '../../../../../services/maturity.service';

@Component({
  selector: 'app-cmmc2-scorecard-page',
  templateUrl: './cmmc2-scorecard-page.component.html',
  styleUrl: './cmmc2-scorecard-page.component.scss'
})
export class Cmmc2ScorecardPageComponent implements OnInit {

  scorecards: any[];

  targetLevel: number;

  /**
   * 
   */
  constructor(
    public maturitySvc: MaturityService
  ) {}

  /**
   * 
   */
  ngOnInit(): void {
    this.maturitySvc.getCmmcScorecards().subscribe((x: any) => {
      this.targetLevel = x.targetLevel;
      this.scorecards = x.levelScorecards;
    });
  }

  scorecardForLevel(l: number) {
    if (!!this.scorecards) {
      const sc = this.scorecards.find(x => x.level == l);
      return sc;
    }
    return null;
  }
}
