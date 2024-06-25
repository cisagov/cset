import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-diagram',
  templateUrl: './report-list-diagram.component.html'
})
export class ReportListDiagramComponent {

  reportList = [
    {
      linkUrl: "executive"
    },
    {
      linkUrl: "sitesummary"
    },
    {
      linkUrl: "securityplan"
    },
    {
      linkUrl: "detail"
    }
  ];
}
