import { Component, OnInit } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';
import { forEach } from 'lodash';
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
    public acetSvc: ACETService
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Gap Report - ACET");

    this.acetSvc.getAnsweredQuestions().subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Gap Report Error: ' + (<Error>error).message)
    );
  }

  checkForGaps() {
    for (let d of this.response?.matAnsweredQuestions) {
      if (d.isDeficient) {
        return true;
      }
    }
    return false;
  }
}
