import { Component, OnInit } from '@angular/core';
import { CyberFloridaService } from '../../services/cyberflorida.service';
import { TranslocoService } from '@jsverse/transloco';
import { Title } from '@angular/platform-browser';
import { ConfigService } from '../../services/config.service';
import { QuestionsService } from '../../services/questions.service';
import { ReportService } from '../../services/report.service';

@Component({
  selector: 'app-cf-reviewed',
  templateUrl: './cf-reviewed.component.html',
  styleUrls: ['../reports.scss', './cf-reviewed.component.scss']
})
export class CfReviewedComponent implements OnInit {
  single: any[];
  multi: any[];

  view: any[] = [800, 500];

  // options
  showXAxis = true;
  showYAxis = true;
  gradient = false;
  showLegend = false;
  showXAxisLabel = true;
  xAxisLabel = 'Answer';
  showYAxisLabel = true;
  yAxisLabel = 'Selected';

  colorScheme = {
    domain: ['#706c6c', '#706c6c', '#706c6c', '#706c6c', '#706c6c', '#383444', '#383444', '#383444', '#383444']
  };

  constructor(
    public cfSvc: CyberFloridaService,
    public tSvc: TranslocoService,
    public reportSvc: ReportService,
    public titleService: Title,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService
  ) {}

  ngOnInit() {
    this.cfSvc.getBarChartInfo().subscribe(
      (r: any) => {
        console.log(r)
        this.single = r;
    });
  }
}
