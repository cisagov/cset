import { Component, OnInit } from '@angular/core';
import { AggregationService } from '../../../services/aggregation.service';
import { AggregationChartService } from '../../../services/aggregation-chart.service';

@Component({
  selector: 'app-compare-summary',
  templateUrl: './compare-summary.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareSummaryComponent implements OnInit {

  chartOverallAverage: Chart;
  chartStandardsPie: Chart;
  chartComponentsPie: Chart;
  chartCategoryAverage: Chart;

  constructor(
    public aggregationSvc: AggregationService,
    public aggregChartSvc: AggregationChartService
  ) { }

  ngOnInit() {
    this.populateCharts();
  }

  populateCharts() {
    const aggregationId = this.aggregationSvc.id();

    // Overall Average
    this.aggregationSvc.getOverallAverageSummary().subscribe((x: any) => {

      // apply visual attributes
      x.datasets.forEach(ds => {
        ds.backgroundColor = '#004c75';
        ds.borderColor = '#004c75';
      });

      this.chartOverallAverage = this.aggregChartSvc.buildHorizBarChart('canvasOverallAverage', x, false);
    });



    // Standards Answers
    this.aggregationSvc.getStandardsAnswers().subscribe((x: any) => {
      
      // apply visual attributes
      x.colors = ["#006000", "#990000", "#0063B1", "#B17300", "#CCCCCC"];

      this.chartStandardsPie = this.aggregChartSvc.buildDoughnutChart('canvasStandardsPie', x);
    });



    // Components Answers
    this.aggregationSvc.getComponentsAnswers().subscribe((x: any) => {

      // apply visual attributes
      x.colors = ["#006000", "#990000", "#0063B1", "#B17300", "#CCCCCC"];

      this.chartComponentsPie = this.aggregChartSvc.buildDoughnutChart('canvasComponentsPie', x);
    });



    // Category Averages
    this.aggregationSvc.getCategoryAverages().subscribe((x: any) => {

      // fake data ...........................................
      x = {
        reportType: "",
        labels: ["Account Management", "Communication Protection", "Encryption", "Information Protection", "Physical Security"],
        datasets: [{
          label: "",
          data: [25, 13, 10, 2, 81]
        }
        ]
      };
      // .....................................................

      // apply visual attributes
      x.datasets.forEach(ds => {
        ds.backgroundColor = '#008a00';
        ds.borderColor = '#008a00';
      });

      this.chartCategoryAverage = this.aggregChartSvc.buildHorizBarChart('canvasCategoryAverage', x, false);
    });
  }
}
