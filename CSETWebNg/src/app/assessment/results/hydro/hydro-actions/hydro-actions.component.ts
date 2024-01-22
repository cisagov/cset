import { Component, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { QuestionsService } from '../../../../services/questions.service';
import { CisService } from '../../../../services/cis.service';
import { HydroService } from '../../../../services/hydro.service';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-hydro-actions',
  templateUrl: './hydro-actions.component.html',
  styleUrls: ['./hydro-actions.component.scss']
})
export class HydroActionsComponent implements OnInit {

  actionItemData: any[] = [];
  unsortedActionItemData: any[] = [];
  progressTotalsMap: Map<String, number[]> = new Map<String, number[]>();

  loadingCounter: number = 0;

  domainExpandMap: Map<String, boolean> = new Map<String, boolean>();
  progressLevels: any[] = [];

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) { }

  ngOnInit() {

    this.reportSvc.getHydroActionItemsReport().subscribe(
      (r: any) => {
        if (r.length > 0) {
          let sortedArray = this.sortActionItems(r);

          let progressArray = [];
          let currProgressId = sortedArray[0].actionData.progress_Id;

          this.hydroSvc.getProgressText().subscribe(
            (p: any) => {
              this.progressLevels = p;
              for (let item of sortedArray) {
                if (currProgressId != item.actionData.progress_Id) {
                  this.actionItemData.push(progressArray);
                  currProgressId = item.actionData.progress_Id;
                  progressArray = [];
                }

                progressArray.push(item);
              }

              this.actionItemData.push(progressArray);
              this.loadingCounter++;
            }
          );
        }
        else {
          this.actionItemData = [];
          this.loadingCounter++;
        }

        this.loadingCounter++;
      }
    )
  }

  sortActionItems(arrayToSort: any[]) {
    arrayToSort.sort((a, b) => {
      if (a.actionData.progress_Id > b.actionData.progress_Id) { //a's progress_Id is larger than b's
        return 1;
      }
      if (a.actionData.progress_Id < b.actionData.progress_Id) { //a's progress_Id is smaller than b's
        return -1;
      }

      //if it makes it here, both progress_Ids are the same. Order by Impact severity from here on out (1.High, 2.Medium, 3.Low)
      if (a.action.severity > b.action.severity) {
        return 1;
      }
      if (a.action.severity < b.action.severity) {
        return -1;
      }

      return 0;
    });

    return arrayToSort;
  }

  sortBySeverity() {
    for (let domain of this.actionItemData) {
      domain.actionsQuestions.sort((a, b) => (
        a.action.severity < b.action.severity ? -1 : 1
      ));
    }
  }

  saveChanges(answer: any, progressId: number, comment: string) {
    this.hydroSvc.saveHydroComment(answer, answer.answer_Id, progressId, comment).subscribe();
  }

}
