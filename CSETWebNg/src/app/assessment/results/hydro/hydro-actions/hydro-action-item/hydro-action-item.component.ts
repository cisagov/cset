import { Component, OnInit, Input } from '@angular/core';
import { AssessmentService } from '../../../../../services/assessment.service';
import { CisService } from '../../../../../services/cis.service';
import { HydroService } from '../../../../../services/hydro.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { QuestionsService } from '../../../../../services/questions.service';
import { ReportService } from '../../../../../services/report.service';

@Component({
  selector: 'app-hydro-action-item',
  templateUrl: './hydro-action-item.component.html',
  styleUrls: ['./hydro-action-item.component.scss','../hydro-actions.component.scss']
})
export class HydroActionItemComponent implements OnInit {

  @Input() subCatName: any;
  @Input() impact: any;
  @Input() text: any;
  @Input() progressId: any;
  @Input() progressArray: any;
  @Input() comment: string;
  @Input() answer: any;

  classArray: string[] = ['progress-btn not-started', 'progress-btn in-progress', 'progress-btn in-review', 'progress-btn complete'];
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

  ngOnInit() {
    this.progressText = this.progressArray[this.progressId - 1].progress_Text;
  }

  toggleProgressSelector() {
    this.showProgressButtons = !this.showProgressButtons;
  }

  selectNewProgress(progress: any, comment: string) {
    this.progressId = progress.progress_Id;
    this.progressText = progress.progress_Text;
    this.toggleProgressSelector();

    this.saveChanges(comment);
  }

  saveChanges(comment: string) {
    this.hydroSvc.saveHydroComment(this.answer, this.answer.answer_Id, this.progressId, comment).subscribe();
  }

}
