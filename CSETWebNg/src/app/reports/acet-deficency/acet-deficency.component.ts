import { Component, OnInit } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { QuestionsService } from '../../services/questions.service';
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';


@Component({
  selector: 'app-acet-deficency',
  templateUrl: './acet-deficency.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetDeficencyComponent implements OnInit {
  response: any;

  loading: boolean = false;

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    private titleService: Title,
    public acetSvc: ACETService
  ) { }

  ngOnInit() {
    this.loading = true;
    this.titleService.setTitle("Gap Report - ACET");

    this.acetSvc.getAnsweredQuestions().subscribe(
      (r: any) => {
        this.response = r;
        this.loading = false;
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
