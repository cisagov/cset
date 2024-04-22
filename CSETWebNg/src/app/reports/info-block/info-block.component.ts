import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../services/report.service';

@Component({
  selector: 'app-info-block',
  templateUrl: './info-block.component.html'
})
export class InfoBlockComponent {

  @Input()
  public response: any;

  constructor(
    public reportSvc: ReportService
  ) { }
}
