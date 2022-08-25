import { Component, Input, OnInit, HostListener, ViewChild, ElementRef } from '@angular/core';
import { NavigationService } from '../../../services/navigation.service';
import { Title } from '@angular/platform-browser';
// import { MaturityService } from '../../../services/maturity.service';
import { ChartService } from '../../../services/chart.service';
import { CrmpDataService } from '../../../services/crmp-data.service';
import { NgxChartsModule, ColorHelper } from '@swimlane/ngx-charts';
import { BehaviorSubject } from 'rxjs';
import { AssessmentService } from '../../../services/assessment.service';



@Component({
  selector: 'app-crmp-summary',
  templateUrl: './crmp-summary.component.html',
  styleUrls: ['./crmp-summary.component.scss']
})
export class CrmpSummaryComponent implements OnInit {
  @Input() title = "CRMP Performance Summary";
  @Input() showNav = true;

  initialized = false;
  //RRA Gaps chart 
  dataError = false;

  response;
  crmpModel;
  crmpSummary;
  statsByLevel;
  columnWidthPx = 25;

  statsByDomain;
  statsByDomainAtUnderTarget;
  gridColumnCount = 10;
  gridColumns = new Array(this.gridColumnCount);
  @ViewChild("gridChartDataDiv") gridChartData: ElementRef;
  @ViewChild("gridTiles") gridChartTiles: Array<any>;
  columnWidthEmitter: BehaviorSubject<number>;

  whiteText = "rgba(255,255,255,1)";
  blueText = "rgba(31,82,132,1)";
  //

  sAxisTicks = [0, 5, 10, 15, 18];
  maxLevel = 0;
  answerCountsByLevel = [];
  answerDistribColorScheme = { domain: ['#28A745', '#DC3545', '#c3c3c3'] };

  complianceByGoal = [];
  answerDistribByGoal = [];
  answerDistribByLevel = [];

  colorScheme1 = { domain: ['#007BFF'] };
  xAxisTicks = [0, 25, 50, 75, 100];

  //  single: any[] = [];

  //  view: any[] = [300, 300];

  //  gradient: boolean = false;
  //  showLegend: boolean = true;
  //  showLabels: boolean = false;
  //  isDoughnut: boolean = true;
  //  legendPosition: string = 'below';
  //  arcWidth = .5;
  //  legend: string[] = [];
  //  colorScheme = {
  //    domain: ['#28A745', '#DC3545', '#c3c3c3']
  // };

  legendColors: ColorHelper;

 constructor(
   public CrmpDataSvc: CrmpDataService,
   public navSvc: NavigationService,
   public assessmentSvc: AssessmentService
  ) { 
    this.columnWidthEmitter = new BehaviorSubject<number>(25);
  }


  ngOnInit(): void {
    this.CrmpDataSvc.getCRMPDetail().subscribe((r: any) => {
      this.createAnswerCountsByLevel(r);
    //  this.createAnswerDistribByGoal(r);
      this.createAnswerDistribByLevel(r);
      this.createComplianceByGoal(r);
    });

    // cmmc Chart 
    //*********Error here*********
    this.CrmpDataSvc.getResultsData('crmpSiteSummary').subscribe(
      (r: any) => {
        this.response = r;

        if (r.maturityModels) {
          r.maturityModels.forEach(model => {
            if (model.maturityModelName === 'CRMP') {
              this.crmpModel = model
              this.statsByLevel = this.generateStatsByLevel(this.crmpModel.statsByLevel)
              this.statsByDomain = this.crmpModel.statsByDomain
              this.statsByDomainAtUnderTarget = this.crmpModel.statsByDomainAtUnderTarget;
            }
          });
          window.dispatchEvent(new Event('resize'));
        }
        this.initialized = true;
        window.dispatchEvent(new Event('resize'));
      },
      error => {
        this.dataError = true;
        this.initialized = true;
        console.log('Site Summary report load Error: ' + (<Error>error).message)
      }
    ), (finish) => {
    };

    this.columnWidthEmitter.subscribe(item => {
      $(".gridCell").css("width", `${item}px`)
    })
  }

