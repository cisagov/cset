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

  @Input() item: any;
  @Input() progressArray: any;

  classArray: string[] = ['progress-btn btn-danger', 'progress-btn btn-primary', 'progress-btn btn-alt', 'progress-btn btn-success'];

  showProgressButtons: boolean = false;
  progressText: string = '';
  progressId: number = 0;
  answer: any;
  comment: string = '';

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) {}

  ngOnInit() {
    this.progressId = this.item.actionData.progress_Id;
    this.progressText = this.progressArray[this.progressId - 1].progress_Text;
    this.answer = this.item.actionData.answer;
    this.comment = this.item.actionData.comment;
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
