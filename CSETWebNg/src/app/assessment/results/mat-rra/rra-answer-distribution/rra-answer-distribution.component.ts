import { Component, OnInit } from '@angular/core';
import { RraDataService } from '../../../../services/rra-data.service';

@Component({
  selector: 'app-rra-answer-distribution',
  templateUrl: './rra-answer-distribution.component.html',
  styleUrls: ['./rra-answer-distribution.component.scss']
})
export class RraAnswerDistributionComponent implements OnInit {
  answerDistribByLevel = [];
  xAxisTicks = [0, 25, 50, 75, 100];
  answerDistribColorScheme = { domain: ['#006100', '#9c0006', '#888888'] };

  constructor(public rraDataSvc: RraDataService) { }

  ngOnInit(): void {
    this.rraDataSvc.getRRADetail().subscribe((r: any) => {
      this.createAnswerDistribByLevel(r);
    });
  }

  createAnswerDistribByLevel(r: any) {
    let levelList = [];
    r.rraSummary.forEach(element => {
      let level = levelList.find(x => x.name == element.level_Name);
      if (!level) {
        level = {
          name: element.level_Name, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Unanswered', value: 0 },
          ]
        };
        levelList.push(level);
      }

      var p = level.series.find(x => x.name == element.answer_Full_Name);
      p.value = element.percent;
    });

    this.answerDistribByLevel = levelList;
  }

  formatPercent(x: any) {
    return x + '%';
  }
}
