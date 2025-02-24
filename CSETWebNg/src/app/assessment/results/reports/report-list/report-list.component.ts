import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { TranslocoService } from '@jsverse/transloco';
import { AssessmentService } from '../../../../services/assessment.service';
import { NCUAService } from '../../../../services/ncua.service';
import { ObservationsService } from '../../../../services/observations.service';
import { ACETService } from '../../../../services/acet.service';
import { MaturityService } from '../../../../services/maturity.service';

/**
 * This component displays a list of report launching links.  
 * The links defined for each assessment type is defined in report-list.json
 * Two types of links are supported.  Most launch an HTML report in a new tab, 
 * defined with a 'linkUrl' property.
 * The other will launch an exported Excel spreadsheet, defined with an 'exportUrl' 
 * property.
 */
@Component({
    selector: 'app-report-list',
    templateUrl: './report-list.component.html',
    styleUrls: ['./report-list.component.scss'],
    standalone: false
})
export class ReportListComponent implements OnInit {


  @Input()
  confidentiality: any;

  @Input()
  sectionId: string;

  sectionTitle: string;

  @Input()
  list: any[];

  /**
   * Used to disable report link
   */
  cmmcLevel1Achieved = false;

  /**
   * 
   */
  constructor(
    public reportSvc: ReportService,
    public tSvc: TranslocoService,
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public ncuaSvc: NCUAService,
    public observationsSvc: ObservationsService,
    public acetSvc: ACETService
  ) { }

  ngOnInit(): void {
    if (!this.sectionId) {
      return;
    }

    const key = 'reports.launch.' + this.sectionId.toLowerCase() + '.sectionTitle';
    this.sectionTitle = this.tSvc.translate(key);

    // get CMMC scores if appropriate
    this.setCmmcLevelAchievement();
  }

  /**
   * 
   */
  onSelectSecurity(val) {
    this.confidentiality = val;
    this.reportSvc.confidentiality = val;
  }

  /**
   * Returns the translation, or an empty string
   */
  translateDesc(section: string, index: number): string {
    const key = 'reports.launch.' + section.toLowerCase() + '.' + (index + 1) + '.desc';
    const val = this.tSvc.translate(key);
    return val === key ? '' : val;
  }

  /**
   * If this is a CMMC assessment and the target level is 
   * higher than Level 1, check the score for Level 1.
   */
  setCmmcLevelAchievement() {
    const a = this.assessSvc.assessment;
    const cmmcModels = ['CMMC', 'CMMC2', 'CMMC2F'];

    if (a.maturityModel?.maturityTargetLevel > 1 &&
      cmmcModels.indexOf(a.maturityModel?.modelName) >= 0) {
      this.maturitySvc.getCmmcScores().subscribe((scores: any) => {
        this.cmmcLevel1Achieved = scores.level1Score >= scores.level1MaxScore;
      });
    }
  }

  /**
   * Evaluates certain conditions to indicate if a report link
   * should be disabled.
   */
  isDisabled(condition: string) {
    if (condition == 'cmmc level 1 not achieved') {
      return !this.cmmcLevel1Achieved;
    }

    return false;
  }
}
