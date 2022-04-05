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
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { timingSafeEqual } from 'crypto';

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
      noData:boolean= false;
      canvasStandardResultsByCategory: Chart;
      responseResultsByCategory: any;
      initialized = false;
      dataRows: { title: string; failed: number; total: number; percent: number; min :number; max:number;}[];
      dataSets: { dataRows: { title: string; failed: number; total: number; percent: number; }[], label: string };


    //  test
     chart1:any=[];
      testconfig:any={};
      testdata:any={};

///end test
// barChartType: ChartType = "bar";
// barChartLegend = true;

chartDataMin = {
  fill: true,
  data: [50,50,50],
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
  data: [50,50,50],
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









// barChart = {
//   data: [],
//   label: "Category",
// };

// barChartData: ChartDataset[] = [
//   this.chartDataMin,
//   this.chartDataMedian,
//   this.chartDataMax,
//   this.barChart,
// ];
// barChartLabels:any [];


// data: any[];
// displayedColumns: string[] = [
//   "alias",
//   "setName",
//   "sector",
//   "industry",
//   "assessmentCreatedDate",
//   "lastAccessedDate",
// ];


  constructor(
    public tsaanalyticSvc:TsaAnalyticsService,
    public tsaSvc:TsaService,
    private demoSvc: DemographicService,
    private assessSvc: AssessmentService,
    private tsaAnalyticSvc: TsaAnalyticsService,
    public analysisSvc: ReportAnalysisService
  ) { }

  ngOnInit(): void {


    this.chart1 = new Chart('canvasStandardResult1',
    {
      type: 'bar',
      data: {
          labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
        //   datasets: [{

        //       label: '# of Votes',
        //       data: [12, 19, 3, 5, 2, 3],
        //       backgroundColor: [
        //           'rgba(255, 99, 132, 0.2)',
        //           'rgba(54, 162, 235, 0.2)',
        //           'rgba(255, 206, 86, 0.2)',
        //           'rgba(75, 192, 192, 0.2)',
        //           'rgba(153, 102, 255, 0.2)',
        //           'rgba(255, 159, 64, 0.2)'
        //       ],
        //       borderColor: [
        //           'rgba(255, 99, 132, 1)',
        //           'rgba(54, 162, 235, 1)',
        //           'rgba(255, 206, 86, 1)',
        //           'rgba(75, 192, 192, 1)',
        //           'rgba(153, 102, 255, 1)',
        //           'rgba(255, 159, 64, 1)'
        //       ],
        //       borderWidth: 1
        //   },

        // ]
        datasets: [
          {
            type: 'scatter',
            label: 'Comparison High',
            pointStyle: 'triangle',
            data: [{ x: 100, y: 40 }],
            // radius: 10,
            backgroundColor: '#66fa55'
          },
          {
            type: 'scatter',
            label: 'Comparison Median',
            // radius: 8,
            data: [{ x: 50, y: 50 }],
            backgroundColor: '#fefd54'
          },
          {
            type: 'scatter',
            label: 'Comparison Low',
            data: [{ x: 0, y: 60 }],
            pointStyle: 'triangle',
            // rotation: 180,
            // radius: 10,
            backgroundColor: '#e33e23'
          },
          {
            type: 'bar',
            label: 'Your Score',
            data: [34,80,90],
            backgroundColor: ['#386FB3']
          }]
      },
      options: {
        indexAxis:'y',
          scales: {
              y: {
                  beginAtZero: true
              }
          }
      }
  });
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentDetail().subscribe(data => {
        this.assessment = data;
        // console.log(data);
        });
    }
    this.currentAssessmentId =this.assessment.id?.toString();
    this.tsaAnalyticSvc.getSectors().subscribe((data: any) => {
      this.sectorSource.data = data;
      this.selectedSector = "|All Sectors";
    });
    // this.getDashboardData();

    this.tsaAnalyticSvc.DashboardByCategoryTSA(this.selectedSector).subscribe(x =>{
      if(x.dataSets.length==0){
        this.noData=true;
      }
      else{
        this.setupChart(x)
        this.setuptest(x)
      }
    } );

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

  addChartData(chart1, label, chartDataMin) {
    chart1.data.labels.push(label);
    chart1.data.datasets.forEach((dataset) => {
        dataset.data.push(chartDataMin);
    });
    chart1.update();
}


  setupChart(x: any) {
    if(x ==null){
      this.noData=true;
    }
    this.initialized = false;
    this.dataRows = x.dataRows;
    this.dataSets = x.dataSets;
    let tempChart = Chart.getChart('canvasStandardResult');
    if(tempChart){
      tempChart.destroy();
    }
    this.chart = new Chart('canvasStandardResult', {
      type: 'bar',
      data: {

        labels: x.labels,
        datasets: x.dataSets,
      },
      options: {
        indexAxis: 'y',
        plugins: {
          tooltip: {
            callbacks: {
              label: function(context) {
                return context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
                + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
              }
            }
          },
          title: {
            display: false,
            font: {size: 20},
            text: 'Results by Category'
          },
          legend: {
            display: true
          }
        },
        scales: {
          x: {
            beginAtZero: true
          }
        }
      }
    });

    this.initialized = true;

  }

  setuptest(x:any){

  //  this.testdata={
  //     labels: x.labels,
  //     datasets: [{
  //       type: 'bar',
  //       label: 'dvdvd',
  //       data:[50,60,80,90],
  //       options:{
  //         scales: {
  //           y: {
  //             beginAtZero: true
  //           }
  //         },
  //         indexAxis: 'y',
  //         plugins: {
  //           tooltip: {
  //             callbacks: {
  //               label: function(context) {
  //                 return context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
  //                 + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
  //               }
  //             }
  //           },
  //           title: {
  //             display: false,
  //             font: {size: 20},
  //             text: 'Results by Category'
  //           },
  //           legend: {
  //             display: true
  //           }
  //         },


  //       },
  //       borderColor: 'rgb(255, 99, 132)',
  //       backgroundColor: 'rgba(255, 99, 132, 0.2)'
  //     }, {
  //       type: 'line',
  //       label: 'Line Dataset',
  //       data: [50, 50, 50, 50],
  //       options:{
  //         indexAxis: 'y',
  //         plugins: {
  //           tooltip: {
  //             callbacks: {
  //               label: function(context) {
  //                 return context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
  //                 + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
  //               }
  //             }
  //           },
  //           title: {
  //             display: false,
  //             font: {size: 20},
  //             text: 'Results by Category'
  //           },
  //           legend: {
  //             display: true
  //           }
  //         },
  //         scales: {
  //           y: {
  //             beginAtZero: true
  //           }
  //         }

  //       },
  //       fill: false,
  //       borderColor: 'rgb(54, 162, 235)'
  //     }],
  //     options: {
  //       indexAxis: 'y',
  //       plugins: {
  //         tooltip: {
  //           callbacks: {
  //             label: function(context) {
  //               return context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
  //               + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
  //             }
  //           }
  //         },
  //         title: {
  //           display: false,
  //           font: {size: 20},
  //           text: 'Results by Category'
  //         },
  //         legend: {
  //           display: true
  //         }
  //       },
  //       scales: {
  //         x: {
  //           beginAtZero: true
  //         }
  //       }
  //     }
  //   };




    }
    // refreshChart() {
    //   let x = {
    //     labels: [''],
    //     datasets: [
    //       {
    //         type: 'scatter',
    //         label: 'Comparison High',
    //         pointStyle: 'triangle',
    //         data: [{ x: 100, y: 40 }],
    //         radius: 10,
    //         backgroundColor: '#66fa55'
    //       },
    //       {
    //         type: 'scatter',
    //         label: 'Comparison Median',
    //         radius: 8,
    //         data: [{ x: 50, y: 50 }],
    //         backgroundColor: '#fefd54'
    //       },
    //       {
    //         type: 'scatter',
    //         label: 'Comparison Low',
    //         data: [{ x: 0, y: 60 }],
    //         pointStyle: 'triangle',
    //         rotation: 180,
    //         radius: 10,
    //         backgroundColor: '#e33e23'
    //       },
    //       {
    //         type: 'bar',
    //         label: 'Your Score',
    //         data: [34,80,90],
    //         backgroundColor: ['#386FB3']
    //       }]
    //   };

    //   let opts = {
    //     scales: { y: { display: false } },
    //     plugins: {
    //       legend: { position: 'right' }
    //     }
    //   };


    // }




}
