import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { TranslocoService } from '@jsverse/transloco';
import { ConfigService } from '../../../../services/config.service';
import { CyberFloridaService } from '../../../../services/cyberflorida.service';
import { QuestionsService } from '../../../../services/questions.service';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-nscf-control-priorities',
  templateUrl: './nscf-control-priorities.component.html',
  styleUrl: './nscf-control-priorities.component.scss'
})
export class NscfControlPrioritiesComponent implements OnInit{

  top5LowestPerCat: Map<string, any[]> = new Map<string, any[]>();
  scores: any[];
  parsedScores: any[] = [];
  totalAvg: any;
  loaded: number = 0;

  constructor(
    public cfSvc: CyberFloridaService,
    public tSvc: TranslocoService,
    public reportSvc: ReportService,
    public titleService: Title,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService
  ) {}

  ngOnInit() {
    this.cfSvc.getTop5Lowest().subscribe(
      (r: any) => {
        //todo: make a map of lists, 
        // with the top level being cats and then lists of subcats with the lowest 5 questions 

        let name = r[0].standard_Category;
        let questionsInThisCat = [];
        r.forEach(element => {
          if (element.standard_Category != name) {
            this.top5LowestPerCat.set(name, questionsInThisCat);
            questionsInThisCat = [];
            name = element.standard_Category;
          }
          questionsInThisCat.push(element);
        });
        this.top5LowestPerCat.set(name, questionsInThisCat);


        this.top5LowestPerCat.forEach(
          (value: any[], key: string) => {
            // filtering by ascending order of scores (0 - 7)
            value = value.sort((a,b) => a.answer_Value - b.answer_Value);

            // only include the 5 lowest, or everything if the subcat has 5 or less items
            if (value.length > 5) {
              value = value.slice(0, 5);
            }

            this.top5LowestPerCat.set(key, value);
        });
        this.loaded++;
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
          this.loaded++;
        });
  
        this.cfSvc.getTotalAverageForReports().subscribe(
          (r: any) => {
            this.loaded++;

            this.totalAvg = r;
        });
  }
}
