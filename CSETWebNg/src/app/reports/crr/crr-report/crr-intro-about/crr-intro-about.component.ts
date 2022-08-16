import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-intro-about',
  templateUrl: './crr-intro-about.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrIntroAboutComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
