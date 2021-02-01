import { Component, OnInit, AfterViewChecked } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { AcetDashboard } from '../../models/acet-dashboard.model';
import { AdminTableData, AdminPageData, HoursOverride } from '../../models/admin-save.model';
import { MaturityService } from '../../services/maturity.service';


@Component({
  selector: 'app-acet-deficency',
  templateUrl: './acet-deficency.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetDeficencyComponent implements OnInit {
  response: any;

  constructor(
  public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public maturitySvc: MaturityService
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Deficiency Report - ACET");

    this.maturitySvc.getMaturityDeficiency("ACET").subscribe(
      (r: any) => {
        this.response = r;        
      },
      error => console.log('Deficiency Report Error: ' + (<Error>error).message)
    );
  }

}
