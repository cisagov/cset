import { Component, OnInit } from '@angular/core';
import { NavigationAggregService } from '../../../services/navigationAggreg.service';
import { AggregationService } from '../../../services/aggregation.service';
import { AggregationChartService, ChartColors } from '../../../services/aggregation-chart.service';

@Component({
  selector: 'app-compare-individual',
  templateUrl: './compare-individual.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareIndividualComponent implements OnInit {

  answerCounts: any[];
  chartOverallComparison: Chart;
  chartCategoryPercent: Chart;

  constructor(
    public navSvc: NavigationAggregService,
    public aggregationSvc: AggregationService,
    public aggregChartSvc: AggregationChartService
  ) { }

  ngOnInit() {
    this.populateCharts();
  }

  populateCharts() {
    const aggregationId = this.aggregationSvc.id();

    // Assessment Answer Summary - tabular data
    this.aggregationSvc.getAnswerTotals().subscribe((x: any) => {
      // 
      this.answerCounts = x;
    });


    // Overall Comparison
    this.aggregationSvc.getCategoryPercentageComparisons().subscribe((x: any) => {
      // fake data ...........................................
      x = {
        reportType: "",
        labels: ["Questions", "Overall", "Components"],
        datasets: [{
          label: "A",
          data: [25, 13, 15]
        },
        {
          label: "B",
          data: [32, 20, 30]
        }
        ],
        options: {
          legend: {
            display: 'top'
          },
          maintainAspectRatio: true,
          scales: {
            xAxes: [{
              ticks: {
                suggestedMin: 50,
                suggestedMax: 100
              }
            }]
          }
        }
      };
      // .....................................................

      // apply visual attributes
      const chartColors = new ChartColors();
      x.datasets.forEach(ds => {
        ds.backgroundColor = chartColors.getNextBluesBarColor();
        ds.borderColor = ds.backgroundColor;
      });

      this.chartOverallComparison = this.aggregChartSvc.buildHorizBarChart('canvasOverallComparison', x, true);
    });


    // Comparison of Security Assurance Levels


    // Category Percentage Comparison
    this.aggregationSvc.getCategoryPercentageComparisons().subscribe((x: any) => {
      this.chartCategoryPercent = this.aggregChartSvc.buildCategoryPercentChart('canvasCategoryPercent', x);
    });
  }
}
