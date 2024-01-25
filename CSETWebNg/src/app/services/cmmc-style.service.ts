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
import { Injectable } from '@angular/core';
import { DomSanitizer, Title } from '@angular/platform-browser';
import { BehaviorSubject, Observable } from 'rxjs';
import { ConfigService } from './config.service';
import { ReportAnalysisService } from './report-analysis.service';
import { ReportService } from './report.service';

@Injectable()
export class CmmcStyleService {
  pieChartVals = "";
  pieColorNo = "#990000";

  cmmcModel;
  complianceLevelAcheivedData;
  statsByLevel;

  //Level descriptions for pie charts
  levelDescriptions = {
    1: "Safeguard Federal Contract Information (FCI)",
    2: "Serves as a transition step in cybersecurity maturity progression to protect CUI",
    3: "Protect Controlled Unclassified Information (CUI)",
    4: "Protect CUI and reduce risk of Advanced Persistent Threats (APTs)",
    5: "Protect CUI and reduce risk of Advanced Persistent Threats (APTs)",
  }

  blueGradient = "linear-gradient(5deg, rgba(31,82,132,1) 0%, rgba(58,128,194,1) 100%)"
  greenGradient = "linear-gradient(5deg, rgba(98,154,109,1) 0%, rgba(31,77,67,1) 100%)"
  grayGradient = "linear-gradient(5deg, rgba(98,98,98,1) 0%, rgba(120,120,120,1) 100%)"

  blueText = "rgba(31,82,132,1)"
  greenText = "rgba(60,110,85,1)"
  whiteText = "rgba(255,255,255,1)"

  statsByDomain;
  statsByDomainAtUnderTarget;
  gridColumnCount = 10
  gridColumns = new Array(this.gridColumnCount);

  columnWidthEmitter: BehaviorSubject<number>;
  columnWidthPx = 25;

  ngstyleCalls = 0;


  stackBarChartData;
  totalCMMCQuestions;
  stackedChartHeaderLabels = {
    1: "Basic Cyber Hygiene",
    2: "Intermediate Cyber Hygiene",
    3: "Good Cyber Hygiene",
    4: "Proactive",
    5: "Advanced / Progressive"
  }
  divElement: HTMLElement;

