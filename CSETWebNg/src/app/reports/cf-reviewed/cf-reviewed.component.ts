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
  styleUrls: ['../reports.scss', './cf-reviewed.component.scss', '../acet-reports.scss']
})
export class CfReviewedComponent implements OnInit {
  barChart: any[];
  scores: any[];
  parsedScores: any[] = [];
  totalAvg: any;

  view: any[] = [800, 500];

  // options
  showXAxis = true;
  showYAxis = true;
  gradient = false;
  showLegend = false;
  showXAxisLabel = true;
  xAxisLabel = 'Selected';
  showYAxisLabel = true;
  yAxisLabel = 'Answer';

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
        this.barChart = r;
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
      });

    this.cfSvc.getTotalAverageForReports().subscribe(
      (r: any) => {
        this.totalAvg = r;
    });

    // this.cfSvc.getTop5Lowest().subscribe(
    //   (r: any) => {
    //     console.log(r)
    //     // this.scores = r;
    //     // console.log(this.scores.filter(x => x.standard_Category == 'Govern'))
        
    //   });
  }

  getBackground(score: any) {
    let lowestLevelAchieved = score.toString();
    return 'progress-bar-dot';
  }

  convertScoreToPercent(score: any) {
    let wholeNum = (score*100) / 7;
    // let remainder = (score*100) % 7;
    // console.log('remainder: ' + remainder )

    // let num = +(wholeNum.toString() + '.' + remainder.toString());
    // console.log(num)
    return wholeNum;
  }
}
