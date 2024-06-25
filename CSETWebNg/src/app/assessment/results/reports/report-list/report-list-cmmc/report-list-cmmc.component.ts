import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-cmmc',
  templateUrl: './report-list-cmmc.component.html'
})
export class ReportListCmmcComponent {

  reportList = [
    {
      linkUrl: "executivecmmc", 
    },
    {
      linkUrl: "sitesummarycmmc", 
    },
    {
      linkUrl: "cmmcDeficiencyReport", 
    }, 
    {
      linkUrl: "cmmcCommentsMarked", 
    }, 
    {
      linkUrl: "cmmcAltJustifications", 
    }
  ]

}
