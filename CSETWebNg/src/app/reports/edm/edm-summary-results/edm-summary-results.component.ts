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
import { MaturityService } from '../../../services/maturity.service';


@Component({
  selector: 'app-edm-summary-results',
  templateUrl: './edm-summary-results.component.html',
  styleUrls: ['./edm-summary-results.component.scss', '../../reports.scss']
})
export class EdmSummaryResultsComponent implements OnInit {

  barValue = 0;
  blueBarValue = 0;
  flat_data: any[] = null;
  flat_data_blue: any[] = null;
  edmPercentData: any;
  indicatorData: any;

  /**
   * 
   * @param maturitySvc 
   */
  constructor(
    private maturitySvc: MaturityService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.maturitySvc.getEdmPercentScores().subscribe(
      (result: any) => {
        this.edmPercentData = result.summary;
        this.indicatorData = result.partial;
        this.getMaturityIndicatorLevel();
        this.getBlueIndicator();
      },
      (failure) => {
        console.log(failure);
      }
    )
  }

  /**
   * 
   */
  getMaturityIndicatorLevel() {
    var nextChild = this.edmPercentData.topLevelChild;
    this.flat_data = [];
    this.flat_data.push(this.getMILBasicData(this.edmPercentData));
    while (nextChild != null) {
      this.flat_data.unshift(this.getMILBasicData(nextChild));
      nextChild = nextChild.topLevelChild;
    }
    this.flat_data.every(level => {
      this.barValue += level.percentageCountRight / level.percentageTotalCount;
      if (level.percentageCountRight != level.percentageTotalCount) {
        return false;
      }
      return true;
    });
  }

  /**
   * 
   */
  getBlueIndicator() {
    var nextChild = this.indicatorData.topLevelChild;
    this.flat_data_blue = [];
    this.flat_data_blue.push(this.getBlueMILBasicData(this.indicatorData));
    while (nextChild != null) {
      this.flat_data_blue.unshift(this.getBlueMILBasicData(nextChild));
      nextChild = nextChild.topLevelChild;
    }
    this.flat_data_blue.every(level => {
      this.blueBarValue += level.percentageCountRight / level.percentageTotalCount;
      if (level.percentageCountRight != level.percentageTotalCount) {
        return false;
      }
      return true;
    });
  }

  /**
   * Calculates the width of a purple bar.  
   * The width is normalized to fit the x-axis labels.
   * @param input 
   * @returns 
   */
  getBarWidth(input) {
    let width = (Number.parseFloat(input.percentageCountRight) / Number.parseFloat(input.percentageTotalCount)) * 92;

    const widthStyle = {
      'width': `${width}%`
    };
    return widthStyle;
  }

  /**
   * 
   * @param input 
   * @returns 
   */
  getMILBasicData(input) {
    return {
      title_Id: input.title_Id,
      children: input.children,
      percentageCountRight: input.percentageCountRight,
      percentageTotalCount: input.percentageTotalCount
    };
  }

  /**
   * 
   * @param input 
   * @returns 
   */
  getBlueMILBasicData(input) {
    return {
      title_Id: input.title_Id,
      children: input.children,
      percentageCountRight: input.score,
      percentageTotalCount: input.totalCount
    };
  }


  /**
   * Returns a CSS width value to match the corresponding
   * domain tick legend in the X axis.
   * @param input 
   * @returns 
   */
  getBlueBarWidth(input) {
    let width = 0;
    if (input < 0 || input > 5) {
      // console.log("BLUE BAR WIDTH VALUE OUTSIDE OF 0-5 RANGE")
    }
    else if (input < 1) {
      width = (input * .5) * 100;
    } else {
      width = 50 + (Math.floor(input) - 1) * 12.5;
    }

    const widthStyle = {
      'width': `${width}%`
    };
    return widthStyle;
  }

}
