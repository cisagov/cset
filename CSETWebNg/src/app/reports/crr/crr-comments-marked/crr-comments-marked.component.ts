import { CrrReportModel } from './../../../models/reports.model';
import { CrrService } from './../../../services/crr.service';
import { Component, OnInit } from '@angular/core';
import { DomSanitizer, Title } from '@angular/platform-browser';
import { ConfigService } from '../../../services/config.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-crr-comments-marked',
  templateUrl: './crr-comments-marked.component.html',
  styleUrls: ['./../crr-report/crr-report.component.scss']
})
export class CrrCommentsMarkedComponent implements OnInit {

  crrModel: CrrReportModel;

  loading: boolean = false;

  keyToCategory = {
    'AM':  'Asset Management',
    'CM':  'Controls Management',
    'CCM': 'Configuration and Change Management',
    'VM':  'Vulnerability Management',
    'IM':  'Incident Management',
    'SCM': 'Service Continuity Management',
    'RM': 'Risk Management',
    'EDM': 'External Dependencies Management',
    'TA':  'Training and Awareness',
    'SA':  'Situational Awareness'
  };



  constructor(
  public analysisSvc: ReportAnalysisService,
  public reportSvc: ReportService,
  public configSvc: ConfigService,
  private titleService: Title,
  private crrSvc: CrrService
  ){}

  ngOnInit(): void {
    this.loading = true;
    this.titleService.setTitle("Comments Report - CISA CRR");

    this.crrSvc.getCrrModel().subscribe(
      (r: CrrReportModel) => {
        this.crrModel = r;



        this.loading = false;
      },
      error => console.log('Comments Marked Report Error: ' + (<Error>error).message)
    );
  }
}
