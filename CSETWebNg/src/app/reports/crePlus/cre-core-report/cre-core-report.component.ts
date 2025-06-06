import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-cre-core-report',
  templateUrl: './cre-core-report.component.html',
  styleUrl: '../../reports.scss',
  standalone: false
})
export class CreCoreReportComponent implements OnInit {

  model: any;
  groupings: [];

  constructor(
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService
  ) {

  }

  ngOnInit(): void {
    this.reportSvc.getModelContent('CPG').subscribe((x) => {
      this.model = x;

      const parentGroup = this.model?.groupings[0];
      this.groupings = parentGroup.groupings;
    });
  }

/**
   * Sets the coloring of a cell based on its answer.
   * @param answer 
   */
answerCellClass(answer: string) {
  switch (answer) {
    case 'Y':
      return 'green-score';
    case 'I':
      return 'blue-score';
    case 'S':
      return 'gold-score';
    case 'N':
      return 'red-score';
  }
}



}
