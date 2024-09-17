import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { ACETService } from '../../../../services/acet.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { NCUAService } from '../../../../services/ncua.service';
import { ObservationsService } from '../../../../services/observations.service';
import { ReportService } from '../../../../services/report.service';


@Component({
  selector: 'app-report-list-common',
  templateUrl: './report-list-common.component.html'
})

export class ReportListCommonComponent implements OnChanges {
  @Input() sectionId: string;

  jsonData: any;
  reportList: any[] = [];

  constructor(public assessSvc: AssessmentService,
    public ncuaSvc: NCUAService,
    public observationsSvc: ObservationsService,
    public acetSvc: ACETService,
    public reportSvc: ReportService
  ) {
    // Load JSON data 
    this.jsonData = require('./report-list.json');
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['sectionId']) {
      this.reportList = this.getReportList(this.sectionId);

      if (this.assessSvc.isISE()) {
        this.reportList = this.iseCheckAndSetDisabled(this.reportList);
      }
    }
  }

  getReportList(sectionId: string): any[] {
    const result = this.jsonData.find(item => item.title === sectionId);
    // Check if the result exists and return the reportList or an empty array if not found
    return result ? result.reportList : [];
  }

  iseCheckAndSetDisabled(reportList: any[]) {
    if (!this.ncuaSvc.ISE_StateLed) {
      this.acetSvc.getIseAnswerCompletionRate().subscribe((percentAnswered: number) => {
        this.reportSvc.disableIseReportLinks = percentAnswered == 100 ? false : true;

        this.observationsSvc.getAssessmentObservations().subscribe(
          (observations: any) => {
            let title = '';
            this.ncuaSvc.issuesForSubmission = observations;
            this.ncuaSvc.unassignedIssueTitles = [];
            for (let i = 0; i < observations?.length; i++) {
              // substringed this way to cut off the '+' from 'CORE+' so it's still included with a CORE assessment
              if (
                this.ncuaSvc.translateExamLevel(observations[i]?.question?.maturity_Level_Id).substring(0, 4) ==
                this.ncuaSvc.getExamLevel().substring(0, 4)
              ) {
                if (observations[i]?.finding?.type == null || observations[i]?.finding?.type == '') {
                  title = observations[i]?.category?.title + ', ' + observations[i]?.question?.question_Title;
                  this.ncuaSvc.unassignedIssueTitles.push(title);
                }
              }
            }
            if (this.ncuaSvc.unassignedIssueTitles?.length == 0) {
              this.ncuaSvc.unassignedIssues = false;
            } else {
              this.ncuaSvc.unassignedIssues = true;
            }

            //
            if (this.ncuaSvc.creditUnionName == null || this.ncuaSvc.creditUnionName == '') {
              reportList[0].disabled = true;
              reportList[1].disabled = true;
            }
        
            else if (this.ncuaSvc.assetsAsNumber == null || this.ncuaSvc.assetsAsNumber == 0) {
              reportList[0].disabled = true;
              reportList[1].disabled = true;            
            }
            else if (this.ncuaSvc.unassignedIssues) {
              reportList[0].disabled = true;
              reportList[1].disabled = true;            
            }
            else if (this.reportSvc.disableIseReportLinks) {
              reportList[0].disabled = true;
              reportList[1].disabled = true;            
            }
            else {
              reportList[0].disabled = false;
              reportList[1].disabled = false;
            }
            //
          },
          (error) => console.log('Observations Error: ' + (<Error>error).message)
        );
      });
      
    } else {
      this.acetSvc.getIseAnswerCompletionRate().subscribe((percentAnswered: number) => {
        this.reportSvc.disableIseReportLinks = percentAnswered == 100 ? false : true;
      });
      
      reportList[0].disabled = false;
      reportList[1].disabled = false;
    }
    
    return reportList;
  }
}
