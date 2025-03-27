import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { AnalyticsService } from '../../../services/analytics.service';
import { NavigationService } from '../../../services/navigation/navigation.service';
import Chart, { ChartConfiguration, ChartType, registerables } from 'chart.js/auto';
import { AssessmentService } from '../../../services/assessment.service';
import { AggregationService } from '../../../services/aggregation.service';
import { AssessmentDetail } from '../../../models/assessment-info.model';
import { DemographicService } from '../../../services/demographic.service';
import { DemographicIodService } from '../../../services/demographic-iod.service';
import { TranslocoService } from '@jsverse/transloco';

Chart.register(...registerables);

interface Sector {
  sectorId: number;
  sectorName: string;
}

interface DemographicsIod {
  listSectors: listSectors[];
}

interface listSectors {
  optionValue: number;
  optionText: string;
}
@Component({
    selector: 'app-analytics-results',
    templateUrl: './analytics-results.component.html',
    styleUrls: ['./analytics-results.component.scss'],
    standalone: false
})
export class AnalyticsResultsComponent implements OnInit {

  sectorId: number;
  modelId: number;
  minData: number[] = [];
  medianData: number[] = [];
  maxData: number[] = [];
  currentUserData: number[] = [];
  labels: string[] = [];
  sectorsList: Sector[];
  sectorTitle: string;
  showSector: boolean = true;
  sampleSize: number;
  allSectors: string = 'All Sectors';


  @ViewChild('barCanvas') private barCanvas!: ElementRef<HTMLCanvasElement>;
  private barChart!: Chart;

  // result from API call
  scoreBarData: any;

  // Toggle state
  dataType: "mySector" | "allSectors" = "mySector";

  constructor(
    public navSvc: NavigationService,
    public analyticsSvc: AnalyticsService,
    public assessSvc: AssessmentService,
    public aggregSvc: AggregationService,
    public demoSvc: DemographicService,
    public demoIodSvc: DemographicIodService,
    public tSvc: TranslocoService
  ) { }

  ngOnInit(): void {
    this.assessSvc.getAssessmentDetail().subscribe((resp: AssessmentDetail) => {
      this.sectorId = resp.sectorId;
      this.modelId = resp.maturityModel.modelId;
      if (this.sectorId == null) {
        this.showSector = false;
        this.dataType = "allSectors"
      }
      let isCISA = this.analyticsSvc.isCisaAssessorMode()
      if (isCISA) {
        this.demoIodSvc.getDemographics().subscribe((resp: DemographicsIod) => {
          resp.listSectors.forEach(sector => {
            if (sector.optionValue == this.sectorId) {
              this.sectorTitle = this.tSvc.translate('analytics.' + sector.optionText)
            }
          });
        })
      } else {
        this.demoSvc.getAllSectors().subscribe(
          (data: Sector[]) => {
            this.sectorsList = data;
            this.sectorsList.forEach(sector => {
              if (sector.sectorId == this.sectorId) {
                this.sectorTitle = sector.sectorName
              }
            });
          }
        )
      }
      // Fetch initial data after getting assessment details
      this.getAnalyticsResults();
    });
  }


  // Get analytics results for specified sector 
  private async getAnalyticsResults(allSectors?: boolean): Promise<void> {
    try {
      let result = null;
      if (allSectors) {
        result = await this.analyticsSvc.getAnalyticResults(this.modelId).toPromise();
      } else {
        result = await this.analyticsSvc.getAnalyticResults(this.modelId, this.sectorId).toPromise();
      }
      this.scoreBarData = result;
      this.sampleSize = result.sampleSize;
    } catch (error) {
      console.error('Error fetching analytics results', error);
    }
  }

  toggleData(event: any): void {
    this.dataType = event.value;
    if (this.dataType === "allSectors") {
      this.getAnalyticsResults(true);
    } else {
      this.getAnalyticsResults();
    }
  }

}
