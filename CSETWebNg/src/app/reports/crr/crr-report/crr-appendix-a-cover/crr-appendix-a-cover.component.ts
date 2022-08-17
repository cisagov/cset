import { Component, Input, OnInit } from '@angular/core';
import { CrrReportModel } from '../../../../models/reports.model';

@Component({
  selector: 'app-crr-appendix-a-cover',
  templateUrl: './crr-appendix-a-cover.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrAppendixACoverComponent implements OnInit {

  @Input() model: CrrReportModel;

  constructor() { }

  ngOnInit(): void {
  }

}
