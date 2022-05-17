import { Component, OnInit } from '@angular/core';
import { VadrDataService } from '../../../../services/vadr-data.service';

@Component({
  selector: 'app-vadr-answer-distribution',
  templateUrl: './vadr-answer-distribution.component.html',
  styleUrls: ['./vadr-answer-distribution.component.scss']
})
export class VadrAnswerDistributionComponent implements OnInit {
  answerDistribByLevel = [];
  xAxisTicks = [0, 25, 50, 75, 100];
  answerDistribColorScheme = { domain: ['#28A745', '#DC3545', '#c3c3c3'] };

  constructor(public vadrDataSvc: VadrDataService) { }

  ngOnInit(): void {
    this.vadrDataSvc.getVADRDetail().subscribe((r: any) => {
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
