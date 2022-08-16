import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/report.model';

@Component({
  selector: 'app-crr-contact-information',
  templateUrl: './crr-contact-information.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrContactInformationComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
