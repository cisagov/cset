////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
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

    r.vadrSummary.forEach(element => {
      let level = levelList.find(x => x.name == element.level_Name);
      if (!level) {
        level = {
          name: element.level_Name, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Alternate', value: 0 },
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
    r.vadrSummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.title);
      if (!goal) {
        goal = {
          name: element.title, series: [
            { name: 'Yes', value: 0 },
            { name: 'No', value: 0 },
            { name: 'Alternate', value: 0 },
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
    this.answerDistribByGoal.sort((a, b) => {
      if (a.name < b.name) {
        return -1;
      }
      if (a.name > b.name) {
        return 1;
      }
      return 0;
    });

    this.answerDistribByGoal.forEach(element => {
      var yesPercent = element.series.find(x => x.name == 'Yes').value;
      var altPercent = element.series.find(x => x.name == 'Alternate').value;

      var goal = { name: element.name, value: Math.round(yesPercent + altPercent) };
      goalList.push(goal);
    });

    this.complianceByGoal = goalList;
  }

  formatPercent(x: any) {
    return x + '%';
  }

}
