import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../services/report.service';
import { AssessmentDetail } from '../../models/assessment-info.model';

@Component({
    selector: 'app-info-block',
    templateUrl: './info-block.component.html',
    standalone: false
})
export class InfoBlockComponent {

  @Input()
  public assessDetail?: AssessmentDetail;

  constructor(
    public reportSvc: ReportService
  ) { }
}
