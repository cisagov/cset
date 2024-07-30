import { Component, Input, OnInit } from '@angular/core';


@Component({
  selector: 'app-report-list-common',
  templateUrl: './report-list-common.component.html'
})
export class ReportListCommonComponent implements OnInit {

@Input()
sectionId: string;

@Input()
confidentiality: boolean;

jsonData: any;

reportList: [];
    constructor() {
        this.jsonData = require('./report-list.json');
        this.reportList = this.getReportList(this.sectionId)
    }

  ngOnInit(): void {
  }

  getReportList(sectionId: string){
    // Find the object with the matching title
  const result = this.jsonData.find(item => item.sectionId === sectionId);
  // Check if the result exists and return the reportList or an empty array if not found
  return result ? result.reportList : [];
  }
}