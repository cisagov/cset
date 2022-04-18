import { Component,Input, OnInit } from '@angular/core';
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
import { AssessmentDetail, Demographic } from '../../models/assessment-info.model';
import {BubbleController,Chart} from 'chart.js';
import { ReportAnalysisService } from '../../services/report-analysis.service';
// import { timingSafeEqual } from 'crypto';
import { User } from '../../models/user.model';

interface DemographicsAssetValue {
  demographicsAssetId: number;
  assetValue: string;
}

interface Industry {
  sectorId: number;
  industryId: number;
  industryName: string;
}

interface Sector {
  sectorId: number;
  sectorName: string;
}

interface AssessmentSize {
  demographicId: number;
  size: string;
  description: string;
}
// interface Industry {
//   sectorId: number;
//   industryId: number;
//   industryName: string;
// }

// interface Sector {
//   sectorId: number;
//   sectorName: string;
// }
// interface SectorNode {
//   name: string;
//   children?: SectorNode[];
// }

// interface FlatNode {
//   expandable: boolean;
//   name: string;
//   level: number;
//   parent: string;
// }

@Component({
  selector: 'app-tsa-analytics',
  templateUrl: './tsa-analytics.component.html',
  styleUrls: ['./tsa-analytics.component.scss'],
  host: { class: 'd-flex flex-column flex-11a' }
})

export class TsaAnalyticsComponent implements OnInit {
       assessment: AssessmentDetail = {};

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


     chart1:any=[];
      testconfig:any={};
      testdata:any={};

      chartScore: Chart;
      scoreObject: any;
      sectionScore: Number;
      maturityModelId:number;
      isStandard: boolean=false;
      isMaturity:boolean=false;
       maturityModelName:string="";
       sectorsList: Sector[];
       sizeList: AssessmentSize[];
       assetValues: DemographicsAssetValue[];
       industryList: Industry[];
       contacts: User[];

       demographicData: Demographic = {};
       orgTypes: any[];
       standards: any[];
       ischecked:boolean=true;
       dataRowstest: any []= [
          {
              "median": 40,
              "title": "Account Management",
              "rank": null,
              "failed": 5,
              "passed": null,
              "total": 5,
              "percent": 100,
              "min": 0,
              "max": 100,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 50,
              "title": "Audit and Accountability",
              "rank": null,
              "failed": 1,
              "passed": null,
              "total": 2,
              "percent": 50,
              "min": 0,
              "max": 100,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 55,
              "title": "Configuration Management",
              "rank": null,
              "failed": 2,
              "passed": null,
              "total": 2,
              "percent": 100,
              "min": 0,
              "max": 100,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 0,
              "title": "Continuity",
              "rank": null,
              "failed": 2,
              "passed": null,
              "total": 2,
              "percent": 100,
              "min": null,
              "max": null,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 50,
              "title": "Identification and Authentication",
              "rank": null,
              "failed": 1,
              "passed": null,
              "total": 1,
              "percent": 100,
              "min": 0,
              "max": 10,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 50,
              "title": "Identify",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 20,
              "percent": 0,
              "min": null,
              "max": null,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 0,
              "title": "Incident Response",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 2,
              "percent": 0,
              "min": null,
              "max": null,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 50,
              "title": "Monitoring & Malware",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 1,
              "percent": 0,
              "min": 0,
              "max": 100,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 50,
              "title": "Physical Security",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 40,
              "percent": 0,
              "min": 0,
              "max": 100,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 40,
              "title": "Planning",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 25,
              "percent": 0,
              "min": 0,
              "max": 100,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 50,
              "title": "Plans",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 14,
              "percent": 0,
              "min": 0,
              "max": 100,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 0,
              "title": "Policies",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 6,
              "percent": 0,
              "min": null,
              "max": null,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 0,
              "title": "Procedures",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 2,
              "percent": 0,
              "min": null,
              "max": null,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 0,
              "title": "Risk Assessment",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 13,
              "percent": 0,
              "min": null,
              "max": null,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 0,
              "title": "Risk Management and Assessment",
              "rank": null,
              "failed": 0,
              "passed": null,
              "total": 9,
              "percent": 0,
              "min": null,
              "max": null,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          },
          {
              "median": 0,
              "title": "Securing the System",
              "rank": null,
              "failed": 31,
              "passed": null,
              "total": 32,
              "percent": 96.875,
              "min": null,
              "max": null,
              "avg": null,
              "yes": null,
              "no": null,
              "na": null,
              "alt": null,
              "unanswered": null
          }
      ]
  can_id: Chart<"bar" | "scatter", number, string>;
  constructor(
    public tsaanalyticSvc:TsaAnalyticsService,
    public tsaSvc:TsaService,
    private demoSvc: DemographicService,
    private assessSvc: AssessmentService,
    private tsaAnalyticSvc: TsaAnalyticsService,
    public analysisSvc: ReportAnalysisService
  ) { }

