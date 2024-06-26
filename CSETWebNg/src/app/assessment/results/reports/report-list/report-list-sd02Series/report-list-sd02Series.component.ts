import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-sd02Series',
  templateUrl: './report-list-sd02Series.component.html'
})
export class ReportListSD02SeriesComponent {

  reportList = [
    {
      linkUrl: "sd-answer-summary"
    },
    {
      linkUrl: "sd-deficiency"
    },
    {
      linkUrl: "commentsmfr"
    }
  ]

}
