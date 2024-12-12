import { Component, Input } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { MaturityService } from '../../../services/maturity.service';

@Component({
  selector: 'app-cmmc2-scorecard-report',
  templateUrl: './cmmc2-scorecard-report.component.html',
  styleUrls: ['../../../reports/reports.scss']
})
export class Cmmc2ScorecardReportComponent {

  assessmentDate: string;
  assessorName: string;
  facilityName: string;

  @Input()
  scorecards: any[];

  targetLevel: number;

/**
 * 
 */
  constructor(
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.maturitySvc.getCmmcReportData().subscribe((r: any) => {
      const info = r.reportData.information;
      this.assessmentDate = info.assessment_Date;
      this.assessorName = info.assessor_Name;
      this.facilityName = info.facility_Name;
    });

    this.maturitySvc.getCmmcScorecards().subscribe((x: any) => {
      this.targetLevel = x.targetLevel;
      this.scorecards = x.levelScorecards;
    });
  }

  /**
   * 
   */
  scorecardForLevel(l: number) {
    return this.scorecards?.find(x => x.level == l);
  }

  /**
   * 
   */
  printReport() {
    window.print();
  }
}
