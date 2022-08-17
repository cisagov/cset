import { Component, OnInit } from '@angular/core';
import { CrrService } from '../../../../services/crr.service';
import { CrrReportModel } from './../../../../models/report.model';

@Component({
  selector: 'app-crr-summary-results',
  templateUrl: './crr-summary-results.component.html'
})
export class CrrSummaryResultsComponent implements OnInit {

  summaryResult: any = '';
  crrModel: CrrReportModel;

  chartLoaded: boolean = false;
  summaryResultLoaded: boolean = false;

  constructor(
    private crrSvc: CrrService,
    ) {
  }

  ngOnInit(): void {
    this.crrSvc.getCrrModel().subscribe((data: CrrReportModel) => {
      this.crrModel = data;
      this.chartLoaded = true;
      this.summaryResultLoaded = true;
    });
  }
}
