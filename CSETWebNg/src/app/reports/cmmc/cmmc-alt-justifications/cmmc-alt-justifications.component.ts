import { Component, OnInit } from '@angular/core';
import { DomSanitizer, Title } from '@angular/platform-browser';
import { ACETService } from '../../../services/acet.service';
import { ConfigService } from '../../../services/config.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-cmmc-alt-justifications',
  templateUrl: './cmmc-alt-justifications.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss']
})
export class CmmcAltJustificationsComponent implements OnInit {

  response: any = null; 

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Alternate Justification Report - CMMC");

    this.reportSvc.getAltList().subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Alternate Justification Report Error: ' + (<Error>error).message)
    );
  }
}
