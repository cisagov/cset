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
import { AggregationService } from '../../../../services/aggregation.service';
import { ChartService } from '../../../../services/chart.service';
import Chart from 'chart.js/auto';
import { ColorService } from '../../../../services/color.service';
import { QuestionsService } from '../../../../services/questions.service';

@Component({
  selector: 'app-compare-maturity-bestworst',
  templateUrl: './compare-bestworst.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareMaturityBestworstComponent implements OnInit {

  resp: any;

  currentGrouping: any;
  chartAnswerBreakdown: Chart;

  constructor(
    public aggregationSvc: AggregationService,
    public chartSvc: ChartService,
    public colorSvc: ColorService,
    public questionsSvc: QuestionsService
  ) { }

  ngOnInit() {
    this.loadPage();
  }

  loadPage() {
    this.loadGroupingList();
  }

  /**
   * 
   */
  loadGroupingList() {
    this.aggregationSvc.getMaturityBestToWorst().subscribe((x: any) => {
      this.resp = x;

      this.selectGrouping(this.resp.groupings[0]);
    });
  }

  /**
   * When the user clicks one of the groupings in the left panel
   * this code loads up a chart comparing the answer distributions
   * for that grouping among the participating assessments.
   */
  public selectGrouping(g: any) {
    this.currentGrouping = g;

    // create chart data skeleton
    const chartConfig = {
      labels: [],
      datasets: []
    };

    this.resp.answerOptions.forEach(o => {

      // get the answer label and segment color for this answer option
      const label = this.questionsSvc.answerDisplayLabel(this.resp.modelId, o);
      const segmentColor = this.questionsSvc.findAnsDefinition(this.resp.modelId, o).chartSegmentColor;

      const dataset = { label: label, backgroundColor: segmentColor, data: [] }
      chartConfig.datasets.push(dataset);

      // grab each answer option's percentage from each assessment
      g.assessments.forEach(a => {
        if (!chartConfig.labels.some(x => x == a.alias)) {
          chartConfig.labels.push(a.alias);
        }

        dataset.data.push(a.percentages.find(p => p.answerText == o)?.percent ?? 0.0);
      });
    });


    if (this.chartAnswerBreakdown) {
      this.chartAnswerBreakdown.destroy();
    }

    this.chartAnswerBreakdown = this.chartSvc.buildStackedHorizBarChart('canvasAnswerBreakdown', chartConfig);
  }
}
