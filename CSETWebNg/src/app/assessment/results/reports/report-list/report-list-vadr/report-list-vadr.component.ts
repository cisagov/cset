import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-vadr',
  templateUrl: './report-list-vadr.component.html'
})
export class ReportListVADRComponent {

  reportList = [
    {
      linkUrl: "vadrReport"
    },
    {
      linkUrl: "vadrDeficiencyReport"
    },
    {
      linkUrl: "vadrOpenEndedReport"
    }
  ]

}
