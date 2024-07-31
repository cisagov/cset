import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';


@Component({
  selector: 'app-report-list-common',
  templateUrl: './report-list-common.component.html'
})

export class ReportListCommonComponent implements OnChanges{
    @Input() sectionId: string;
  
    jsonData: any;
    reportList: any[] = [];
  
    constructor() {
      // Load JSON data 
      this.jsonData = require('./report-list.json');
    }
  
    ngOnChanges(changes: SimpleChanges): void {
      if (changes['sectionId']) {
        this.reportList = this.getReportList(this.sectionId);
      }
    }
  
    getReportList(sectionId: string): any[] {
      // Find the object with the matching title
      const result = this.jsonData.find(item => item.title === sectionId);
      // Check if the result exists and return the reportList or an empty array if not found
      return result ? result.reportList : [];
    }
}