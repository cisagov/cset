import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { TranslocoService } from '@jsverse/transloco';
import { ConfigService } from '../../../../services/config.service';
import { CyberFloridaService } from '../../../../services/cyberflorida.service';
import { QuestionsService } from '../../../../services/questions.service';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-ncsf-dashbord',
  templateUrl: './ncsf-dashbord.component.html',
  styleUrl: './ncsf-dashbord.component.scss'
})
export class NcsfDashbordComponent implements OnInit {
  barChart: any[];
  scores: any[];
  parsedScores: any[] = [];
  totalAvg: any;

  domainChart: any[] = [];

  answerView: any[] = [800, 500];
  categoryView: any[] = [800, 400];

  // options
  showXAxis = true;
  showYAxis = true;
  gradient = false;
  showLegend = false;
  showXAxisLabel = true;
  xAxisLabel = 'Selected';
  showYAxisLabel = true;
  yAxisLabel = 'Answer';

  xScaleMin: number = 7;

  loaded: number = 0;

  colorScheme = {
    domain: ['#706c6c', '#706c6c', '#706c6c', '#706c6c', '#706c6c', '#383444', '#383444', '#383444', '#383444']
  };

  categoryColorScheme = {
    domain: []
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
        this.barChart = r;
        this.loaded++;
    });

    this.cfSvc.getScoreBreakdown().subscribe(
      (r: any) => {
        console.log(r)
        this.scores = r;
        console.log(this.scores.filter(x => x.standard_Category == 'Govern'))
        this.parsedScores.push(this.scores.filter(x => x.standard_Category == 'Govern'));
        this.parsedScores.push(this.scores.filter(x => x.standard_Category == 'Identify'));
        this.parsedScores.push(this.scores.filter(x => x.standard_Category == 'Protect'));
        this.parsedScores.push(this.scores.filter(x => x.standard_Category == 'Detect'));
        this.parsedScores.push(this.scores.filter(x => x.standard_Category == 'Respond'));
        this.parsedScores.push(this.scores.filter(x => x.standard_Category == 'Recover'));
        this.loaded++;

        this.parsedScores.forEach(domain => {
          this.domainChart.push({"name": domain[0].standard_Category, "value": domain[0].groupAvg});
          this.categoryColorScheme.domain.push(domain[0].groupAvg < 5 ? '#706c6c' : '#383444');
        });
      });

    this.cfSvc.getTotalAverageForReports().subscribe(
      (r: any) => {
        this.totalAvg = r;
        this.loaded++;
    });
  }
}
