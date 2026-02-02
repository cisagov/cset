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
  showSector: boolean = true;
  sampleSize: number;
  allSectors: string = 'All Sectors';

  mySectors: any[];

  // result from API call
  scoreBarData: any;


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

      this.modelId = resp.maturityModel.modelId;
      const isCISA = this.analyticsSvc.isCisaAssessorMode();
      if (isCISA) {
        this.analyticsSvc.getSampleSizes().then((g: any[]) => {
          this.mySectors = [...g];
        });

        // Fetch initial data after getting assessment details
        this.getAnalyticsResults(0);
      }
    });
  }

  /**
   * Handle the change of target sector by user
   */
  onChangeSectorSelection(event: any): void {
    const targetSectorId = event.target.value;
    this.getAnalyticsResults(targetSectorId);
  }

  /**
   * Get analytics results for target sector (or all assessments)
   */
  private async getAnalyticsResults(sectorId?: number): Promise<void> {
    try {
      this.scoreBarData = null;
      let result = null;

      if (sectorId == undefined || sectorId == 0) {
        result = await this.analyticsSvc.getAnalyticResults(this.modelId).toPromise();
      } else {
        result = await this.analyticsSvc.getAnalyticResults(this.modelId, sectorId).toPromise();
      }

      this.scoreBarData = result;
    } catch (error) {
      console.error('Error fetching analytics results', error);
    }
  }
}
