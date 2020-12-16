import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';


@Component({
  selector: 'app-acet-document',
  templateUrl: './acet-document.component.html',
  styleUrls: ['./acet-document.component.scss']
})
export class AcetDocumentComponent implements OnInit {
  response: any = null;
  mockDataAcetDocument: any = {
    "information": {
      "Assessment_Name": "Manhattan Assessment",
      "Assessment_Date": "2020-09-19",
      "Assessor_Name": "Michael Jones"
    },
    "documents_list": [
      { "id": 1, "included": false, "name": "document 1", "comments": "best doc" }, 
      { "id": 2, "included": true, "name": "document 1", "comments": "best doc" }
      { "id": 3, "included": false, "name": "document 3", "comments": "best doc" }
    ],
    "librarys": [
      {"id": 1, "title": "lib 1", "file_name": "file.json"},
      { "id": 2, "title": "lib 2", "file_name": "file.py" }
    ]
  };

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Documents Report - ASET");
    // Here get report data
    // ToDo: Uncomment this and connect backend for report data
    //this.reportSvc.getReport('<ACET Endpoint>').subscribe(
    //  (r: any) => {
    //    this.response = r;
    //  },
    //  error => console.log('Executive report load Error: ' + (<Error>error).message)
    //);
    this.response = this.mockDataAcetDocument;
  }

}
