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
  selector: 'app-vadr-questions-scoring',
  templateUrl: './vadr-questions-scoring.component.html',
  styleUrls: ['./vadr-questions-scoring.component.scss']
})
export class VadrQuestionsScoringComponent implements OnInit {

  goalTable = [];
  constructor(public vadrDataSvc: VadrDataService) { }

  ngOnInit(): void {
    this.vadrDataSvc.getVADRDetail().subscribe((r: any) => {
      this.createGoalTable(r);
    });
  }

  createGoalTable(r: any) {
    let goalList = [];

    // sort by title for readability
    r.vadrSummaryByGoal.sort((a, b) => {
      if (a.title < b.title) {
        return -1;
      }
      if (a.title > b.title) {
        return 1;
      }
      return 0;
    });

    r.vadrSummaryByGoal.forEach(element => {
      let goal = goalList.find(x => x.name == element.title);
      if (!goal) {
        goal = {
          name: element.title,
          yes: 0,
          no: 0,
          alt: 0,
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
        case 'A':
          goal.alt = element.qc;
          break;
        case 'U':
          goal.unanswered = element.qc
          break;
      }
    });

    goalList.forEach(g => {
      g.total = g.yes + g.no + + g.alt + g.unanswered;
      g.percent = (((g.yes + g.alt) / g.total) * 100).toFixed(1);
    });

    this.goalTable = goalList;
  }

}
