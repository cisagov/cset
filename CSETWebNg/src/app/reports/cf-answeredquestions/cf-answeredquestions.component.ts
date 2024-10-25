import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { TranslocoService } from '@jsverse/transloco';
import { ConfigService } from '../../services/config.service';
import { QuestionsService } from '../../services/questions.service';
import { ReportService } from '../../services/report.service';

@Component({
  selector: 'app-cf-answeredquestions',
  templateUrl: './cf-answeredquestions.component.html',
  styleUrls: ['../reports.scss', './cf-answeredquestions.component.scss']
})
export class CfAnsweredQuestionsComponent implements OnInit {

  response: any;

  constructor(
    public tSvc: TranslocoService,
    public reportSvc: ReportService,
    public titleService: Title,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService
  ) {}

  ngOnInit() {

    this.reportSvc.getStandardAnsweredQuestions().subscribe(
      (r: any) => {        
        this.response = r;
        // r.standardsQuestions.forEach(element => {
        //   element.question = "<pre>"+element.question+"</pre>";
        // });
        this.titleService.setTitle(this.tSvc.translate('reports.all.answered statements.tab title'));
      }
    );
  }

}
