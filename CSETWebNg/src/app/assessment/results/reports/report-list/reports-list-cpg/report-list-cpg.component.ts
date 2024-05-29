import { Component } from '@angular/core';

@Component({
  selector: 'app-report-list-cpg',
  templateUrl: './report-list-cpg.component.html'
})
export class ReportListCpgComponent {
  reportList = [
    {
      linkUrl: "cpgReport",
    },
    {
      linkUrl: "cpgDeficiency",
    }
  ]
}
