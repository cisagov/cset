import { Component, OnInit} from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';
import { QuestionsService } from '../../services/questions.service';

@Component({
  selector: 'app-ise-issues',
  templateUrl: './ise-issues.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class IseIssuesComponent implements OnInit {
  response: any = null; 

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Issues Report - ISE");

    this.reportSvc.getAltList().subscribe(
      (r: any) => {
        this.response = r;        
      },
      error => console.log('Issues Report Error: ' + (<Error>error).message)
    );
  }

}
