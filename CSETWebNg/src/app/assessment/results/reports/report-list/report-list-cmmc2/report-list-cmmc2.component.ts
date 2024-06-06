import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-cmmc2',
  templateUrl: './report-list-cmmc2.component.html'
})
export class ReportListCmmc2Component {

  reportList = [
    {
      linkUrl: "executivecmmc2"
    },
    {
      linkUrl: "cmmc2DeficiencyReport"
    },
    {
      linkUrl: "cmmc2CommentsMarked"
    }
  ]

}
