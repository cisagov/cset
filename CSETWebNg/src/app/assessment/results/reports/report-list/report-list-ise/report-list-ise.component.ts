import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-ise',
  templateUrl: './report-list-ise.component.html'
})
export class ReportListISEComponent {

  reportList = [
    {
      linkUrl: "isemerit"
    },
    {
      linkUrl: "iseexamination"
    },
    {
      linkUrl: "iseansweredquestions"
    },
    {
      linkUrl: "iseexaminer"
    }
  ]

}
