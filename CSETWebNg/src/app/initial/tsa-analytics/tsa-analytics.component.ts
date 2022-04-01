import { Component, OnInit } from '@angular/core';
import { DemographicService } from '../../services/demographic.service';
import { TsaAnalyticsService } from '../../services/tsa-analytics.service';
import { TsaService } from '../../services/tsa.service';
import { ChartDataset, ChartOptions, ChartType } from "chart.js"
import {
  MatTreeFlatDataSource,
  MatTreeFlattener,
} from "@angular/material/tree";
import { FlatTreeControl } from "@angular/cdk/tree";
import { AssessmentService } from '../../services/assessment.service';
import { AssessmentDetail } from '../../models/assessment-info.model';
import {Chart} from 'chart.js';

interface Industry {
  sectorId: number;
  industryId: number;
  industryName: string;
}

interface Sector {
  sectorId: number;
  sectorName: string;
}
interface SectorNode {
  name: string;
  children?: SectorNode[];
}

interface FlatNode {
  expandable: boolean;
  name: string;
  level: number;
  parent: string;
}

@Component({
  selector: 'app-tsa-analytics',
  templateUrl: './tsa-analytics.component.html',
  styleUrls: ['./tsa-analytics.component.scss'],
  host: { class: 'd-flex flex-column flex-11a' }
})
export class TsaAnalyticsComponent implements OnInit {
  assessment: AssessmentDetail = {};
        sectorsList: any;
      industryList:any;
      showAssessments: boolean = true;
      showComparison: boolean = false;
      sectors: any[] = [];
      resultsLength = 0;
      isLoadingResults = true;
      isRateLimitReached = false;
      selectedSector = "All Sectors";
      currentAssessmentId ="";
      currentAssessmentAlias = "";
      currentAssessmentStd = "";
      parent: string = "";
      sampleSize: number = 0;
      assessmentId:string="";
      chart: any = [];
      newchartLabels:any[];

 barChartOptions: ChartOptions = {
  responsive: true,
  maintainAspectRatio: true,
  aspectRatio: 2,
  scales: {
    y: {
        ticks: {

            // Include a dollar sign in the ticks
            callback: function(value, index, ticks) {
                return  value;
            }
        }
    }
},
  // scales: {
  //   xAxes: [
  //     {
  //       ticks: {
  //         beginAtZero: true,
  //         stepSize: 10,
  //         maxTicksLimit: 100,
  //         max: 100,
  //       },
  //     },
  //   ],
  // },
  // tooltips: {
  //   callbacks: {
  //     label: function (tooltipItem, data) {
  //       var label = data.datasets[tooltipItem.datasetIndex].label;
  //       label += ": " + tooltipItem.xLabel;
  //       return label;
  //     },
  //     title: function (tooltipItems, data) {
  //       var tooltipItem = tooltipItems[0];
  //       var title = data.labels[tooltipItem.index].toString();
  //       return title;
  //     },
  //   },
  // },
};
barChartType: ChartType = "bar";
barChartLegend = true;

chartDataMin = {
  fill: true,
  data: [],
  label: "Min",
  type: "scatter",
  pointRadius: 4,
  pointHoverRadius: 5,
  pointBackgroundColor: "#FFA1B5",
  pointBorderColor: "#FF6384",
  pointHoverBackgroundColor: "#FF6384",
  pointHoverBorderColor: "#FF6384",
  backgroundColor: "#FFA1B5",
  borderColor: "#FF6384",
};
chartDataMedian = {
  fill: true,
  data: [],
  label: "Median",
  type: "scatter",
  pointRadius: 4,
  pointHoverRadius: 5,
  pointBackgroundColor: "#FFE29A",
  pointBorderColor: "#FFCE56",
  pointHoverBackgroundColor: "#FFCE56",
  pointHoverBorderColor: "#FFCE56",
  backgroundColor: "#FFE29A",
  borderColor: "#FFCE56",
};
chartDataMax = {
  fill: true,
  data: [],
  type: "scatter",
  label: "Max",
  pointRadius: 4,
  pointHoverRadius: 5,
  pointBackgroundColor: "#9FD983",
  pointBorderColor: "#64BB6A",
  pointHoverBackgroundColor: "#64BB6A",
  pointHoverBorderColor: "#64BB6A",
  backgroundColor: "#9FD983",
  borderColor: "#64BB6A",
};
barChart = {
  data: [],
  label: "Category",
};

barChartData: ChartDataset[] = [
  this.chartDataMin,
  this.chartDataMedian,
  this.chartDataMax,
  this.barChart,
];
barChartLabels:any [];


data: any[];
displayedColumns: string[] = [
  "alias",
  "setName",
  "sector",
  "industry",
  "assessmentCreatedDate",
  "lastAccessedDate",
];


