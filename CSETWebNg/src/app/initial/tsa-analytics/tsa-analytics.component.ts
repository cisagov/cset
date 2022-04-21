import { Component, Input, OnInit } from "@angular/core";
import { DemographicService } from "../../services/demographic.service";
import { TsaAnalyticsService } from "../../services/tsa-analytics.service";
import { TsaService } from "../../services/tsa.service";
import { ChartDataset, ChartOptions, ChartType } from "chart.js";
import {
  MatTreeFlatDataSource,
  MatTreeFlattener,
} from "@angular/material/tree";
import { FlatTreeControl } from "@angular/cdk/tree";
import { AssessmentService } from "../../services/assessment.service";
import {
  AssessmentDetail,
  Demographic,
} from "../../models/assessment-info.model";
import { BubbleController, Chart } from "chart.js";
import { ReportAnalysisService } from "../../services/report-analysis.service";
// import { timingSafeEqual } from 'crypto';
import { User } from "../../models/user.model";
import { BehaviorSubject } from "rxjs";
import { element } from "screenfull";

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
interface StandardsNames {
  full_Name: string;
  set_Name: string;
}

@Component({
  selector: "app-tsa-analytics",
  templateUrl: "./tsa-analytics.component.html",
  styleUrls: ["./tsa-analytics.component.scss"],
  host: { class: "d-flex flex-column flex-11a" },
})
export class TsaAnalyticsComponent implements OnInit {
  assessment: AssessmentDetail = {};

  showAssessments: boolean = true;

  sectors: any[] = [];
  selectedSector = "All Sectors";
  currentAssessmentId = "";
  currentAssessmentStd = "";
  sampleSize: number = 0;
  assessmentId: string = "";
  chart: any = [];
  newchartLabels: any[];
  noData: boolean = false;
  canvasStandardResultsByCategory: Chart;
  responseResultsByCategory: any;
  initialized = false;
  dataRows: {
    title: string;
    failed: number;
    total: number;
    percent: number;
    min: number;
    max: number;
  }[];
  dataSets: {
    dataRows: {
      title: string;
      failed: number;
      total: number;
      percent: number;
    }[];
    label: string;
  };
  public isChecked$ = new BehaviorSubject(false);

  chart1: any = [];
  testconfig: any = {};
  testdata: any = {};

  chartScore: Chart;
  scoreObject: any;
  sectionScore: Number;
  maturityModelId: number;
  isStandard: boolean = false;
  isMaturity: boolean = false;
  maturityModelName: string = "";
  sectorsList: Sector[];
  sizeList: AssessmentSize[];
  assetValues: DemographicsAssetValue[];
  industryList: Industry[];
  contacts: User[];

  demographicData: Demographic = {};
  orgTypes: any[];
  standards: StandardsNames[];
  standardsChecked: any =[];
  ischecked: boolean = false;
  standardIschecked: boolean = false;
  sectorId: number;
  sectorindustryId: number;
  standardSetname: string;

  can_id: Chart<"bar" | "scatter", number, string>;
  constructor(
    public tsaanalyticSvc: TsaAnalyticsService,
    public tsaSvc: TsaService,
    private demoSvc: DemographicService,
    private assessSvc: AssessmentService,
    private tsaAnalyticSvc: TsaAnalyticsService,
    public analysisSvc: ReportAnalysisService
  ) {}

