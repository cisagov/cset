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
        console.log(r)
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

        console.log(this.top5LowestPerSubcat)

        // let governPortion = r.filter(x => x.standard_Category == 'Govern').sort((a,b) => a.answer_Value - b.answer_Value);
        // let identifyPortion = r.filter(x => x.standard_Category == 'Identify').sort((a,b) => a.answer_Value - b.answer_Value);
        // let protectPortion = r.filter(x => x.standard_Category == 'Protect').sort((a,b) => a.answer_Value - b.answer_Value);
        // let detectPortion = r.filter(x => x.standard_Category == 'Detect').sort((a,b) => a.answer_Value - b.answer_Value);
        // let respondPortion = r.filter(x => x.standard_Category == 'Respond').sort((a,b) => a.answer_Value - b.answer_Value);
        // let recoverPortion = r.filter(x => x.standard_Category == 'Recover').sort((a,b) => a.answer_Value - b.answer_Value);

        // this.top5LowestPerSubcat.push(governPortion.length > 5 ? governPortion.slice(0, 5) : governPortion);
        // this.top5LowestPerSubcat.push(identifyPortion.length > 5 ? identifyPortion.slice(0, 5) : identifyPortion);
        // this.top5LowestPerSubcat.push(protectPortion.length > 5 ? protectPortion.slice(0, 5) : protectPortion);
        // this.top5LowestPerSubcat.push(detectPortion.length > 5 ? detectPortion.slice(0, 5) : detectPortion);
        // this.top5LowestPerSubcat.push(respondPortion.length > 5 ? respondPortion.slice(0, 5) : respondPortion);
        // this.top5LowestPerSubcat.push(recoverPortion.length > 5 ? recoverPortion.slice(0, 5) : recoverPortion);
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
    // return 'cf-' + lowestLevelAchieved.substring(0, 1);
  }

  convertScoreToPercent(score: any) {
    let wholeNum = (score*100) / 7;
    // let remainder = (score*100) % 7;
    // console.log('remainder: ' + remainder )

    // let num = +(wholeNum.toString() + '.' + remainder.toString());
    // console.log(num)
    return wholeNum;
  }

  getTextStyle(index: number, subcat: string) {
    // if not the final
    if ((index + 1) < this.top5LowestPerSubcat.get(subcat).length) {

    }
  }

}
