import { Component, OnInit} from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { QuestionsService } from './../../services/questions.service';
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { ACETService } from '../../services/acet.service';

@Component({
  selector: 'app-acet-compensatingcontrols',
  templateUrl: './acet-compensatingcontrols.component.html',
  styleUrls: ['../reports.scss', '../acet-reports.scss']
})
export class AcetCompensatingcontrolsComponent implements OnInit {
  response: any = null;

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.titleService.setTitle("Compensating Controls Report - ACET");

    this.reportSvc.getAltList().subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Compensating Controls Report Error: ' + (<Error>error).message)
    );
  }

}