  response: any;
  pageInitialized = false;
  referenceTable: any;


  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    private sanitizer: DomSanitizer
  ) {
    this.columnWidthEmitter = new BehaviorSubject<number>(25)


  }

  initialize = new Observable((observer) => {
    this.reportSvc.getReport('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;

        if (r.maturityModels) {
          this.cmmcModel = r.maturityModels.find(m => m.maturityModelName === 'CMMC');

          this.statsByLevel = this.generateStatsByLevel(this.cmmcModel.statsByLevel);
          this.statsByDomain = this.cmmcModel.statsByDomain;
          this.statsByDomainAtUnderTarget = this.cmmcModel.statsByDomainAtUnderTarget;
          this.stackBarChartData = this.generateStackedBarChartData(this.statsByLevel);
          this.complianceLevelAcheivedData = this.getComplianceLevelAcheivedData(this.statsByLevel);
          this.referenceTable = this.generateReferenceList(this.cmmcModel.maturityQuestions, this.cmmcModel.targetLevel);

          observer.next();

          window.dispatchEvent(new Event('resize'));
        }
      },
      error => console.log('CMMC Style Service load Error: ' + (<Error>error).message)
    ), (finish) => {
      observer.complete();
    };

  });

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

  getRadi(i) {
    let degreeOfNo = Math.round(i.questionUnAnswered / i.questionCount * 360)
    let val = {
      backgroundImage: `conic-gradient(${this.pieColorNo} ${degreeOfNo}deg, rgba(0,0,0,0) 0 1deg)`
    }
    return val
  }

  getBorder(input) {
    return `solid ${input} black`
  }

  getBarSettings(input) {
    let width = Math.round(input.questionAnswered / input.questionCount * 100)
    let color = "linear-gradient(5deg, rgba(100,100,100,1) 0%, rgba(200,200,200,1) 100%)"
    if (input.modelLevel < this.cmmcModel.targetLevel) {
      color = this.getGradient("blue");
    } else if (input.modelLevel == this.cmmcModel.targetLevel) {
      color = this.getGradient("green");
    } else {
      color = this.getGradient("grey");
    }
    let val = {
      width: `${width}%`,
      background: color
    }
    return val
  }

  isWithinModelLevel(level) {
    if (level.modelLevel == "CMMC") { return false; }
    let val = Number(level.modelLevel)
    if (!isNaN(val)) {
      if (val <= this.cmmcModel.targetLevel) {
        return true;
      }
    }
    return false;
  }

  generateReferenceList(MaturityQuestions: any, targetLevel: number): any {
    let outputdata = [];
    for (let item of MaturityQuestions) {
      if (item.maturity_Level <= targetLevel)
        outputdata.push(item);
    }
    return outputdata;
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
    let clonedArray = JSON.parse(JSON.stringify(data)) //Easy way to deep copy array
    let sortedData = clonedArray.sort((a, b) => (a.modelLevel > b.modelLevel) ? 1 : -1)
    let outputData = []

    if (!this.totalCMMCQuestions) {
      this.getTotalCMMCQuestion(data);
    }
    for (let i = 0; i < sortedData.length; i++) {
      let dataEle = [];
      if (i == 0) {
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


  /**
   * 
   * @param data 
   * @returns 
   */
  getStackedChartSectionStyle(data) {
    let retVal = {};

    switch (data.modelLevel) {
      case "1":
        retVal["background-color"] = "#f2e9ed";
        retVal["color"] = "#444";
        retVal["border-bottom-width"] = "1px";
        break;
      case "2":
        retVal["background-color"] = "#dcd9ec";
        retVal["color"] = "#444";
        break;
      case "3":
        retVal["background-color"] = "#9b99c3";
        retVal["color"] = "#fff";
        break;
      case "4":
        retVal["background-color"] = "#504d99";
        retVal["color"] = "#fff";
        break;
      case "5":
        retVal["background-color"] = "#2f4773";
        retVal["color"] = "#fff";
        break;
    }

    if (data.type == "No") {
      retVal["border-bottom"] = "none";
    }

    if (data.type == "Yes") {
      retVal["border-top"] = "none";
      retVal["background-color"] = this.lightenDarkenColor(retVal["background-color"], -30);
    }

    //Determine if section should be displayed and size if so
    if (data.modelLevel <= this.cmmcModel.targetLevel) {
      let levelToTotalRatio = data.totalForLevel / data.totalQuestions;
      let sectionToLevelRatio = (data.count / data.totalForLevel);
      let sectionPercent = (levelToTotalRatio * sectionToLevelRatio) * 100;
      retVal["flex-basis"] = `calc(${sectionPercent}%)`;
    } else {
      if (data.type == "No") {
        retVal["display"] = "none";
      } else {
        let levelToTotalRatio = data.totalForLevel / data.totalQuestions;
        let sectionPercent = levelToTotalRatio * 100;
        retVal["flex-basis"] = `calc(${sectionPercent}%)`;
      }
    }

    return retVal;
  }


  getTotalCMMCQuestion(data) {
    this.totalCMMCQuestions = 0;

    data.forEach(element => {
      if (element.questionCountAggregateForLevelAndBelow > this.totalCMMCQuestions) {
        this.totalCMMCQuestions = element.questionCountAggregateForLevelAndBelow
      }
    });
  }

  //Pyramid Chart
  getPyramidRowColor(level) {
    let backgroundColor = this.getGradient("blue", .1);
    let textColor = this.blueText;
    if (this.cmmcModel?.targetLevel) {
      if (level == this.cmmcModel?.targetLevel) {
        backgroundColor = this.getGradient("green");
        textColor = this.whiteText;
      }
      else if (level < this.cmmcModel?.targetLevel) {
        backgroundColor = this.getGradient("blue");
        textColor = this.whiteText;
      } else {
        backgroundColor = this.getGradient("blue-5");
        textColor = this.blueText;
      }
    }
    return {
      background: backgroundColor,
      color: textColor
    };
  }

  /**
   * Returns a modified color string.
   * The 'amt' argument (-100 to 100) should be negative to darken and positive to lighten.
   * @param col 
   * @param amt 
   * @returns 
   */
  lightenDarkenColor(col, amt) {

    var usePound = false;

    if (col[0] == "#") {
      col = col.slice(1);
      usePound = true;
    }

    var num = parseInt(col, 16);

    var r = (num >> 16) + amt;

    if (r > 255) r = 255;
    else if (r < 0) r = 0;

    var b = ((num >> 8) & 0x00FF) + amt;

    if (b > 255) b = 255;
    else if (b < 0) b = 0;

    var g = (num & 0x0000FF) + amt;

    if (g > 255) g = 255;
    else if (g < 0) g = 0;

    return (usePound ? "#" : "") + (g | (b << 8) | (r << 16)).toString(16);
  }

}
