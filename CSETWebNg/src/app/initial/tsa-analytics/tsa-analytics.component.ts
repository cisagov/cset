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
      currentAssessmentId = "";
      currentAssessmentAlias = "";
      currentAssessmentStd = "";
      parent: string = "";
      sampleSize: number = 0;

 barChartOptions: ChartOptions = {
  // responsive: true,
  // maintainAspectRatio: true,
  // aspectRatio: 2,
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
barChartLabels: [];

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
    private assessSvc: AssessmentService
  ) { }

  ngOnInit(): void {
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentDetail().subscribe(data => {
        this.assessment = data;
        });
    }

   this.demoSvc.getAllSectors().subscribe(
    (data) => {
    this.sectorsList = data;

    },
    error => {
        console.log('Error Getting all sectors: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting all sectors (cont): ' + (<Error>error).stack);
    });;
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
    // this.getDashboardData();
    console.log(sector);
  }
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;

  }
//   onSelectSector(sectorId: number) {
//     if(sectorId>=1){
//     var sector=this.sectorsList.find((x: { sectorId: number; })=>x.sectorId==sectorId);
//     // this.userData.Sector=sector.sectorName;
//     this.populateIndustryOptions(sectorId);
//   }
// }
// populateIndustryOptions(sectorId: number) {
//   if (!sectorId) {
//       return;
//   }
//   this.demoSvc.getIndustry(sectorId).subscribe(
//       (data) => {
//           this.industryList = data;
//       },
//       error => {
//           console.log('Error Getting Industry: ' + (<Error>error).name + (<Error>error).message);
//           console.log('Error Getting Industry (cont): ' + (<Error>error).stack);
//       });
// }
  // onSelectIndustry(sectorId:number){
  //   if(industryId>=1){
  //     var industry=this.industryList.find((x: { industryId: number; })=>x.industryId==industryId);
  //    this.userData.Industry=industry.industryName;
  //    }
  // }
}
// import { Component, AfterViewInit, ViewChild } from "@angular/core";
// import { DashboardService } from "./dashboard.service";
// import { TsaAnalyticsService } from '../../services/tsa-analytics.service';
// import { ChartDataset, ChartOptions, ChartType } from "chart.js";
// import { FlatTreeControl } from "@angular/cdk/tree";
// import {
//   MatTreeFlatDataSource,
//   MatTreeFlattener,
// } from "@angular/material/tree";
// import { MatPaginator } from "@angular/material/paginator";
// import { merge, Observable, of as observableOf } from "rxjs";
// import { catchError, map, startWith, switchMap } from "rxjs/operators";
// import { Label } from "ng2-charts";
// import { NumberCardComponent } from "@swimlane/ngx-charts";
// import { MatSort } from "@angular/material/sort";
// import { AssessmentsApi } from'../../services/tsa-analytics.service';
// interface SectorNode {
//   name: string;
//   children?: SectorNode[];
// }
// import { DemographicService } from '../../services/demographic.service';

// interface FlatNode {
//   expandable: boolean;
//   name: string;
//   level: number;
//   parent: string;
// }
// @Component({
//   selector: 'app-tsa-analytics',
//   templateUrl: './tsa-analytics.component.html',
//   styleUrls: ['./tsa-analytics.component.scss'],
//   host: { class: 'd-flex flex-column flex-11a' }
// })
// export class TsaAnalyticsComponent implements AfterViewInit {

//   @ViewChild(MatPaginator) paginator: MatPaginator;
//   @ViewChild(MatSort) sort: MatSort;

//   showAssessments: boolean = true;
//   showComparison: boolean = false;
//   sectors: any[] = [];
//   resultsLength = 0;
//   isLoadingResults = true;
//   isRateLimitReached = false;
//   selectedSector = "All Sectors";
//   currentAssessmentId = "";
//   currentAssessmentAlias = "";
//   currentAssessmentStd = "";
//   parent: string = "";
//   sampleSize: number = 0;
//   sectorsList: any;
//   barChartOptions: ChartOptions = {
//     // responsive: true,
//     // maintainAspectRatio: true,
//     // aspectRatio: 2,
//     // scales: {
//     //   xAxes: [
//     //     {
//     //       ticks: {
//     //         beginAtZero: true,
//     //         stepSize: 10,
//     //         maxTicksLimit: 100,
//     //         max: 100,
//     //       },
//     //     },
//     //   ],
//     // },
//     // tooltips: {
//     //   callbacks: {
//     //     label: function (tooltipItem, data) {
//     //       var label = data.datasets[tooltipItem.datasetIndex].label;
//     //       label += ": " + tooltipItem.xLabel;
//     //       return label;
//     //     },
//     //     title: function (tooltipItems, data) {
//     //       var tooltipItem = tooltipItems[0];
//     //       var title = data.labels[tooltipItem.index].toString();
//     //       return title;
//     //     },
//     //   },
//     // },
//   };
//   barChartType:  ChartType = "bar";
//   barChartLegend = true;

