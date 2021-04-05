import { Component, OnInit } from '@angular/core';
import { DomSanitizer, Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-cmmc-comments-marked',
  templateUrl: './cmmc-comments-marked.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss']
})
export class CmmcCommentsMarkedComponent implements OnInit {

  response: any = null;

  constructor(
  public analysisSvc: ReportAnalysisService,
  public reportSvc: ReportService,
  public configSvc: ConfigService,
  private titleService: Title,
  public maturitySvc: MaturityService,
  private sanitizer: DomSanitizer
  ){}

  ngOnInit(): void {
    this.titleService.setTitle("Comments Report - CMMC");

    this.maturitySvc.getCommentsMarked('CMMC').subscribe(
      (r: any) => {
        this.response = r;       
      },
      error => console.log('Comments Marked Report Error: ' + (<Error>error).message)
    );
  }
}
