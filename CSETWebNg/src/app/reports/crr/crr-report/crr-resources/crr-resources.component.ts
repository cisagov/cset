import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-resources',
  templateUrl: './crr-resources.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrResourcesComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
