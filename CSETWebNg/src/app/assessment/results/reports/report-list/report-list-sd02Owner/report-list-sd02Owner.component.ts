import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-sd02Owner',
  templateUrl: './report-list-sd02Owner.component.html'
})
export class ReportListSD02OwnerComponent {

  reportList = [
    {
      linkUrl: "sdo-gap-report"
    },
    {
      linkUrl: "sdo-comments-and-mfr"
    }
  ]

}
