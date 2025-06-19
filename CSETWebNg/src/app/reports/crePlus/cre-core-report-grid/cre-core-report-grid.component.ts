import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-cre-core-report-grid',
  standalone: false,
  templateUrl: './cre-core-report-grid.component.html',
  styleUrls: ['../../reports.scss']
})
export class CreCoreReportGridComponent implements OnInit {

  @Input() modelId: number;

  model: any;
  groupings: [];

  constructor(
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService
  ) { }

  ngOnInit(): void {
    this.reportSvc.getModelContent(this.modelId.toString()).subscribe((x) => {
      this.model = x;

      this.groupings = this.model?.groupings;
    });
  }

  /**
  * Sets the coloring of a cell based on its answer.
  * @param answer 
  */
  answerCellClass(answer: string) {
    console.log(answer);
    switch (answer) {
      case 'Y':
        return 'green-score';
      case 'I':
        return 'blue-score';
      case 'S':
        return 'gold-score';
      case 'N':
        return 'red-score';
      case 'U':
      case null:
        return 'default-score';
    }
  }
}
