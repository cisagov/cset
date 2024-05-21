import { Component } from '@angular/core';

@Component({
  selector: 'app-reports-list-cpg',
  templateUrl: './reports-list-cpg.component.html'
})
export class ReportsListCpgComponent {
  reportList = [
    {
      linkUrl: "cpgReport",
    },
    {
      linkUrl: "cpgDeficiency",
    }
  ]
}
