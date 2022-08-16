import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from './../../../../models/report.model';

@Component({
  selector: 'app-crr-cover-sheet2',
  templateUrl: './crr-cover-sheet2.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrCoverSheet2Component implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