  constructor(
    public tsaanalyticSvc:TsaAnalyticsService,
    public tsaSvc:TsaService,
    private demoSvc: DemographicService,
    private assessSvc: AssessmentService,
    private tsaAnalyticSvc: TsaAnalyticsService
  ) { }

  ngOnInit(): void {
    // this.newchartLabels=['lilu','ddgf', 'dgdg'];
// const ctx = document.getElementById('myChart').getContext('2d');
// this.barChartLabels= ['fsf','dd','sdsd'];
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentDetail().subscribe(data => {
        this.assessment = data;
        console.log(data);
        });
    }
    this.currentAssessmentId =this.assessment.id?.toString();
    this.tsaAnalyticSvc.getSectors().subscribe((data: any) => {
      this.sectorSource.data = data;
      this.selectedSector = "|All Sectors";
    });
    this.getDashboardData();
    // this.chart = new Chart('canvas', {
    //   type: 'bar',
    //   data: {
    //       labels: this.newchartLabels,
    //       datasets: [{
    //           label: '# of Votes',
    //           data: [12, 19, 3, 5, 2, 3],
    //           backgroundColor: [
    //               'rgba(255, 99, 132, 0.2)',
    //               'rgba(54, 162, 235, 0.2)',
    //               'rgba(255, 206, 86, 0.2)',
    //               'rgba(75, 192, 192, 0.2)',
    //               'rgba(153, 102, 255, 0.2)',
    //               'rgba(255, 159, 64, 0.2)'
    //           ],
    //           borderColor: [
    //               'rgba(255, 99, 132, 1)',
    //               'rgba(54, 162, 235, 1)',
    //               'rgba(255, 206, 86, 1)',
    //               'rgba(75, 192, 192, 1)',
    //               'rgba(153, 102, 255, 1)',
    //               'rgba(255, 159, 64, 1)'
    //           ],
    //           borderWidth: 1
    //       }]
    //   },
    //   options: {
    //       scales: {
    //           y: {
    //               beginAtZero: true
    //           }
    //       }
    //   }
    // });


  }
  private _transformer = (node: SectorNode, level: number) => {
    if (!!node.children && node.children.length > 0) {
      this.parent = node.name;
    }
    return {
      expandable: !!node.children && node.children.length > 0,
      name: node.name,
      level: level,
      parent: !!node.children && node.children.length > 0 ? "" : this.parent,
    };
  };

  treeControl = new FlatTreeControl<FlatNode>(
    (node) => node.level,
    (node) => node.expandable
  );
  treeFlattener = new MatTreeFlattener(
    this._transformer,
    (node) => node.level,
    (node) => node.expandable,
    (node) => node.children
  );
  sectorSource = new MatTreeFlatDataSource(
    this.treeControl,
    this.treeFlattener
  );

  hasChild = (_: number, node: FlatNode) => {
    return node.expandable;
  };

  onSelectSector(sectorId: number) {
    this.populateIndustryOptions(sectorId);
  }
  populateIndustryOptions(sectorId: number) {
    if (!sectorId) {
        return;
    }
    this.demoSvc.getIndustry(sectorId).subscribe(
        (data: Industry[]) => {
            this.industryList = data;
            console.log(this.industryList)
        },
        error => {
            console.log('Error Getting Industry: ' + (<Error>error).name + (<Error>error).message);
            console.log('Error Getting Industry (cont): ' + (<Error>error).stack);
        });
}

  onChange(event:any){
    console.log(event);
  }
  public chartClicked({
    event,
    active,
  }: {
    event: MouseEvent;
    active: {}[];
  }): void {
    //console.log(event, active);
  }

  public chartHovered({
    event,
    active,
  }: {
    event: MouseEvent;
    active: {}[];
  }): void {
    //console.log(event, active);
  }
  sectorChange(sector) {
    this.selectedSector = sector;
    this.getDashboardData();
    console.log(sector);
  }
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;

  }


  //  what i copied from Jason project
  getDashboardData() {
    this.assessmentId=this.assessment.id?.toString();
    this.assessmentId="6001";
    this.tsaanalyticSvc
      .getDashboard(this.selectedSector, this.assessmentId)
      .subscribe((data: any) => {
        console.log(data);
        this.chartDataMin.data = data.min;
        this.chartDataMax.data = data.max;
        this.chartDataMedian.data = data.median;
        this.barChart.data = data.barData.values;
        this.barChartLabels = data.barData.labels;
        this.newchartLabels= data.barData.labels;

        this.sampleSize = data.sampleSize;
        this.barChartData = [
          this.chartDataMin,
          this.chartDataMedian,
          this.chartDataMax,
          this.barChart,
        ];

        if (this.tsaanalyticSvc != null) {
          this.showComparison = true;
          if (this.sectorSource.data.length == 0) {
            this.tsaanalyticSvc.getSectors().subscribe((data: any) => {
              this.sectorSource.data = data;
              this.selectedSector = "|All Sectors";
            });
          }
        } else {
          this.showComparison = false;
        }
      });
  }

}
