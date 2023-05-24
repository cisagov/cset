import { Component } from '@angular/core';

@Component({
  selector: 'app-hydro-results-summary',
  templateUrl: './hydro-results-summary.component.html',
  styleUrls: ['./hydro-results-summary.component.scss']
})
export class HydroResultsSummaryComponent {
  facilityName: string = 'My Facility';
  completionDate: string = '2023/05/23';
  riskScore: number = 0.12;
  varNecessity: string = 'Moderate';
}
