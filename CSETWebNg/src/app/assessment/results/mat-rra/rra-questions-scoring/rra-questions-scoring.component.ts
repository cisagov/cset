import { Component, OnInit } from '@angular/core';
import { RraDataService } from '../../../../services/rra-data.service';

@Component({
  selector: 'app-rra-questions-scoring',
  templateUrl: './rra-questions-scoring.component.html',
  styleUrls: ['./rra-questions-scoring.component.scss', '../../../../reports/reports.scss']
})

export class RraQuestionsScoringComponent implements OnInit {

  goalTable = [];
  constructor(public rraDataSvc: RraDataService) { }

  ngOnInit(): void {
    this.rraDataSvc.getRRADetail().subscribe((r: any) => {
      this.createGoalTable(r);
    });
  }

  createGoalTable(r: any) {
    let goalList = [];
    r.rraSummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.title);
      if (!goal) {
        goal = {
          name: element.title,
          yes: 0,
          no: 0,
          unanswered: 0
        };
        goalList.push(goal);
      }

      switch (element.answer_Text) {
        case 'Y':
          goal.yes = element.qc;
          break;
        case 'N':
          goal.no = element.qc;
          break;
        case 'U':
          goal.unanswered = element.qc
          break;
      }
    });

    goalList.forEach(g => {
      g.total = g.yes + g.no + g.unanswered;
      g.percent = ((g.yes / g.total) * 100).toFixed(1);
    });

    this.goalTable = goalList;
  }

}
