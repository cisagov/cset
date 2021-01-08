import { Component, OnInit} from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';

@Component({
  selector: 'app-acet-commentsmarked',
  templateUrl: './acet-commentsmarked.component.html',
  styleUrls: ['../reports.scss']
})
export class AcetCommentsmarkedComponent implements OnInit {
  response: any = null;  

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public acetSvc: ACETService,
    private sanitizer: DomSanitizer
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Comments Report - ACET");

    this.acetSvc.getCommentsMarked().subscribe(
      (r: any) => {
        this.response = r;        
      },
      error => console.log('Deficiency Report Error: ' + (<Error>error).message)
    );
  }


}
