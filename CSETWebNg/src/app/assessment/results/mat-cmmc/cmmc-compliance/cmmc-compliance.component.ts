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
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { Title } from '@angular/platform-browser';
import { MaturityService } from '../../../../../app/services/maturity.service';
import { CmmcStyleService } from '../../../../services/cmmc-style.service';

@Component({
  selector: 'app-cmmc-compliance',
  templateUrl: './cmmc-compliance.component.html',
  styleUrls: ['../../../../../sass/cmmc-results.scss'],
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CmmcComplianceComponent implements OnInit {

  initialized = false;
  dataError = false;
  response;
  cmmcModel;
  totalCMMCQuestions;
  stackBarChartData;
  complianceLevelAcheivedData;
  statsByLevel;

  whiteText = "rgba(255,255,255,1)";
  blueText = "rgba(31,82,132,1)";

  stackedChartHeaderLabels = {
    1: "Basic Cyber Hygiene",
    2: "Intermediate Cyber Hygiene",
    3: "Good Cyber Hygiene",
    4: "Proactive",
    5: "Advanced / Progressive"
  }

  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    private titleService: Title,
    public cmmcStyleSvc: CmmcStyleService
  ) { }

  ngOnInit(): void {
    this.maturitySvc.getResultsData('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;

        if (r.maturityModels) {
          r.maturityModels.forEach(model => {
            if (model.maturityModelName === 'CMMC') {
              this.cmmcModel = model;
              this.statsByLevel = this.generateStatsByLevel(this.cmmcModel.statsByLevel);
              this.stackBarChartData = this.generateStackedBarChartData(this.statsByLevel);
              this.complianceLevelAcheivedData = this.getComplianceLevelAcheivedData(this.statsByLevel);
            }
          });
          window.dispatchEvent(new Event('resize'));
        }
        this.initialized = true;
      },
      error => {
        this.dataError = true;
        this.initialized = true;
        console.log('Site Summary report load Error: ' + (<Error>error).message);
      }
    ), (finish) => {
    };
  }

  generateStatsByLevel(data) {
    let outputData = data.filter(obj => obj.modelLevel != "Aggregate");
    outputData.sort((a, b) => (a.modelLevel > b.modelLevel) ? 1 : -1);
    let totalAnsweredCount = 0;
    let totalUnansweredCount = 0;
    outputData.forEach(element => {
      totalUnansweredCount += element.questionUnAnswered;
      totalAnsweredCount += element.questionAnswered;
      element["totalUnansweredCount"] = totalUnansweredCount;
      element["totalAnsweredCount"] = totalAnsweredCount;
    });
    return outputData;
  }

  generateStackedBarChartData(data) {
    let clonedArray = JSON.parse(JSON.stringify(data)); //Easy way to deep copy array
    let sortedData = clonedArray.sort((a, b) => (a.modelLevel > b.modelLevel) ? 1 : -1);
    let outputData = [];

    if (!this.totalCMMCQuestions) {
      this.getTotalCMMCQuestion(data);
    }
    for (let i = 0; i < sortedData.length; i++) {
      let dataEle = [];
      if (i == 0) {
        // dataEle.push(data[i])
      } else {
        outputData[i - 1].forEach(outputEle => {
          dataEle.push(outputEle);
        });
      }
      this.getStackBarChartData(sortedData[i], this.totalCMMCQuestions).forEach(element => {
        dataEle.unshift(element);
      });
      outputData.push(dataEle);
    }
    return outputData;
  }

  getComplianceLevelAcheivedData(data) {
    let acheivedLevel = 0;
    let questionAnsweredWithinTarget = 0;
    let totalQuestionsInTargetRange = 0;

    data.forEach(element => {
      if (!element.questionUnAnswered) {
        acheivedLevel = element.modelLevel;
      }
      if (element.modelLevel <= this.cmmcModel.targetLevel) {
        questionAnsweredWithinTarget += element.questionAnswered;
        totalQuestionsInTargetRange += element.questionCount;
      }
    });

    return {
      targetLevel: this.cmmcModel.targetLevel,
      acheivedLevel: acheivedLevel,
      questionsAnsweredWithinLevel: questionAnsweredWithinTarget,
      questionsTotalWithinLevel: totalQuestionsInTargetRange
    };
  }

  getStackBarChartData(data, totalQuestionCount) {
    return [
      {
        count: data.questionAnswered,
        totalForLevel: data.questionCount,
        type: "Yes",
        modelLevel: data.modelLevel,
        totalQuestions: totalQuestionCount
      }, {
        count: data.questionUnAnswered,
        totalForLevel: data.questionCount,
        type: "No",
        modelLevel: data.modelLevel,
        totalQuestions: totalQuestionCount
      }
    ];
  }


  getTotalCMMCQuestion(data) {
    this.totalCMMCQuestions = 0;

    data.forEach(element => {
      if (element.questionCountAggregateForLevelAndBelow > this.totalCMMCQuestions) {
        this.totalCMMCQuestions = element.questionCountAggregateForLevelAndBelow;
      }
    });
  }

}
