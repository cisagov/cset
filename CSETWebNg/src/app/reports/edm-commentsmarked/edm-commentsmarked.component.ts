import { Component, OnInit} from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { MaturityService } from '../../services/maturity.service';

@Component({
  selector: 'app-edm-commentsmarked',
  templateUrl: './edm-commentsmarked.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class EdmCommentsmarkedComponent implements OnInit {
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
    this.titleService.setTitle("Comments Report - EDM");

    this.maturitySvc.getCommentsMarked('EDM').subscribe(
      (r: any) => {
        this.response = r;       
      },
      error => console.log('Comments Marked Report Error: ' + (<Error>error).message)
    );
  }
}
