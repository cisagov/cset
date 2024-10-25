import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { TranslocoService } from '@jsverse/transloco';
import { ConfigService } from '../../services/config.service';
import { QuestionsService } from '../../services/questions.service';
import { ReportService } from '../../services/report.service';

@Component({
  selector: 'app-cf-commentsmarked',
  templateUrl: './cf-commentsmarked.component.html',
  styleUrls: ['../reports.scss', './cf-commentsmarked.component.scss']
})
export class CfCommentsMarkedForReviewComponent implements OnInit{

  response: any;

  constructor(
    public tSvc: TranslocoService,
    public reportSvc: ReportService,
    public titleService: Title,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService
  ) {}

  ngOnInit() {

    this.reportSvc.getStandardCommentsAndMfr().subscribe(
      (r: any) => {
        this.response = r;
        this.titleService.setTitle(this.tSvc.translate('reports.all.cmfr.report title'));
      }
    );
  }

}
