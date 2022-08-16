import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-percentage-of-practices',
  templateUrl: './crr-percentage-of-practices.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrPercentageOfPracticesComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
