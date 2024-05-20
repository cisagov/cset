import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-crr',
  templateUrl: './report-list-crr.component.html'
})
export class ReportListCrrComponent {

  reportList = [
    {
      linkUrl: "crrreport",
      securityPicker: true
    },
    {
      linkUrl: "crrDeficiencyReport"
    },
    {
      linkUrl: "crrCommentsMarked"
    }
  ];
}