//   chartDataMin = {
//     fill: true,
//     data: [],
//     label: "Min",
//     type: "scatter",
//     pointRadius: 4,
//     pointHoverRadius: 5,
//     pointBackgroundColor: "#FFA1B5",
//     pointBorderColor: "#FF6384",
//     pointHoverBackgroundColor: "#FF6384",
//     pointHoverBorderColor: "#FF6384",
//     backgroundColor: "#FFA1B5",
//     borderColor: "#FF6384",
//   };
//   chartDataMedian = {
//     fill: true,
//     data: [],
//     label: "Median",
//     type: "scatter",
//     pointRadius: 4,
//     pointHoverRadius: 5,
//     pointBackgroundColor: "#FFE29A",
//     pointBorderColor: "#FFCE56",
//     pointHoverBackgroundColor: "#FFCE56",
//     pointHoverBorderColor: "#FFCE56",
//     backgroundColor: "#FFE29A",
//     borderColor: "#FFCE56",
//   };
//   chartDataMax = {
//     fill: true,
//     data: [],
//     type: "scatter",
//     label: "Max",
//     pointRadius: 4,
//     pointHoverRadius: 5,
//     pointBackgroundColor: "#9FD983",
//     pointBorderColor: "#64BB6A",
//     pointHoverBackgroundColor: "#64BB6A",
//     pointHoverBorderColor: "#64BB6A",
//     backgroundColor: "#9FD983",
//     borderColor: "#64BB6A",
//   };
//   barChart = {
//     data: [],
//     label: "Category",
//   };

//   barChartData: ChartDataset[] = [
//     this.chartDataMin,
//     this.chartDataMedian,
//     this.chartDataMax,
//     this.barChart,
//   ];
//   barChartLabels:  [];

//   data: any[];
//   displayedColumns: string[] = [
//     "alias",
//     "setName",
//     "sector",
//     "industry",
//     "assessmentCreatedDate",
//     "lastAccessedDate",
//   ];
//   Assessment_Id: number;
//   constructor(private dashboardService: TsaAnalyticsService, private demoSvc: DemographicService) {}
//   ngAfterViewInit(): void {
//     // this.getAssessmentData();
//     this.getDashboardData();
//     this.demoSvc.getAllSectors().subscribe(
//           (data) => {
//           this.sectorsList = data;
//           console.log(this.sectorsList)
//           },
//           error => {
//               console.log('Error Getting all sectors: ' + (<Error>error).name + (<Error>error).message);
//               console.log('Error Getting all sectors (cont): ' + (<Error>error).stack);
//           });;

//   }
//   private _transformer = (node: SectorNode, level: number) => {
//     if (!!node.children && node.children.length > 0) {
//       this.parent = node.name;
//     }
//     return {
//       expandable: !!node.children && node.children.length > 0,
//       name: node.name,
//       level: level,
//       parent: !!node.children && node.children.length > 0 ? "" : this.parent,
//     };
//   };

//   treeControl = new FlatTreeControl<FlatNode>(
//     (node) => node.level,
//     (node) => node.expandable
//   );
//   treeFlattener = new MatTreeFlattener(
//     this._transformer,
//     (node) => node.level,
//     (node) => node.expandable,
//     (node) => node.children
//   );
//   sectorSource = new MatTreeFlatDataSource(
//     this.treeControl,
//     this.treeFlattener
//   );

//   hasChild = (_: number, node: FlatNode) => {
//     return node.expandable;
//   };

//   public chartClicked({
//     event,
//     active,
//   }: {
//     event: MouseEvent;
//     active: {}[];
//   }): void {
//     //console.log(event, active);
//   }

//   public chartHovered({
//     event,
//     active,
//   }: {
//     event: MouseEvent;
//     active: {}[];
//   }): void {
//     //console.log(event, active);
//   }
//   getAssessmentData() {
//     let user = sessionStorage.getItem("username");

//     merge(this.paginator.page)
//       .pipe(
//         startWith({}),
//         switchMap(() => {
//           this.isLoadingResults = true;
//           return this.dashboardService!.getAssessmentsForUser(user);
//         }),
//         map((data: AssessmentsApi) => {
//           this.isLoadingResults = false;
//           this.isRateLimitReached = false;
//           this.resultsLength = data.total_count;

//           return data.items;
//         }),
//         catchError(() => {
//           this.isLoadingResults = false;
//           this.isRateLimitReached = true;
//           return observableOf([]);
//         })
//       )
//       .subscribe((data) => (this.data = data));
//   }

//   getDashboardData() {
//     this.dashboardService
//       .getDashboard(this.selectedSector, this.currentAssessmentId)
//       .subscribe((data: any) => {
//         this.chartDataMin.data = data.min;
//         this.chartDataMax.data = data.max;
//         this.chartDataMedian.data = data.median;
//         this.barChart.data = data.barData.values;
//         this.barChartLabels = data.barData.labels;
//         this.sampleSize = data.sampleSize;
//         this.barChartData = [
//           this.chartDataMin,
//           this.chartDataMedian,
//           this.chartDataMax,
//           this.barChart,
//         ];

//         if (this.dashboardService != null) {
//           this.showComparison = true;
//           if (this.sectorSource.data.length == 0) {
//             this.dashboardService.getSectors().subscribe((data: any) => {
//               this.sectorSource.data = data;
//               this.selectedSector = "|All Sectors";
//             });
//           }
//         } else {
//           this.showComparison = false;
//         }
//       });
//   }

//   setRecord(item: any) {
//     this.currentAssessmentId = item.assessment_Id;
//     this.currentAssessmentAlias = item.alias;
//     this.currentAssessmentStd = item.setName;
//     this.selectedSector = "|All Sectors";

//     this.getDashboardData();
//   }

//   onSelect(event) {
//     //console.log(event);
//   }
//   sectorChange(sector) {
//     this.selectedSector = sector;
//     this.getDashboardData();
//     console.log(sector);
//   }
// }
