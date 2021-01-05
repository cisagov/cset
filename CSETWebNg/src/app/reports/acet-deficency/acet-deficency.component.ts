import { Component, OnInit, AfterViewChecked } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title, DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { AcetDashboard } from '../../models/acet-dashboard.model';
import { AdminTableData, AdminPageData, HoursOverride } from '../../models/admin-save.model';
import { ACETService } from '../../services/acet.service';


@Component({
  selector: 'app-acet-deficency',
  templateUrl: './acet-deficency.component.html',
  styleUrls: ['../reports.scss']
})
export class AcetDeficencyComponent implements OnInit {
  response: any;

  constructor(
  public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public configSvc: ConfigService,
    private titleService: Title,
    public acetSvc: ACETService,
    private sanitizer: DomSanitizer
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Deficiency Report - ACET");

    this.acetSvc.getAcetDeficiency().subscribe(
      (r: any) => {
        this.response = r;        
        console.log(r);
      },
      error => console.log('Deficiency Report Error: ' + (<Error>error).message)
    );
  }

}
