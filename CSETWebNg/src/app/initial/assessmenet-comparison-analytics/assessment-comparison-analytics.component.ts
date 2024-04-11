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
import { Component, OnInit } from "@angular/core";
import { DemographicService } from "../../services/demographic.service";
import { AssessCompareAnalyticsService } from "../../services/assess-compare-analytics.service";
import { TsaService } from "../../services/tsa.service";
import { AssessmentService } from "../../services/assessment.service";
import {
  AssessmentDetail,
  Demographic,
} from "../../models/assessment-info.model";
import { Chart } from "chart.js";
import { ReportAnalysisService } from "../../services/report-analysis.service";

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
  selector: "app-assessment-comparison-analytics",
  templateUrl: "./assessment-comparison-analytics.component.html",
  styleUrls: ["./assessment-comparison-analytics.component.scss"],
  host: { class: "d-flex flex-column flex-11a" },
})
export class AssessmentComparisonAnalyticsComponent implements OnInit {
  assessment: AssessmentDetail = {};
  selectedSector = "All Sectors";
  currentAssessmentId = "";
  currentAssessmentStd = "";
  sampleSize: number = 0;
  assessmentId: string = "";
  chart: any = [];
  answerStandard: string = '';
  answerMaturity: boolean = false;
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
  btnSearch: boolean = true;
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
    public analyticsSvc: AssessCompareAnalyticsService,
    public tsaSvc: TsaService,
    private demoSvc: DemographicService,
    private assessSvc: AssessmentService,
    public analysisSvc: ReportAnalysisService
  ) { }

  ngOnInit(): void {
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentDetail().subscribe((data) => {
        this.standards = [];
        this.assessment = data;
        if (!this.assessment.useMaturity && !this.assessment.useStandard) {
          this.noData = true;
        }
        if (this.assessment.useMaturity) {
          this.isMaturity = true;
          this.maturityModelName = this.assessment.maturityModel.modelName;
          this.maturityModelId = this.assessment.maturityModel.modelId;
          this.analyticsSvc
            .maturityDashboardByCategory(this.assessment.maturityModel.modelId)
            .subscribe((x) => {
              this.setupChartMaturity(x);

            });
        }
        if (this.assessment.useStandard && this.assessment.standards.length > 0) {
          this.isStandard = true;
          this.analyticsSvc.getStandardList().subscribe((x) => {
            x.forEach((element) => {
              this.standards.push(element);
            });

          });
          this.analyticsSvc
            .getSectorIndustryStandardsTSA(
              this.sectorId,
              this.sectorindustryId
            )
            .subscribe((x) => {
              this.chartDataArray = x;
              // this.buildChart();
            });
        }



      });
    }
    this.demographicData.organizationType = null;
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
      min.push({ x: item.minimum, y: yHeight });
      max.push({ x: item.maximum, y: yHeight });
      median.push({ x: item.median, y: yHeight });
      yHeight = yHeight + 10;
    }
    if (x.data.every(x => x === 0)) {
      this.answerStandard = "<mark>In order to create a comparison, please answer at least a few questions on the standard selected. " + x.label + "</mark>";
    }

    document
      .getElementById("test")
      .insertAdjacentHTML(
        "afterend",
        "<div id='" +
        x.label +
        "' class='mt-2'> Model name: " +
        x.label +
        "<tr><td><div><p class='ml-3'>" + this.answerStandard + "</p></div><canvas id='canvas" +
        x.label +
        "'></canvas></td></tr></div>"
      );
    var can_id = "canvas" + x.label;
    const canvas = <HTMLCanvasElement>document.getElementById(can_id);
    const ctx = canvas.getContext("2d");

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
        responsive: true,
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
    this.sectorId = parseInt(sectorId);
    this.populateIndustryOptions(parseInt(sectorId));
    this.btnSearch = false;
    // invalidate the current Industry, as the Sector list has just changed
    this.demographicData.industryId = null;
    this.updateDemographics();
    // update maturity graph
    if (this.assessment.useMaturity) {
      this.analyticsSvc
        .maturityDashboardByCategory(this.assessment.maturityModel.modelId, this.sectorId, this.sectorindustryId)
        .subscribe((x) => {
          this.setupChartMaturity(x);

        });
    }
    // Update standard graph
    if (this.assessment.useStandard && this.assessment.standards.length > 0) {
      this.analyticsSvc
        .getSectorIndustryStandardsTSA(
          this.sectorId,
          this.sectorindustryId)
        .subscribe((x) => {
          this.chartDataArray = x;
          this.standardsChecked.forEach(element => {
            const oldchart = document.getElementById(element);
            oldchart.remove();
            var datachart = this.chartDataArray.find(
              (x) => x.label == element
            );
            this.answerStandard = "";
            this.setupChartStandard(datachart);
          });
        });
    }
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

    // this.updateDemographics();
  }
  update(event: any) {
    this.sectorindustryId = event.target.value;
    if (this.sectorindustryId.toString() == '0: null') {
      this.sectorindustryId = null
    }
    // update maturity graph
    if (this.assessment.useMaturity) {
      this.analyticsSvc
        .maturityDashboardByCategory(this.assessment.maturityModel.modelId, this.sectorId, this.sectorindustryId)
        .subscribe((x) => {
          this.setupChartMaturity(x);

        });
    }
    // Update standard graph
    if (this.assessment.useStandard && this.assessment.standards.length > 0) {
      this.analyticsSvc
        .getSectorIndustryStandardsTSA(
          this.sectorId,
          this.sectorindustryId)
        .subscribe((x) => {
          this.chartDataArray = x;
          this.standardsChecked.forEach(element => {
            const oldchart = document.getElementById(element);
            oldchart.remove();
            var datachart = this.chartDataArray.find(
              (x) => x.label == element
            );
            this.answerStandard = "";
            this.setupChartStandard(datachart);
          });
        });
    }
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
  }
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
  }

  checkValue(event: any) {
    // console.log(event);
    // console.log(event.source.name);
  }
  setupChartMaturity(x: any) {
    let titles = [];
    let min = [];
    let max = [];
    let median = [];
    let yHeight = 40;
    for (let i = 0; i < x.dataRowsMaturity.length; i++) {
      let item = x.dataRowsMaturity[i];

      min.push({ x: item.minimum, y: yHeight });
      max.push({ x: item.maximum, y: yHeight });
      median.push({ x: item.median, y: yHeight });
      yHeight = yHeight + 10;
    }
    if (x.data.every(x => x === 0)) {
      this.answerMaturity = true;
    }
    let tempChart = Chart.getChart("canvasStandardResult1");
    if (tempChart) {
      tempChart.destroy();
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
        responsive: true,
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
      this.answerStandard = "";
      this.setupChartStandard(datachart);
    } else {
      this.standardIschecked = false;
    }
  }

  getmodelId(modelId) { }
}
