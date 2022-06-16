import { Component, OnInit } from '@angular/core';
import { DomSanitizer, Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-crr-comments-marked',
  templateUrl: './crr-comments-marked.component.html',
  styleUrls: ['../../reports.scss', '../../acet-reports.scss']
})
export class CrrCommentsMarkedComponent implements OnInit {

  response: any = null;

  loading: boolean = false;

  constructor(
  public analysisSvc: ReportAnalysisService,
  public reportSvc: ReportService,
  public configSvc: ConfigService,
  private titleService: Title,
  public maturitySvc: MaturityService,
  private sanitizer: DomSanitizer
  ){}

  ngOnInit(): void {
    this.loading = true;
    this.titleService.setTitle("Comments Report - CISA CRR");

    this.maturitySvc.getCommentsMarked().subscribe(
      (r: any) => {
        this.response = r;
        this.loading = false;
      },
      error => console.log('Comments Marked Report Error: ' + (<Error>error).message)
    );
  }
}
