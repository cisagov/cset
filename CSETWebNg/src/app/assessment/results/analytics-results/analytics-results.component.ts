import { Component, OnInit } from '@angular/core';
import { AnalyticsService } from '../../../services/analytics.service';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { ChartDataset, ChartOptions, ChartType, LabelItem} from 'chart.js/auto';
import { FlatTreeControl } from '@angular/cdk/tree';
import { MatTreeFlatDataSource, MatTreeFlattener } from '@angular/material/tree';
import { merge } from 'rxjs';
import { AssessmentService } from '../../../services/assessment.service';
import { AggregationService } from '../../../services/aggregation.service';


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

  interface UserAssessment {
    assessmentId: number;
    assessmentName: string;
    assessmentCreatedDate: string;
    selected: boolean;
    useMaturity: boolean;
    selectedMaturityModel: string;
  
    // used to filter selectable assessments in the list
    disabled: boolean;
  }

@Component({
    selector: 'app-analytics-results',
    templateUrl: './analytics-results.component.html',
    styleUrls: ['./analytics-results.component.scss']
})
export class AnalyticsResultsComponent implements OnInit {

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
    assessments: UserAssessment[];
    aggregation: any = {};

    barChartOptions: ChartOptions = {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 2,
        scales: {
          myScale: 
            { type: 'logarithmic',
              ticks: {
                // stepSize: 10,
                // maxTicksLimit: 100,
                // max: 100,
              },
            },
          
        },
        plugins: {
        // tooltip: {
        //   callbacks: {
        //     label: TooltipItem
        //     // function (tooltipItem: TooltipModel<T>, data: any) {
        //     //   var label = data.datasets[tooltipItem.datasetIndex].label;
        //     //   label += ": " + tooltipItem.xLabel;
        //     //   return label;
        //     },
        //     title: function (tooltipItems, data) {
        //       var tooltipItem = tooltipItems[0];
        //       var title = data.labels[tooltipItem.index].toString();
        //       return title;
        //     },
        //   },
        },
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
      barChartLabels: LabelItem[] = [];
    
      data: any[];
      displayedColumns: string[] = [
        "alias",
        "setName",
        "sector",
        "industry",
        "assessmentCreatedDate",
        "lastAccessedDate",
      ];
      Assessment_Id: number;
    
    constructor(
        public navSvc: NavigationService,
        public analyticsSvc: AnalyticsService,
        public assessSvc: AssessmentService,
        public aggregSvc: AggregationService
    ) { }

    ngOnInit() {
     this.getAnalytics();      
    }

    getAnalytics() {
        let assessmentId = 1; 
        let sectionId = 1; 
        this.analyticsSvc.getAnalyticResults(assessmentId, sectionId).subscribe(
            (data: any) => {
                //do something
            },
            error => {
               console.error(error)
            });
    }

    buildScatter() {
        //do something
    }

    buildBar(){
        //do something
    }

    ngAfterViewInit() {
        this.getAssessmentData();
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
      getAssessmentData() {
        let user = sessionStorage.getItem("username");
        try {
            this.assessSvc.getAssessments().subscribe((resp: UserAssessment[]) => {
                this.assessments = resp;
          
                this.aggregSvc.getAssessments().subscribe((resp2: any) => {
                  this.aggregation = resp2.aggregation;
          
                  resp2.assessments.forEach(selectedAssess => {
                    this.assessments.find(x => x.assessmentId === selectedAssess.assessmentId).selected = true;
                  });
                });
            })
        } catch (err) {
            console.error(err)
        }
      }
    
      getDashboardData() {
        this.analyticsSvc
          .getAnalyticResults(this.selectedSector, this.currentAssessmentId)
          .subscribe((data: any) => {
            this.chartDataMin.data = data.min;
            this.chartDataMax.data = data.max;
            this.chartDataMedian.data = data.median;
            this.barChart.data = data.barData.values;
            this.barChartLabels = data.barData.labels;
            this.sampleSize = data.sampleSize;
            this.barChartData = [
              this.chartDataMin,
              this.chartDataMedian,
              this.chartDataMax,
              this.barChart,
            ];
    
            if (this.analyticsSvc != null) {
              this.showComparison = true;
              if (this.sectorSource.data.length == 0) {
                this.analyticsSvc.getSectors().subscribe((data: any) => {
                  this.sectorSource.data = data;
                  this.selectedSector = "|All Sectors";
                });
              }
            } else {
              this.showComparison = false;
            }
          });
      }
    
      setRecord(item: any) {
        this.currentAssessmentId = item.assessment_Id;
        this.currentAssessmentAlias = item.alias;
        this.currentAssessmentStd = item.setName;
        this.selectedSector = "|All Sectors";
    
        this.getDashboardData();
      }
    
      onSelect(event) {
        //console.log(event);
      }
      sectorChange(sector) {
        this.selectedSector = sector;
        this.getDashboardData();
        console.log(sector);
      }
    

}
