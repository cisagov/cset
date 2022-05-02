import { Component, Input, OnInit } from "@angular/core";
import { DemographicService } from "../../services/demographic.service";
import { TsaAnalyticsService } from "../../services/tsa-analytics.service";
import { TsaService } from "../../services/tsa.service";
import { AssessmentService } from "../../services/assessment.service";
import {
  AssessmentDetail,
  Demographic,
} from "../../models/assessment-info.model";
import { Chart } from "chart.js";
import { ReportAnalysisService } from "../../services/report-analysis.service";
import { User } from "../../models/user.model";

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
  selectedSector = "All Sectors";
  currentAssessmentId = "";
  currentAssessmentStd = "";
  sampleSize: number = 0;
  assessmentId: string = "";
  chart: any = [];

  noData: boolean = false;

  initialized = false;
  chart1: any = [];
  maturityModelId: number;
  isStandard: boolean = false;
  isMaturity: boolean = false;
  maturityModelName: string = "";
  sectorsList: Sector[];
  sizeList: AssessmentSize[];
  assetValues: DemographicsAssetValue[];
  industryList: Industry[];
  btnSearch:boolean=true;
  demographicData: Demographic = {};
  orgTypes: any[];
  standards: StandardsNames[];
  standardsChecked: any = [];
  ischecked: boolean = false;
  standardIschecked: boolean = false;
  sectorId: number;
  sectorindustryId: number;
  chartDataArray: any[];
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
        console.log(this.assessment)

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
                console.log(x);
              });
          }
          if (this.assessment.useStandard && this.assessment.standards.length>0) {
            this.isStandard = true;
            this.tsaAnalyticSvc.getStandardList().subscribe((x) => {
              x.forEach((element) => {
                this.standards.push(element);
              });
              console.log(this.standards)
            });
            this.tsaAnalyticSvc
              .getSectorIndustryStandardsTSA(
              this.sectorId,
                this.sectorindustryId
              )
              .subscribe((x) => {
                this.chartDataArray = x;
                console.log(this.chartDataArray);
                // this.buildChart();
              });
          }



      });
    }
    this.demographicData.organizationType=null;
     this.demographicData.sectorId = null;
    this.currentAssessmentId = this.assessment.id?.toString();
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

    this.getOrganizationTypes();
    if (this.demographicData.assessment_Id == null) {
      this.populateIndustryOptions(this.demographicData.sectorId);
      this.demographicData.industryId = null;
      this.updateDemographics();
    }
  }

  newChart(x: any) {
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
      median.push({ x: item.avg, y: yHeight });
      yHeight = yHeight + 10;
    }

    document
      .getElementById("test")
      .insertAdjacentHTML(
        "afterend",
        "<div id='" +
          x.label +
          "' class='mt-2'> Model name: " +
          x.label +
          "<tr><td><canvas id='canvas" +
          x.label +
          "'></canvas></td></tr></div>"
      );
    var can_id = "canvas" + x.label;
    const canvas = <HTMLCanvasElement>document.getElementById(can_id);
    const ctx = canvas.getContext("2d");
    // console.log(cont);
    this.can_id = new Chart(ctx, {
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

    this.can_id.update();
    return x;
  }

 onSelectSector(sectorId: string) {
    this.sectorId=parseInt(sectorId);
    this.populateIndustryOptions(parseInt(sectorId));
    this.btnSearch=false;
    // invalidate the current Industry, as the Sector list has just changed
    this.demographicData.industryId = null;
    this.updateDemographics();
    this.tsaAnalyticSvc
    .getSectorIndustryStandardsTSA(
      this.sectorId,
     this.sectorindustryId)
    .subscribe((x) => {
      this.chartDataArray = x;
      console.log(this.standardsChecked);
      console.log(this.chartDataArray);
     this.standardsChecked.forEach(element => {
      const oldchart = document.getElementById(element);
      oldchart.remove();
      var datachart = this.chartDataArray.find(
        (x) => x.label ==element
      );
      this.newChart(datachart);
      });
    });
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
    console.log(event.target.value);
    // this.updateDemographics();
  }
  update(event: any) {
    this.sectorindustryId=event.target.value;
     this.tsaAnalyticSvc
  .getSectorIndustryStandardsTSA(
    this.sectorId,
    this.sectorindustryId)
  .subscribe((x) => {
    this.chartDataArray = x;
    console.log(this.standardsChecked);
    console.log(this.chartDataArray);
   this.standardsChecked.forEach(element => {
    const oldchart = document.getElementById(element);
    oldchart.remove();
    var datachart = this.chartDataArray.find(
      (x) => x.label ==element
    );
    this.newChart(datachart);

   });
  });
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
    console.log(sector);
  }
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
  }

  checkValue(event: any) {
    // console.log(event);
    // console.log(event.source.name);
  }

  setupChartStandard(x: any) {
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
        responsive: true,
      },

    });

    this.initialized = true;
  }

  setuptest(x: any) {
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
    if (!event.target.checked) {
      this.standardsChecked.forEach((element, index) => {
        if (element == event.target.value) {
          this.standardsChecked.splice(index, 1);
          const element = document.getElementById(event.target.value);
          element.remove();
        }
      });
    }
    if (event.target.checked) {
      this.standardsChecked.push(event.target.value);
      this.standardIschecked = true;
      var datachart = this.chartDataArray.find(
        (x) => x.label == event.target.value
      );
      this.newChart(datachart);
    } else {
      this.standardIschecked = false;
    }
  }
  // searchbySectorIndustry(){
  //   this.tsaAnalyticSvc
  //   .getSectorIndustryStandardsTSA(
  //     this.sectorId,
  //     this.sectorindustryId)
  //   .subscribe((x) => {
  //     this.chartDataArray = x;
  //     console.log(this.standardsChecked);
  //     console.log(this.chartDataArray);
  //    this.standardsChecked.forEach(element => {
  //     const oldchart = document.getElementById(element);
  //     oldchart.remove();
  //     var datachart = this.chartDataArray.find(
  //       (x) => x.label ==element
  //     );
  //     this.newChart(datachart);

  //    });
  //   });

  // }

  getmodelId(modelId) {}
}
