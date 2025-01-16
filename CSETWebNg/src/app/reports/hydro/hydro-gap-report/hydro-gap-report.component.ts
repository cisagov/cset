import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../services/assessment.service';
import { CisService } from '../../../services/cis.service';
import { HydroService } from '../../../services/hydro.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';
import { ReportService } from '../../../services/report.service';
import { QuestionsNestedService } from '../../../services/questions-nested.service';

@Component({
  selector: 'app-hydro-gap-report',
  templateUrl: './hydro-gap-report.component.html',
  styleUrls: ['./hydro-gap-report.component.scss', '../../reports.scss', '../../../../assets/sass/cset-font-styles.css','../../acet-reports.scss']
})
export class HydroGapReportComponent implements OnInit {

  demographics: any;
  actionItems: any[] = [];
  progressInfo: any[] = [];
  loadingCounter: number = 0;

  questionList: any;

  classArray: string[] = ['subheader btn-danger', 'subheader btn-primary', 'subheader btn-in-review', 'subheader btn-success'];

  questionMap: Map<string, any[]> = new Map<string, any[]>();
  doesGroupingHaveContentMap: Map<string, boolean> = new Map<string, boolean>();


  constructor(
    public reportSvc: ReportService,
    public assessSvc: AssessmentService,
    public questionsSvc: QuestionsService,
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public hydroSvc: HydroService,
    public nestedSvc: QuestionsNestedService
  ) {}

  ngOnInit() {
    this.reportSvc.getAssessmentInfoForReport().subscribe(
      (info: any) => {
        this.demographics = info;
  
        this.loadingCounter ++;
      },
      error => console.log('Assessment Information Error: ' + (<Error>error).message)
    );

    this.nestedSvc.getSection(0).subscribe(
      (r: any) => {
        console.log(r)
        this.questionList = r;
        // BOO! spoooooky quadruple for loop! Quiver in fear!
        this.questionList.groupings.forEach(domain => {
          domain.groupings.forEach(section => {
            section.groupings.forEach(subSection => {
              let isThereContent = false;
              subSection.questions.forEach(q => {
                let optionList = q.options.filter(x => x.selected == false);
                // if (optionList.length > 0) {
                  isThereContent = true;
                  this.questionMap.set(subSection.title + ' ' + q.sequence, optionList);
                // }
              });
              this.doesGroupingHaveContentMap.set(subSection.title, isThereContent)
            });
          });
        });
        console.log(this.questionMap)
        this.loadingCounter ++;
      });
  }

}
