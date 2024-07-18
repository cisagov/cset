import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-acet',
  templateUrl: './report-list-acet.component.html'
})
export class ReportListACETComponent {

  reportList = [
    {
      linkUrl: "acetexecutive"
    },
    {
      linkUrl: "acetgaps"
    },
    {
      linkUrl: "acetcommentsmarked"
    },
    {
      linkUrl: "acetansweredquestions"
    },
    {
      linkUrl: "acetcompensatingcontrols"
    }
  ]

}