  ngOnInit(): void {
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentDetail().subscribe(data => {
        this.standards=[];
        this.assessment = data;
        console.log(this.assessment)
       if(!this.assessment.useMaturity && !this.assessment.useStandard){
         this.noData=true;
       }
      if(this.assessment.useMaturity){
          this.isMaturity=true;
          this.maturityModelName=this.assessment.maturityModel.modelName
          this.maturityModelId= this.assessment.maturityModel.modelId
          this.tsaAnalyticSvc.MaturityDashboardByCategory(this.assessment.maturityModel.modelId).subscribe(x =>{
          this.setuptest(x);

          } );
        }
          if(this.assessment.useStandard){
            this.assessment.standards.forEach(element => {
              this.standards.push(element);
            });
            this.isStandard=true;
            this.tsaAnalyticSvc.DashboardByStandarsCategoryTSA(this.selectedSector).subscribe(x =>{
             this.setupChartStandard(x)
              this.newChart();
            } );

          }



        });
    }
    this.demographicData.sectorId=null;
    this.currentAssessmentId =this.assessment.id?.toString();
    // this.tsaAnalyticSvc.getSectors().subscribe((data: any) => {
    //   this.sectorSource.data = data;
    //   this.selectedSector = "|All Sectors";
    // });
    // this.getDashboardData();

    // this.tsaAnalyticSvc.DashboardByCategoryTSA(this.selectedSector).subscribe(x =>{
    //   if(x.dataSets.length==0){
    //     this.noData=true;
    //   }
    //   else{
    //     this.setupChart(x)
    //     this.setuptest(x)
    //   }
    // } );
// console.log(this.assessment.maturityModel.modelId);
    // this.tsaAnalyticSvc.MaturityDashboardByCategory(5).subscribe(x =>{
    //     //this.setupChartMaturity(x);
    //     this.setuptest(x);
    // } );
    this.demoSvc.getAllSectors().subscribe(
      (data: Sector[]) => {
          this.sectorsList = data;
      },
      error => {
          console.log('Error Getting all sectors: ' + (<Error>error).name + (<Error>error).message);
          console.log('Error Getting all sectors (cont): ' + (<Error>error).stack);
      });
  this.demoSvc.getAllAssetValues().subscribe(
      (data: DemographicsAssetValue[]) => {
          this.assetValues = data;
      },
      error => {
          console.log('Error Getting all asset values: ' + (<Error>error).name + (<Error>error).message);
          console.log('Error Getting all asset values (cont): ' + (<Error>error).stack);
      });
  this.demoSvc.getSizeValues().subscribe(
      (data: AssessmentSize[]) => {
          this.sizeList = data;
      },
      error => {
          console.log('Error Getting size values: ' + (<Error>error).name + (<Error>error).message);
          console.log('Error Getting size values (cont): ' + (<Error>error).stack);
      });

