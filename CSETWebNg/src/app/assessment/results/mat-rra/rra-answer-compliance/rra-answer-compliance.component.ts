import { Component, OnInit } from '@angular/core';
import { RraDataService } from '../../../../services/rra-data.service';
@Component({
  selector: 'app-rra-answer-compliance',
  templateUrl: './rra-answer-compliance.component.html',
  styleUrls: ['./rra-answer-compliance.component.scss']
})
export class RraAnswerComplianceComponent implements OnInit {
  complianceByGoal = [];
  answerDistribByGoal = [];
  answerDistribByLevel = [];

  colorScheme1 = { domain: ['#0A5278'] };
  xAxisTicks = [0, 25, 50, 75, 100];

  constructor(public rraDataSvc: RraDataService) { }

  ngOnInit(): void {
    this.rraDataSvc.getRRADetail().subscribe((r: any) => {
      this.createAnswerDistribByGoal(r);
      this.createAnswerDistribByLevel(r);
      this.createComplianceByGoal(r);
    });
  }

  createAnswerDistribByLevel(r: any) {
    let levelList = [];
    r.RRASummary.forEach(element => {
      let level = levelList.find(x => x.name == element.Level_Name);
      if (!level) {
        level = {
          name: element.Level_Name, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Unanswered', value: 0 },
          ]
        };
        levelList.push(level);
      }

      var p = level.series.find(x => x.name == element.Answer_Full_Name);
      p.value = element.Percent;
    });

    this.answerDistribByLevel = levelList;
  }

  createAnswerDistribByGoal(r: any) {
    let goalList = [];
    r.RRASummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.Title);
      if (!goal) {
        goal = {
          name: element.Title, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Unanswered', value: 0 },
          ]
        };
        goalList.push(goal);
      }

      var p = goal.series.find(x => x.name == element.Answer_Full_Name);
      p.value = element.Percent;
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
