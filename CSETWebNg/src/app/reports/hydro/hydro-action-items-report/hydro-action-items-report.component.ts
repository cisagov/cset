import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { CisService } from '../../../services/cis.service';
import { HydroService } from '../../../services/hydro.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-hydro-action-items-report',
  templateUrl: './hydro-action-items-report.component.html',
  styleUrls: ['./hydro-action-items-report.component.scss', '../../reports.scss', '../../../../assets/sass/cset-font-styles.css','../../acet-reports.scss']
})
export class HydroActionItemsReportComponent implements OnInit {

  demographics: any;
  actionItems: any[] = [];
  progressInfo: any[] = [];
  loadingCounter: number = 0;

  classArray: string[] = ['subheader btn-danger', 'subheader btn-primary', 'subheader btn-in-review', 'subheader btn-success'];

  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService
  ) {}

  ngOnInit() {
    this.reportSvc.getAssessmentInfoForReport().subscribe(
      (info: any) => {
        this.demographics = info;
  
        this.loadingCounter ++;
      },
      error => console.log('Assessment Information Error: ' + (<Error>error).message)
    );

    this.reportSvc.getHydroActionItemsReport().subscribe(
      (r: any) => {    
        if (r.length > 0) {
          let sortedArray = this.sortActionItems(r);

          let progressArray = [];
          let currProgressId = sortedArray[0].actionData.progress_Id;

          this.hydroSvc.getProgressText().subscribe(
            (p: any) => {
              this.progressInfo = p;
              for (let item of sortedArray) {
                if (currProgressId != item.actionData.progress_Id) {
                  this.actionItems.push(progressArray);
                  currProgressId = item.actionData.progress_Id;
                  progressArray = [];
                }

                progressArray.push(item);
              }

              // we don't want to include completed action items, so don't push the last array if it's the complete array
              // (which, if the sorting worked, has to be the last progressArray)
              if (this.progressInfo[progressArray[0].actionData.progress_Id - 1].progress_Text != 'Complete') {
                this.actionItems.push(progressArray);
              }
            }
          );
        } 
        else {
          this.actionItems = r;
        }
        
        this.loadingCounter ++;
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
  
}


