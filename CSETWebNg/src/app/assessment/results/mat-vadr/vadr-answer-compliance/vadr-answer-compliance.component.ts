import { Component, OnInit } from '@angular/core';
import { VadrDataService } from '../../../../services/vadr-data.service';


@Component({
  selector: 'app-vadr-answer-compliance',
  templateUrl: './vadr-answer-compliance.component.html',
  styleUrls: ['./vadr-answer-compliance.component.scss']
})
export class VadrAnswerComplianceComponent implements OnInit {
  complianceByGoal = [];
  answerDistribByGoal = [];
  answerDistribByLevel = [];

  colorScheme1 = { domain: ['#007BFF'] };
  xAxisTicks = [0, 25, 50, 75, 100];

  constructor(public vadrDataSvc: VadrDataService) { }

  ngOnInit(): void {
    this.vadrDataSvc.getVADRDetail().subscribe((r: any) => {
      this.createAnswerDistribByGoal(r);
      this.createAnswerDistribByLevel(r);
      this.createComplianceByGoal(r);
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

  createAnswerDistribByGoal(r: any) {
    let goalList = [];
    r.rraSummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.title);
      if (!goal) {
        goal = {
          name: element.title, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Unanswered', value: 0 },
          ]
        };
        goalList.push(goal);
      }

      var p = goal.series.find(x => x.name == element.answer_Full_Name);
      p.value = element.percent;
    });

    this.answerDistribByGoal = goalList;
  }

  createComplianceByGoal(r: any) {
    let goalList = [];
    this.answerDistribByGoal.forEach(element => {
      var yesPercent = element.series.find(x => x.name == 'Yes').value;

      var goal = { name: element.name, value: Math.round(yesPercent) };
      goalList.push(goal);
    });

    this.complianceByGoal = goalList;
  }

  formatPercent(x: any) {
    return x + '%';
  }

}
