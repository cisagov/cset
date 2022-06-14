import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { data } from 'jquery';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-open-ended-questions',
  templateUrl: './open-ended-questions.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss']
})
export class OpenEndedQuestionsComponent implements OnInit {

  response: any;

  colorSchemeRed = { domain: ['#DC3545'] };
  xAxisTicks = [0, 25, 50, 75, 100];

  answerDistribByGoal = [];
  topRankedGoals = [];

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public maturitySvc: MaturityService
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Validated Architecture Design Review Report - VADR");
this.maturitySvc.getMaturityOpenEndedQuestions("VADR").subscribe(data=>{
  console.log(data);
})
    this.maturitySvc.getMaturityDeficiency("VADR").subscribe(
      (r: any) => {
        this.response = r;
        console.log(r)
        // remove any child questions - they are not Y/N
        this.response.deficienciesList = this.response.deficienciesList.filter(x => x.mat.parent_Question_Id == null);
      },
      error => console.log('Deficiency Report Error: ' + (<Error>error).message)
    );
  }


  previous = 0;
  shouldDisplay(next) {
    if (next == this.previous) {
      return false;
    }
    else {
      this.previous = next;
      return true;
    }
  }


}

