import { Component, Input } from '@angular/core';
import { AssessmentService } from '../../../../../services/assessment.service';
import { CisService } from '../../../../../services/cis.service';
import { HydroService } from '../../../../../services/hydro.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { QuestionsService } from '../../../../../services/questions.service';
import { ReportService } from '../../../../../services/report.service';

@Component({
  selector: 'app-hydro-progress-totals',
  templateUrl: './hydro-progress-totals.component.html',
  styleUrls: ['./hydro-progress-totals.component.scss', '../hydro-actions.component.scss']
})
export class HydroProgressTotalsComponent {
  @Input() totals: any;
  @Input() progressArray: any;

  classArray: string[] = ['progress-box not-started', 'progress-box in-progress', 'progress-box in-review', 'progress-box complete'];
  classEmptyArray: string[] = ['progress-box not-started-empty', 'progress-box in-progress-empty', 'progress-box in-review-empty', 'progress-box complete-empty'];

  showProgressButtons: boolean = false;
  progressText: string = '';

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) {}

}