  ngOnInit(): void {
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentDetail().subscribe((data) => {
        this.standards = [];
        this.assessment = data;
        // console.log(this.assessment);
        if (!this.assessment.useMaturity && !this.assessment.useStandard) {
          this.noData = true;
        }
        if (this.assessment.useMaturity) {
          this.isMaturity = true;
          this.maturityModelName = this.assessment.maturityModel.modelName;
          this.maturityModelId = this.assessment.maturityModel.modelId;
          this.tsaAnalyticSvc
            .MaturityDashboardByCategory(this.assessment.maturityModel.modelId)
            .subscribe((x) => {
              this.setuptest(x);
            });
        }
        if (this.assessment.useStandard) {
          this.isStandard = true;
          this.tsaAnalyticSvc.getStandardList().subscribe((x) => {
            x.forEach((element) => {
              this.standards.push(element);
            });
          });
        }
      });
    }
    this.demographicData.sectorId = null;
    this.currentAssessmentId = this.assessment.id?.toString();
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
      (error) => {
        console.log(
          "Error Getting all sectors: " +
            (<Error>error).name +
            (<Error>error).message
        );
        console.log(
          "Error Getting all sectors (cont): " + (<Error>error).stack
        );
      }
    );
    this.demoSvc.getAllAssetValues().subscribe(
      (data: DemographicsAssetValue[]) => {
        this.assetValues = data;
      },
      (error) => {
        console.log(
          "Error Getting all asset values: " +
            (<Error>error).name +
            (<Error>error).message
        );
        console.log(
          "Error Getting all asset values (cont): " + (<Error>error).stack
        );
      }
    );
    this.demoSvc.getSizeValues().subscribe(
      (data: AssessmentSize[]) => {
        this.sizeList = data;
      },
      (error) => {
        console.log(
          "Error Getting size values: " +
            (<Error>error).name +
            (<Error>error).message
        );
        console.log(
          "Error Getting size values (cont): " + (<Error>error).stack
        );
      }
    );

    if (this.demoSvc.id) {
      this.getDemographics();
    }
    // this.refreshContacts();
    this.getOrganizationTypes();
    if (this.demographicData.assessment_Id == null) {
      // this.demographicData.sectorId=15
      this.populateIndustryOptions(this.demographicData.sectorId);
      this.demographicData.industryId = null;
      this.updateDemographics();
    }
  }
  newChart(x: any) {
    this.standards.forEach((cont) => {
      document
        .getElementById("test")
        .insertAdjacentHTML(
          "afterend",
          "<div *ngIf='" +
            cont.set_Name +
            "'  class='mt-5'>" +
            cont.set_Name +
            "<tr><td><canvas id='canvas" +
            cont.set_Name +
            "'></canvas></td></tr></div>"
        );
      var can_id = "canvas" + cont.set_Name;
      const canvas = <HTMLCanvasElement>document.getElementById(can_id);
      const ctx = canvas.getContext("2d");
      // console.log(cont);
      this.can_id = new Chart(ctx, {
        type: "bar",
        data: {
          labels: ["dff", "sfs", "dff"],
          datasets: [
            {
              type: "scatter",
              label: "Comparison Max",
              pointStyle: "triangle",
              data: 100,
              pointRadius: 6,
              pointHoverRadius: 6,
              backgroundColor: "#66fa55",
              borderColor: "#66fa55",
            },
            {
              type: "scatter",
              label: "Comparison Median",
              pointRadius: 6,
              pointHoverRadius: 6,
              data: 50,
              backgroundColor: "#fefd54",
              borderColor: "#fefd54",
            },
            {
              type: "scatter",
              label: "Comparison Min",
              data: 0,
              pointStyle: "triangle",
              pointRadius: 6,
              pointHoverRadius: 6,
              backgroundColor: "#e33e23",
              borderColor: "#e33e23",
            },
            {
              type: "bar",
              label: "Your Score",
              data: 60,
              backgroundColor: ["#386FB3"],
            },
          ],
        },
        options: {
          indexAxis: "y",
          scales: {
            y: {
              beginAtZero: true,
            },
          },
        },
      });

      this.can_id.update();
      //alert(config.options.id);
      // configSet();
      //alert(config.options.id);
      // alert(cont);
      return cont;
    });
  }

  onSelectSector(sectorId: string) {
    // if(sectorId=="0: null"){
    //   sectorId='15';

    //    this.demographicData.sectorId=15
    //  }
    // console.log(sectorId);
    this.populateIndustryOptions(parseInt(sectorId));
    // invalidate the current Industry, as the Sector list has just changed
    this.demographicData.industryId = null;
    this.updateDemographics();

  }

  getDemographics() {
    this.demoSvc.getDemographic().subscribe(
      (data: Demographic) => {
        this.demographicData = data;

        // populate Industry dropdown based on Sector
        this.populateIndustryOptions(this.demographicData.sectorId);
      },
      (error) =>
        console.log("Demographic load Error: " + (<Error>error).message)
    );
  }

  getOrganizationTypes() {
    this.assessSvc.getOrganizationTypes().subscribe((data: any) => {
      this.orgTypes = data;
    });
  }

  populateIndustryOptions(sectorId: number) {
    if (!sectorId) {
      return;
    }
    this.demoSvc.getIndustry(sectorId).subscribe(
      (data: Industry[]) => {
        this.industryList = data;
      },
      (error) => {
        console.log(
          "Error Getting Industry: " +
            (<Error>error).name +
            (<Error>error).message
        );
        console.log("Error Getting Industry (cont): " + (<Error>error).stack);
      }
    );
  }

  changeOrgType(event: any) {
    this.demographicData.organizationType = event.target.value;
    // console.log(event.target.value);
    // this.updateDemographics();
  }
  update(event: any) {
    // console.log(event.target.value);
    // this.updateDemographics();
  }

  updateDemographics() {
    // this.demoSvc.updateDemographic(this.demographicData);
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
    // console.log(sector);
  }
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
  }

  checkValue(event: any) {
    // console.log(event);
    // console.log(event.source.name);
  }

  setupChartStandard(x: any) {
    // console.log(x);
    let titles = [];
    let min = [];
    let max = [];
    let median = [];
    let title = [];
    let yHeight = 40;
    if (x == null) {
      this.noData = true;
    }

    // I need this code
    for (let i = 0; i < x.dataRowsStandard.length; i++) {
      let item = x.dataRowsStandard[i];
      min.push({ x: item.min, y: yHeight });
      max.push({ x: item.max, y: yHeight });
      median.push({ x: item.median, y: yHeight });
      yHeight = yHeight + 10;
    }

    let tempChart = Chart.getChart("canvasStandardResult");
    if (tempChart) {
      tempChart.destroy();
    }

    this.chart = new Chart("canvasStandardResult", {
      type: "bar",
      data: {
        labels: x.labels,
        datasets: [
          {
            type: "scatter",
            label: "Comparison Max",
            pointStyle: "triangle",
            // data: x.dataSets[0].dataRows[0].max,
            data: max,
            pointRadius: 6,
            pointHoverRadius: 6,
            backgroundColor: "#66fa55",
            borderColor: "#66fa55",
          },
          {
            type: "scatter",
            label: "Comparison Median",
            pointRadius: 6,
            pointHoverRadius: 6,
            data: median,
            backgroundColor: "#fefd54",
            borderColor: "#fefd54",
          },
          {
            type: "scatter",
            label: "Comparison Min",
            data: min,
            pointStyle: "triangle",
            pointRadius: 6,
            pointHoverRadius: 6,
            backgroundColor: "#e33e23",
            borderColor: "#e33e23",
          },
          {
            type: "bar",
            label: "Your Score",
            // data:  x.dataSets[0].data,
            data: title,
            backgroundColor: ["#386FB3"],
          },
        ],
      },
      options: {
        indexAxis: "y",
        scales: {
          y: {
            beginAtZero: true,
          },
        },
        responsive: true,
      },
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

  setuptest(x: any) {
    // console.log(x);
    let titles = [];
    let min = [];
    let max = [];
    let median = [];
    let yHeight = 40;
    for (let i = 0; i < x.dataRows.length; i++) {
      let item = x.dataRows[i];
      min.push({ x: item.min, y: yHeight });
      max.push({ x: item.max, y: yHeight });
      median.push({ x: item.median, y: yHeight });
      yHeight = yHeight + 10;
    }

    // x.forEach(element => {
    //   let item=element
    //   titles.push(element.title);
    //   min.push({x:element.min, y:yHeight});
    //   max.push({x:element.max,y:yHeight});
    //   median.push({x:element.median,y:yHeight});
    //   yHeight=yHeight+10;
    // });

    this.chart1 = new Chart("canvasStandardResult1", {
      type: "bar",
      data: {
        labels: x.labels,
        datasets: [
          {
            type: "scatter",
            label: "Comparison Max",
            pointStyle: "triangle",
            data: max,
            pointRadius: 6,
            pointHoverRadius: 6,
            backgroundColor: "#66fa55",
            borderColor: "#66fa55",
          },
          {
            type: "scatter",
            label: "Comparison Median",
            pointRadius: 6,
            pointHoverRadius: 6,
            data: median,
            backgroundColor: "#fefd54",
            borderColor: "#fefd54",
          },
          {
            type: "scatter",
            label: "Comparison Min",
            data: min,
            pointStyle: "triangle",
            pointRadius: 6,
            pointHoverRadius: 6,
            backgroundColor: "#e33e23",
            borderColor: "#e33e23",
          },
          {
            type: "bar",
            label: "Your Score",
            data: x.data,
            backgroundColor: ["#386FB3"],
          },
        ],
      },
      options: {
        indexAxis: "y",
        scales: {
          y: {
            beginAtZero: true,
          },
        },
      },
    });
  }

  onChange(event) {
    if(!event.target.checked){
      this.standardsChecked.forEach((element,index) => {
        if(element==event.target.value){
          this.standardsChecked.splice(index,1);
        }
      });
      console.log(this.standardsChecked)
    }
    if (event.target.checked) {
      this.standardsChecked.push(event.target.value);
      console.log(this.standardsChecked)
      this.standardIschecked = true;
      this.tsaAnalyticSvc
        .DashboardByStandarsCategoryTSA(
          event.target.value,
          this.sectorId,
          this.sectorindustryId
        )
        .subscribe((x) => {
          this.setupChartStandard(x);
          this.newChart(x);

        });
    } else {
      this.standardIschecked = false;
    }
    // console.log(event.target.value);
  }
  getmodelId(modelId) {}
}
