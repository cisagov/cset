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
  selector: 'app-vadr-answer-counts',
  templateUrl: './vadr-answer-counts.component.html',
  styleUrls: ['./vadr-answer-counts.component.scss']
})
export class VadrAnswerCountsComponent implements OnInit {

  sAxisTicks = [0, 5, 10, 15, 18];
  maxLevel = 0;
  answerCountsByLevel = [];
  answerDistribColorScheme = { domain: ['#28A745', '#DC3545', '#c3c3c3'] };

  constructor(public vadrDataSvc: VadrDataService) { }

  ngOnInit(): void {
    this.vadrDataSvc.getVADRDetail().subscribe((r: any) => {
      this.createAnswerCountsByLevel(r);
    });
  }

  createAnswerCountsByLevel(r: any) {
    let levelList = [];

    r.vadrSummary.forEach(element => {
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
      p.value = element.qc;
    });
    this.answerCountsByLevel = levelList;
    this.findMaxLength();
  }

  findMaxLength() {
    let mLength = 0;
    this.answerCountsByLevel.forEach(x => {
      let length = 0;
      x.series.forEach(y => {
        length += y.value;
      });
      if (mLength < length) {
        mLength = length;
      }
    })
    this.maxLevel = mLength;
  }

}
