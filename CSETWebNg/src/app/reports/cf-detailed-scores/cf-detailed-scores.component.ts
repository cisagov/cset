import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { TranslocoService } from '@jsverse/transloco';
import { ConfigService } from '../../services/config.service';
import { CyberFloridaService } from '../../services/cyberflorida.service';
import { QuestionsService } from '../../services/questions.service';
import { ReportService } from '../../services/report.service';

@Component({
  selector: 'app-cf-detailed-scores',
  templateUrl: './cf-detailed-scores.component.html',
  styleUrls: ['../reports.scss', './cf-detailed-scores.component.scss', '../acet-reports.scss']
})
export class CfDetailedScoresComponent implements OnInit {
  barChart: any[];
  scores: any[];
  parsedScores: any[] = [];
  totalAvg: any;

  top5LowestPerSubcat: Map<string, any[]> = new Map<string, any[]>();

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
        this.barChart = r;
    });

    this.cfSvc.getScoreBreakdown().subscribe(
      (r: any) => {
        this.scores = r;
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

    this.cfSvc.getTop5Lowest().subscribe(
      (r: any) => {
        //todo: make a map of lists, 
        // with the top level being cats and then lists of subcats with the lowest 5 questions 

        let name = r[0].standard_Sub_Category;
        let questionsInThisSubcat = [];
        r.forEach(element => {
          if (element.standard_Sub_Category != name) {
            this.top5LowestPerSubcat.set(name, questionsInThisSubcat);
            questionsInThisSubcat = [];
            name = element.standard_Sub_Category;
          }
          questionsInThisSubcat.push(element);
        });
        this.top5LowestPerSubcat.set(name, questionsInThisSubcat);


        this.top5LowestPerSubcat.forEach(
          (value: any[], key: string) => {
            // filtering by ascending order of scores (0 - 7)
            value = value.sort((a,b) => a.answer_Value - b.answer_Value);

            // only include the 5 lowest, or everything if the subcat has 5 or less items
            if (value.length > 5) {
              value = value.slice(0, 5);
            }

            this.top5LowestPerSubcat.set(key, value);
        });
      });
  }

  getBackground(score: any) {
    let lowestLevelAchieved = score.toString();

    switch(lowestLevelAchieved.substring(0, 1)) {
      case 0:
        return '#706c6c !important';
      case 1:
        return 'red !important';
      default:
        return '#f5752b !important';
    }
  }

  convertScoreToPercent(score: any) {
    let wholeNum = (score*100) / 7;
    return wholeNum;
  }

}
