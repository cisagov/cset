import { Component, OnInit} from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';

@Component({
  selector: 'app-ise-merit',
  templateUrl: './ise-merit.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class IseMeritComponent implements OnInit {
  response: any = null; 
  workPerformedText: string = null;
  resultsOfReviewText: string = null;

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("MERIT Scope Report - ISE");

    this.reportSvc.getAltList().subscribe(
      (r: any) => {
        this.response = r;        
      },
      error => console.log('MERIT Report Error: ' + (<Error>error).message)
    );

    this.workPerformedText= 'Completed the ISE work program.';
    this.resultsOfReviewText = 'No Issues were noted.';

  }



}
