import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-edm',
  templateUrl: './report-list-edm.component.html'
})
export class ReportListEdmComponent {

  reportList = [
    {
      linkUrl: "edm",
      securityPicker: true
    },
    {
      linkUrl: "edm",
      print: true
    },
    {
      linkUrl: "edmDeficiencyReport"
    },
    {
      linkUrl: "edmCommentsmarked"
    }
  ];

}
