import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-rra',
  templateUrl: './report-list-rra.component.html'
})
export class ReportListRraComponent {
  reportList = [
    {
      linkUrl: "rrareport",
    },
    {
      linkUrl: "rraDeficiencyReport",
    },
    {
      linkUrl: "commentsmfr",
    }
  ]
}
