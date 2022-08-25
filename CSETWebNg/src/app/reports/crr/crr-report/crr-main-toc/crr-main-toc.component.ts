import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-main-toc',
  templateUrl: './crr-main-toc.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrMainTocComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
