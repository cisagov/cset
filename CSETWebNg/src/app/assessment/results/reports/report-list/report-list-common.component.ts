import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { ObservationsService } from '../../../../services/observations.service';
import { ReportService } from '../../../../services/report.service';


@Component({
    selector: 'app-report-list-common',
    templateUrl: './report-list-common.component.html',
    standalone: false
})

export class ReportListCommonComponent implements OnChanges {
  @Input() sectionId: string;

  jsonData: any;
  reportList: any[] = [];

  constructor(public assessSvc: AssessmentService,
    public observationsSvc: ObservationsService,
    public reportSvc: ReportService
  ) {
    // Load JSON data 
    this.jsonData = require('./report-list.json');
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['sectionId']) {
      this.reportList = this.getReportList(this.sectionId);
    }
  }

  getReportList(sectionId: string): any[] {
    const result = this.jsonData.find(item => item.title === sectionId);
    // Check if the result exists and return the reportList or an empty array if not found
    return result ? result.reportList : [];
  }
}
