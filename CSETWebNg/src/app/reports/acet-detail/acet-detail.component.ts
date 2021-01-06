import { Component, OnInit, AfterViewChecked, AfterViewInit } from '@angular/core';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ReportService } from '../../services/report.service';


@Component({
  selector: 'app-acet-detail',
  templateUrl: './acet-detail.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetDetailComponent implements OnInit {
  response: any = null;
  mockDataAcetDetail: any = {
    "information": {
      "Assessment_Name": "Manhattan Assessment",
      "Assessment_Date": "2020-09-19",
      "Assessor_Name": "Michael Jones"
    }
  };

  

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,

  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Detailed Report - ACET");
    // Here get report data
    // ToDo: Uncomment this and connect backend for report data
    //this.reportSvc.getReport('<ACET Endpoint>').subscribe(
    //  (r: any) => {
    //    this.response = r;
    //  },
    //  error => console.log('Executive report load Error: ' + (<Error>error).message)
    //);
    this.response = this.mockDataAcetDetail;
  }

}
