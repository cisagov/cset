import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-mc-question',
  templateUrl: './mc-question.component.html',
  styleUrls: ['./mc-question.component.scss']
})
export class McQuestionComponent implements OnInit {

  @Input()
  q: any;

  constructor(
    public reportSvc: ReportService
  ) { }

  ngOnInit(): void {
  }

}