  if (this.demoSvc.id) {
      this.getDemographics();
  }
  // this.refreshContacts();
  this.getOrganizationTypes();
  if(this.demographicData.assessment_Id==null){
    // this.demographicData.sectorId=15
    this.populateIndustryOptions(this.demographicData.sectorId);
    this.demographicData.industryId = null;
    this.updateDemographics();
  }

  }
  newChart() {

    this.standards.forEach(cont => {
      document.getElementById('test').insertAdjacentHTML("afterend","<tr><td><canvas id='canvas"+cont+"'></canvas></td></tr>");
    var can_id="canvas"+cont;
    const canvas = <HTMLCanvasElement> document.getElementById(can_id);
    const ctx = canvas.getContext('2d');
     this.can_id = new Chart(ctx,
      {

        type: 'bar',
        data: {
            labels:['dff','sfs','dff'],
          datasets:[
            {
              type: 'scatter',
              label: 'Comparison Max',
              pointStyle: 'triangle',
              data:100,
              pointRadius: 6,
              pointHoverRadius: 6,
              backgroundColor: '#66fa55',
              borderColor: '#66fa55'
            },
            {
              type: 'scatter',
              label: 'Comparison Median',
              pointRadius: 6,
              pointHoverRadius: 6,
              data: 50,
              backgroundColor: '#fefd54',
              borderColor: '#fefd54'
            },
            {
              type: 'scatter',
              label: 'Comparison Min',
              data: 0,
              pointStyle: 'triangle',
              pointRadius: 6,
              pointHoverRadius: 6,
              backgroundColor: '#e33e23',
              borderColor: '#e33e23'
            },
            {
              type: 'bar',
              label: 'Your Score',
              data: 60,
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
    }
      );

   this.can_id.update();
    //alert(config.options.id);
    // configSet();
    //alert(config.options.id);
    // alert(cont);
    return cont = cont +1;
    });
  }

  onSelectSector(sectorId: string) {
    // if(sectorId=="0: null"){
    //   sectorId='15';

    //    this.demographicData.sectorId=15
    //  }
  console.log(sectorId)
      this.populateIndustryOptions(parseInt(sectorId));
      // invalidate the current Industry, as the Sector list has just changed
      this.demographicData.industryId = null;
      this.updateDemographics();
      this.updateCharts();
  }

  getDemographics() {
      this.demoSvc.getDemographic().subscribe(
          (data: Demographic) => {
              this.demographicData = data;

              // populate Industry dropdown based on Sector
              this.populateIndustryOptions(this.demographicData.sectorId);
          },
          error => console.log('Demographic load Error: ' + (<Error>error).message)
      );
  }

  getOrganizationTypes(){
      this.assessSvc.getOrganizationTypes().subscribe(
          (data: any) => {
              this.orgTypes = data;

          }
      )
  }

  // refreshContacts(){
  //     if (this.assessSvc.id()) {
  //         this.assessSvc
  //           .getAssessmentContacts()
  //           .then((data: AssessmentContactsResponse) => {
  //             this.contacts = data.contactList;
  //           });
  //       }
  // }

  populateIndustryOptions(sectorId: number) {
      if (!sectorId) {
          return;
      }
      this.demoSvc.getIndustry(sectorId).subscribe(
          (data: Industry[]) => {
              this.industryList = data;
          },
          error => {
              console.log('Error Getting Industry: ' + (<Error>error).name + (<Error>error).message);
              console.log('Error Getting Industry (cont): ' + (<Error>error).stack);
          });
  }

  // changeAssetValue(event: any) {
  //     this.demographicData.assetValue = event.target.value;
  //     // this.updateDemographics();
  // }

  changeOrgType(event: any){
      this.demographicData.organizationType = event.target.value;
      console.log(event.target.value)
      // this.updateDemographics();
  }

  // changeFacilitator(event: any){
  //     this.demographicData.facilitator = event.target.value;
  //     // this.updateDemographics();
  // }

  // changeOrgName(event: any){
  //     this.demographicData.organizationName = event.target.value;
  //     // this.updateDemographics();
  // }

  // changeAgency(event: any){
  //     this.demographicData.agency = event.target.value;
  //     // this.updateDemographics();
  // }

  // changeCriticalService(event: any) {
  //     this.demographicData.criticalService = event.target.value;
  //     this.updateDemographics();
  // }

  // changePointOfContact(event: any){
  //     this.demographicData.pointOfContact = event.target.value;
  //     this.updateDemographics();
  // }

  // changeIsScoped(event: any){
  //     //this.demographicData.isScoped = event.target.value;
  //     // this.updateDemographics();
  // }

  // changeSize(event: any) {
  //     this.demographicData.size = event.target.value;
  //     // this.updateDemographics();
  // }

  update(event: any) {
    console.log(event.target.value)
      // this.updateDemographics();
  }

  updateDemographics() {
      // this.demoSvc.updateDemographic(this.demographicData);
  }
  updateCharts(){

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

  checkValue(event: any){

    console.log(event);
    console.log(event.source.name);
 }

  setupChartStandard(x: any) {
    console.log(x);
    let titles=[]
    let min = [];
    let max = [];
    let median = [];
    let title =[];
    let yHeight = 40;
    if(x ==null){
      this.noData=true;
    }

  min=  [
      {
          "x": 0,
          "y": 40
      },
      {
          "x": 0,
          "y": 50
      },
      {
          "x": 0,
          "y": 60
      },
      {
          "x": 0,
          "y": 70
      },
      {
          "x": 0,
          "y": 80
      },
      {
          "x": 0,
          "y": 90
      },
      {
          "x": 0,
          "y": 100
      },
      {
          "x": 0,
          "y": 110
      },
      {
          "x": 0,
          "y": 120
      },
      {
          "x": 0,
          "y": 130
      },
      {
          "x": 0,
          "y": 140
      },
      {
          "x": 0,
          "y": 150
      },
      {
          "x": 0,
          "y": 160
      },
      {
          "x": 0,
          "y": 170
      },
      {
          "x": 0,
          "y": 180
      },
      {
          "x": 0,
          "y": 190
      }
  ]
  max= [
    {
        "x": 100,
        "y": 40
    },
    {
        "x": 100,
        "y": 50
    },
    {
        "x": 100,
        "y": 60
    },
    {
        "x": 100,
        "y": 70
    },
    {
        "x": 100,
        "y": 80
    },
    {
        "x": 100,
        "y": 90
    },
    {
        "x": 100,
        "y": 100
    },
    {
        "x": 100,
        "y": 110
    },
    {
        "x": 100,
        "y": 120
    },
    {
        "x": 100,
        "y": 130
    },
    {
        "x": 100,
        "y": 140
    },
    {
        "x": 100,
        "y": 150
    },
    {
        "x": 100,
        "y": 160
    },
    {
        "x": 100,
        "y": 170
    },
    {
        "x": 100,
        "y": 180
    },
    {
        "x": 100,
        "y": 190
    }
]
median=[
  {
      "x": 50,
      "y": 40
  },
  {
      "x": 50,
      "y": 50
  },
  {
      "x": 50,
      "y": 60
  },
  {
      "x": 50,
      "y": 70
  },
  {
      "x": 50,
      "y": 80
  },
  {
      "x": 50,
      "y": 90
  },
  {
      "x": 50,
      "y": 100
  },
  {
      "x": 50,
      "y": 110
  },
  {
      "x": 50,
      "y": 120
  },
  {
      "x": 50,
      "y": 130
  },
  {
      "x": 50,
      "y": 140
  },
  {
      "x": 50,
      "y": 150
  },
  {
      "x": 50,
      "y": 160
  },
  {
      "x": 50,
      "y": 170
  },
  {
      "x": 50,
      "y": 180
  },
  {
      "x": 50,
      "y": 190
  }
]
    // I need this code
  //   for(let i=0; i<x.dataRows.length; i++){
  //     let item = x.dataRows[i];
  //     min.push({x:item.min,y:yHeight});
  //     max.push({x:item.max,y:yHeight});
  //     median.push({x:item.median,y:yHeight});
  //     yHeight=yHeight+10;
  // }

    // this.initialized = false;
    // this.dataRows = x.dataRows;
    // this.dataSets = x.dataSets;
    let tempChart = Chart.getChart('canvasStandardResult');
    if(tempChart){
      tempChart.destroy();
    }
    // console.log( x.dataSets[0].data)
    // console.log(x.labels);
    // console.log(x.dataSets[0].dataRows[0].title);
    this.chart = new Chart('canvasStandardResult', {
      type: 'bar',
      data: {
          labels: x.labels,
        datasets:[
          {
            type: 'scatter',
            label: 'Comparison Max',
            pointStyle: 'triangle',
            // data: x.dataSets[0].dataRows[0].max,
            data: max,
            pointRadius: 6,
            pointHoverRadius: 6,
            backgroundColor: '#66fa55',
            borderColor: '#66fa55'
          },
          {
            type: 'scatter',
            label: 'Comparison Median',
            pointRadius: 6,
            pointHoverRadius: 6,
            data: median,
            backgroundColor: '#fefd54',
            borderColor: '#fefd54'
          },
          {
            type: 'scatter',
            label: 'Comparison Min',
            data:min,
            pointStyle: 'triangle',
            pointRadius: 6,
            pointHoverRadius: 6,
            backgroundColor: '#e33e23',
            borderColor: '#e33e23'
          },
          {
            type: 'bar',
            label: 'Your Score',
            data:  x.dataSets[0].data,
            backgroundColor: ['#386FB3']
          }]
      },
      options: {
        indexAxis:'y',
          scales: {
              y: {
                  beginAtZero: true
               }
          },
          responsive:true
      }
      // type: 'bar',
      // data: {
      //   labels: x.labels,
      //   datasets: x.dataSets,
      // },
      // options: {
      //   indexAxis: 'y',
      //   plugins: {
      //     tooltip: {
      //       callbacks: {
      //         label: function(context) {
      //           return context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
      //           + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
      //         }
      //       }
      //     },
      //     title: {
      //       display: false,
      //       font: {size: 20},
      //       text: 'Results by Category'
      //     },
      //     legend: {
      //       display: true
      //     }
      //   },
      //   scales: {
      //     x: {
      //       beginAtZero: true
      //     }
      //   }
      // }
    });

    this.initialized = true;

  }



  setuptest(x:any){
  console.log(x);
  let titles=[]
  let min = [];
  let max = [];
  let median = [];
  let yHeight = 40;
  for(let i=0; i<x.dataRows.length; i++){
      let item = x.dataRows[i];
      min.push({x:item.min,y:yHeight});
      max.push({x:item.max,y:yHeight});
      median.push({x:item.median,y:yHeight});
      yHeight=yHeight+10;
  }

// x.forEach(element => {
//   let item=element
//   titles.push(element.title);
//   min.push({x:element.min, y:yHeight});
//   max.push({x:element.max,y:yHeight});
//   median.push({x:element.median,y:yHeight});
//   yHeight=yHeight+10;
// });

  this.chart1 = new Chart('canvasStandardResult1',
    {

      type: 'bar',
      data: {
          labels: x.labels,
        datasets:[
          {
            type: 'scatter',
            label: 'Comparison Max',
            pointStyle: 'triangle',
            data: max,
            pointRadius: 6,
            pointHoverRadius: 6,
            backgroundColor: '#66fa55',
            borderColor: '#66fa55'
          },
          {
            type: 'scatter',
            label: 'Comparison Median',
            pointRadius: 6,
            pointHoverRadius: 6,
            data: median,
            backgroundColor: '#fefd54',
            borderColor: '#fefd54'
          },
          {
            type: 'scatter',
            label: 'Comparison Min',
            data: min,
            pointStyle: 'triangle',
            pointRadius: 6,
            pointHoverRadius: 6,
            backgroundColor: '#e33e23',
            borderColor: '#e33e23'
          },
          {
            type: 'bar',
            label: 'Your Score',
            data: x.data,
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
     }
    getmodelId( modelId){

    }
}
