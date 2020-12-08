import { Injectable } from '@angular/core';
import { DomSanitizer, Title } from '@angular/platform-browser';
import { BehaviorSubject } from 'rxjs';
import { ConfigService } from './config.service';
import { ReportAnalysisService } from './report-analysis.service';
import { ReportService } from './report.service';

@Injectable()
export class CmmcStyleService {
  pieChartVals = "";
  pieColorYes = "#ffc107"
  pieColorNo = "#f2b844"

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
      backgroundImage: `conic-gradient(${this.pieColorYes} ${degreeOfNo}deg, rgba(0,0,0,0) 0 1deg)`
    }
    return val
  }
  getBorder(input) {
    return `solid ${input} black`
  }

  getBarSettings(input) {
    let width = Math.round(input.questionAnswered / input.questionCount * 100)
    let color = "linear-gradient(5deg, rgba(100,100,100,1) 0%, rgba(200,200,200,1) 100%)"
    if (input.ModelLevel < this.cmmcModel.TargetLevel) {
      color = this.getGradient("blue");
    } else if (input.ModelLevel == this.cmmcModel.TargetLevel) {
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
    if (level.ModelLevel == "CMMC") { return false; }
    let val = Number(level.ModelLevel)
    if (!isNaN(val)) {
      if (val <= this.cmmcModel.TargetLevel) {
        return true;
      }
    }
    return false;
  }

  getData() {
    this.reportSvc.getReport('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;
        if (r.MaturityModels) {
          r.MaturityModels.forEach(model => {
            if (model.usesMaturityModel('CMMC')) {
              this.cmmcModel = model
              this.statsByLevel = this.generateStatsByLevel(this.cmmcModel.StatsByLevel);
              this.statsByDomain = this.cmmcModel.StatsByDomain;
              this.statsByDomainAtUnderTarget = this.cmmcModel.StatsByDomainAtUnderTarget;
              this.stackBarChartData = this.generateStackedBarChartData(this.statsByLevel);
              this.complianceLevelAcheivedData = this.getComplianceLevelAcheivedData(this.statsByLevel);
              this.referenceTable = this.generateReferenceList(this.cmmcModel.MaturityQuestions, this.cmmcModel.TargetLevel);
            }
          });
          console.log(this.stackBarChartData)
          window.dispatchEvent(new Event('resize'));
        }
      },
      error => console.log('CMMC Style Service load Error: ' + (<Error>error).message)
    ), (finish) => {

    };
  }
  generateReferenceList(MaturityQuestions: any, targetLevel: number): any {
    let outputdata = [];
    for (let item of MaturityQuestions) {
      if (item.Maturity_Level <= targetLevel)
        outputdata.push(item);
    }
    return outputdata;
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

  //Pyramid Chart
  getPyramidRowColor(level) {
    let backgroundColor = this.getGradient("blue", .1);
    let textColor = this.blueText
    if (this.cmmcModel?.TargetLevel) {
      if (level == this.cmmcModel?.TargetLevel) {
        backgroundColor = this.getGradient("green")
        textColor = this.whiteText
      }
      else if (level < this.cmmcModel?.TargetLevel) {
        backgroundColor = this.getGradient("blue")
        textColor = this.whiteText
      } else {
        backgroundColor = this.getGradient("blue-5")
        textColor = this.blueText
      }
    }
    return {
      background: backgroundColor,
      color: textColor
    }
  }

}
