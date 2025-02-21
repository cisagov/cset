import { Component } from '@angular/core';

@Component({
    selector: 'app-hydro-executive-summary',
    templateUrl: './hydro-executive-summary.component.html',
    styleUrls: ['./hydro-executive-summary.component.scss'],
    standalone: false
})
export class HydroExecutiveSummaryComponent {
  facilityName: string = 'My Facility';
}