  createAnswerCountsByLevel(r: any) {
    let levelList = [];

    r.crmpSummary.forEach(element => {
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

  findMaxLength(){
    let mLength = 0;
    this.answerCountsByLevel.forEach(x =>{
      let length = 0;
      x.series.forEach(y => {
        length += y.value;
      });
      if(mLength < length){
        mLength = length;
      }
    })
    this.maxLevel = mLength;
  }

  createAnswerDistribByLevel(r: any) {
    let levelList = [];
    r.crmpSummary.forEach(element => {
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

  // createAnswerDistribByGoal(r: any) {
  //   let goalList = [];
  //   r.crmpSummaryByGoal.forEach(element => {
  //     let goal = goalList.find(x => x.name == element.title);
  //     if (!goal) {
  //       goal = {
  //         name: element.title, series: [
  //           { name: 'Yes', value: 0 },
  //           { name: 'No', value: 0 },
  //           { name: 'Unanswered', value: 0 },
  //         ]
  //       };
  //       goalList.push(goal);
  //     }

  //     var p = goal.series.find(x => x.name == element.answer_Full_Name);
  //     p.value = element.percent;
  //   });

 //   this.answerDistribByGoal = goalList;
//  }

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

  //Horizontal bar chart - Blue from RRA Gaps
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
  //horizontalDomainBarChat
  getcolumnWidth() {
    if (this.gridChartData?.nativeElement != null) {
      this.columnWidthPx = this.gridChartData.nativeElement.clientWidth / this.gridColumns.length;
      this.columnWidthEmitter.next(this.columnWidthPx);
    }
  }

  getBarWidth(data) {
    return {
      'flex-grow': data.questionAnswered / data.questionCount,
      'background': this.getGradient("blue")
    };
  }
  getGradient(color, alpha = 1, reverse = false) {
    let vals = {
      color_one: "",
      color_two: ""
    };
    alpha = 1;
    switch (color) {
      case "blue":
      case "blue-1": {
        vals["color_one"] = `rgba(31,82,132,${alpha})`;
        vals["color_two"] = `rgba(58,128,194,${alpha})`;
        break;
      }
      case "blue-2": {
        vals["color_one"] = `rgba(75,116,156,${alpha})`;
        vals["color_two"] = `rgba(97,153,206,${alpha})`;
        break;
      }
      case "blue-3": {
        vals["color_one"] = `rgba(120,151,156,${alpha})`;
        vals["color_two"] = `rgba(137,179,218,${alpha})`;
        break;
      }
      case "blue-4": {
        vals["color_one"] = `rgba(165,185,205,${alpha})`;
        vals["color_two"] = `rgba(176,204,230,${alpha})`;
        break;
      }
      case "blue-5": {
        vals["color_one"] = `rgba(210,220,230,${alpha})`;
        vals["color_two"] = `rgba(216,229,243,${alpha})`;
        break;
      }
      case "green": {
        vals["color_one"] = `rgba(98,154,109,${alpha})`;
        vals["color_two"] = `rgba(31,77,67,${alpha})`;
        break;
      }
      case "grey": {
        vals["color_one"] = `rgba(98,98,98,${alpha})`;
        vals["color_two"] = `rgba(120,120,120,${alpha})`;
        break;
      }
      case "orange": {
        vals["color_one"] = `rgba(255,190,41,${alpha})`;
        vals["color_two"] = `rgba(224,217,98,${alpha})`;
        break;
      }
    }
    if (reverse) {
      let tempcolor = vals["color_one"];
      vals["color_one"] = vals["color_two"];
      vals["color_two"] = tempcolor;
    }
    return `linear-gradient(5deg,${vals['color_one']} 0%, ${vals['color_two']} 100%)`;
}

}
