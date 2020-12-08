////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { CommonModule } from '@angular/common';
import { NavigationService } from '../../../../services/navigation.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { MaturityService } from '../../../../../app/services/maturity.service';
import { CmmcStyleService } from '../../../../services/cmmc-style.service';

@Component({
  selector: 'app-cmmc-compliance',
  templateUrl: './cmmc-compliance.component.html',
  styleUrls: ['/sass/cmmc-results.scss'],
  // tslint:disable-next-line:use-host-property-decorator
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

  whiteText = "rgba(255,255,255,1)"
  blueText = "rgba(31,82,132,1)"

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
        if (r.MaturityModels) {
          r.MaturityModels.forEach(model => {
            if (model.usesMaturityModel('CMMC')) {
              this.cmmcModel = model
              this.statsByLevel = this.generateStatsByLevel(this.cmmcModel.StatsByLevel)
              // this.statsByDomain = this.cmmcModel.StatsByDomain
              // this.statsByDomainAtUnderTarget = this.cmmcModel.StatsByDomainAtUnderTarget;
              this.stackBarChartData = this.generateStackedBarChartData(this.statsByLevel)
              this.complianceLevelAcheivedData = this.getComplianceLevelAcheivedData(this.statsByLevel)
            }
          });
          window.dispatchEvent(new Event('resize'));
        }
        this.initialized = true;
      },
      error => {
        this.dataError = true;
        this.initialized = true;
        console.log('Site Summary report load Error: ' + (<Error>error).message)
      }
    ), (finish) => {
    };
  }

  generateStatsByLevel(data) {
    let outputData = data.filter(obj => obj.ModelLevel != "Aggregate")
    outputData.sort((a, b) => (a.ModelLevel > b.ModelLevel) ? 1 : -1)
    let totalAnsweredCount = 0
    let totalUnansweredCount = 0
    outputData.forEach(element => {
      totalUnansweredCount += element.questionUnAnswered;
      totalAnsweredCount += element.questionAnswered;
      element["totalUnansweredCount"] = totalUnansweredCount;
      element["totalAnsweredCount"] = totalAnsweredCount;
    });
    return outputData
  }

  generateStackedBarChartData(data) {
    let clonedArray = JSON.parse(JSON.stringify(data)) //Easy way to deep copy array
    let sortedData = clonedArray.sort((a, b) => (a.ModelLevel > b.ModelLevel) ? 1 : -1)
    let outputData = []

    if (!this.totalCMMCQuestions) {
      this.getTotalCMMCQuestion(data);
    }
    for (let i = 0; i < sortedData.length; i++) {
      let dataEle = []
      if (i == 0) {
        // dataEle.push(data[i])
      } else {
        outputData[i - 1].forEach(outputEle => {
          dataEle.push(outputEle)
        });
      }
      this.getStackBarChartData(sortedData[i], this.totalCMMCQuestions).forEach(element => {
        dataEle.unshift(element)
      });
      outputData.push(dataEle)
    }
    return outputData
  }

  getComplianceLevelAcheivedData(data) {
    let acheivedLevel = 0;
    let questionAnsweredWithinTarget = 0;
    let totalQuestionsInTargetRange = 0;

    data.forEach(element => {
      if (!element.questionUnAnswered) {
        acheivedLevel = element.ModelLevel
      }
      if (element.ModelLevel <= this.cmmcModel.TargetLevel) {
        questionAnsweredWithinTarget += element.questionAnswered
        totalQuestionsInTargetRange += element.questionCount
      }
    });

    return {
      targetLevel: this.cmmcModel.TargetLevel,
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
        modelLevel: data.ModelLevel,
        totalQuestions: totalQuestionCount
      }, {
        count: data.questionUnAnswered,
        totalForLevel: data.questionCount,
        type: "No",
        modelLevel: data.ModelLevel,
        totalQuestions: totalQuestionCount
      }
    ]
  }


  getStackedChartSectionStyle(data) {
    let retVal = []
    //background color
    if (data.type == "Yes" || data.modelLevel > this.cmmcModel.TargetLevel) {
      retVal["background"] = this.getGradient(`blue-${data.modelLevel}`, 1, true)
    }
    else {
      retVal["background"] = this.getGradient("orange")
    }
    //textcolor
    if (data.modelLevel >= 4) {
      retVal["color"] = this.blueText
    }

    // if(data.count > (data.totalForLevel / 2)) {
    //   retVal["innerHtml"] = `${data.count} / ${data.totalForLevel}`
    // }

    //Determine if section should be displayed and size if so
    if (data.modelLevel <= this.cmmcModel.TargetLevel) {
      if (data.count == 0) {
        retVal["display"] = "none";
      } else {
        let levelToTotalRatio = data.totalForLevel / data.totalQuestions
        let sectionToLevelRatio = (data.count / data.totalForLevel)
        let sectionPercent = (levelToTotalRatio * sectionToLevelRatio) * 100
        retVal["flex-basis"] = `calc(${sectionPercent}% + var(--corner-size))`
      }
    } else {
      if (data.type == "No") {
        retVal["display"] = "none";
      } else {
        let levelToTotalRatio = data.totalForLevel / data.totalQuestions
        let sectionPercent = levelToTotalRatio * 100
        retVal["flex-basis"] = `calc(${sectionPercent}% + var(--corner-size))`
      }
    }

    return retVal
  }

  getTotalCMMCQuestion(data) {
    this.totalCMMCQuestions = 0

    data.forEach(element => {
      if (element.questionCountAggregateForLevelAndBelow > this.totalCMMCQuestions) {
        this.totalCMMCQuestions = element.questionCountAggregateForLevelAndBelow
      }
    });
  }

  getGradient(color, alpha = 1, reverse = false) {
    let vals = {
      color_one: "",
      color_two: ""
    }
    alpha = 1
    switch (color) {
      case "blue":
      case "blue-1": {
        vals["color_one"] = `rgba(31,82,132,${alpha})`
        vals["color_two"] = `rgba(58,128,194,${alpha})`
        break;
      }
      case "blue-2": {
        vals["color_one"] = `rgba(75,116,156,${alpha})`
        vals["color_two"] = `rgba(97,153,206,${alpha})`
        break;
      }
      case "blue-3": {
        vals["color_one"] = `rgba(120,151,156,${alpha})`
        vals["color_two"] = `rgba(137,179,218,${alpha})`
        break;
      }
      case "blue-4": {
        vals["color_one"] = `rgba(165,185,205,${alpha})`
        vals["color_two"] = `rgba(176,204,230,${alpha})`
        break;
      }
      case "blue-5": {
        vals["color_one"] = `rgba(210,220,230,${alpha})`
        vals["color_two"] = `rgba(216,229,243,${alpha})`
        break;
      }
      case "green": {
        vals["color_one"] = `rgba(98,154,109,${alpha})`
        vals["color_two"] = `rgba(31,77,67,${alpha})`
        break;
      }
      case "grey": {
        vals["color_one"] = `rgba(98,98,98,${alpha})`
        vals["color_two"] = `rgba(120,120,120,${alpha})`
        break;
      }
      case "orange": {
        vals["color_one"] = `rgba(255,190,41,${alpha})`
        vals["color_two"] = `rgba(224,217,98,${alpha})`
        break;
      }
    }
    if (reverse) {
      let tempcolor = vals["color_one"]
      vals["color_one"] = vals["color_two"]
      vals["color_two"] = tempcolor
    }
    return `linear-gradient(5deg,${vals['color_one']} 0%, ${vals['color_two']} 100%)`
  }

}
