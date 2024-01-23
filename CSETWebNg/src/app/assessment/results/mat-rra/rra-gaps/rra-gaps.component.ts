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
import { Component, OnInit, HostListener, ViewChild, ElementRef } from '@angular/core';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { MaturityService } from '../../../../services/maturity.service';
import { BehaviorSubject } from 'rxjs';
import { AssessmentService } from '../../../../services/assessment.service';
import * as $ from 'jquery';

@Component({
  selector: 'app-rra-gaps',
  templateUrl: './rra-gaps.component.html',
  // eslint-disable-next-line
  styleUrls: ['./rra-gaps.component.scss'],
  host: { class: 'd-flex flex-column flex-11a' }
})
export class RraGapsComponent implements OnInit {

  initialized = false;
  dataError = false;

  response;
  cmmcModel;
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

  constructor(
    public navSvc: NavigationService,
    public maturitySvc: MaturityService,
    public assessmentSvc: AssessmentService
  ) {
    this.columnWidthEmitter = new BehaviorSubject<number>(25);
  }


  ngOnInit(): void {
    this.maturitySvc.getResultsData('sitesummarycmmc').subscribe(
      (r: any) => {
        this.response = r;

        if (r.maturityModels) {
          r.maturityModels.forEach(model => {
            if (model.maturityModelName === 'CMMC') {
              this.cmmcModel = model;
              this.statsByLevel = this.generateStatsByLevel(this.cmmcModel.statsByLevel);
              this.statsByDomain = this.cmmcModel.statsByDomain;
              this.statsByDomainAtUnderTarget = this.cmmcModel.statsByDomainAtUnderTarget;
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
        console.log('Site Summary report load Error: ' + (<Error>error).message);
      }
    ), (finish) => {
    };

    this.columnWidthEmitter.subscribe(item => {
      $(".gridCell").css("width", `${item}px`);
    })
  }

  ngAfterViewInit() {
    this.getcolumnWidth();
  }

  ngAfterViewChecked() {
    this.getcolumnWidth();
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

  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.getcolumnWidth();
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
